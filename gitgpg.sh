# Git-GPG.
# Version: 1.0
# Written by Metaspook
# License: <http://opensource.org/licenses/MIT>
# Copyright (c) 2019 Metaspook.

#~~~~ VARIABLES ~~~~
vn=v1.0
GITGPG="${0##*/}"
CDATE=$(date -I)
#~~~~ FUNCTIONS ~~~~
fnbanner(){
echo -e "
  ==================================
     Git - G P G  | Version: $vn
| ==================================
| GnuPG, OpenPGP Key generator for Git.
| Generates GitHub/GitLab standerd GPG Keys.
| Written by Metaspook

"
}

EntryProcess(){
     clear; fnbanner
     echo -e " [NOTE] Time depends on Passphrase lenth and Processor.\n\nGenerating GPG Key for Git...Please wait..."
     cat >foo <<EOF
%echo Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $RNAME
$COMMENTEXT
Name-Email: $EMAIL
Expire-Date: 0
Creation-Date: $CDATE
Passphrase: $PASSP
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF
     (gpg --batch --gen-key foo && rm -f foo
     gpg  --output "pgp-key-${CDATE//-/}-${RNAME// /_}-public.asc" --armor --export $EMAIL
     gpg  --pinentry-mode loopback --passphrase $PASSP --output "pgp-key-${CDATE//-/}-${RNAME// /_}-private.asc" --armor --export-secret-keys $EMAIL) &>/dev/null
     #gpg --output "pgp-key-${CDATE//-/}-${RNAME// /_}-revoke.asc" --gen-revoke $EMAIL
     clear; fnbanner
     echo -e "[DONE] Public and Private GPG Keys for\n       Git are generated and exported."
}

MainChk(){
     clear; fnbanner
     echo -e "Checking binaries...\n"
     if [ "`gpg --help`" ]; then
          echo "[OK] `gpg --version | head -n1`"
          sleep 2
     else
          echo "[FAIL!] 'gpg' not installed."
          sleep 2; exit
     fi
}

ChkEntryMenu(){
     ChkEntry01(){
     clear; fnbanner
     echo -n "
|  Real Name: $RNAME
|    Comment: $COMMENT
|     E-mail: $EMAIL
| Passphrase: $PASSP

 Confirm all entries? Enter 'Y' or blank to Yes 
                      Enter 'N' to No (re-entry)
 Enter Option: "
          read -rsn1 coin00
          case $coin00 in n|N) ChkEntryMenu;; esac
     }
     EntryMenu03(){
          clear; fnbanner
          echo -e " [NOTE] Passphrase entries will be invisible.\n"
          echo -n "| Passphrase: "
          read -s PASSP
          if [ "${#PASSP}" -lt 5 ]; then
               echo -e "\n\n[FAIL!] Passphrase is not valid."
               sleep 2
               EntryMenu03
          fi
     }
     EntryMenu02(){
          clear; fnbanner
          read -p "| E-mail: " EMAIL
          case $EMAIL in
          *@*.*) EntryMenu03;;
          *) echo -e "\n[FAIL!] E-mail is not valid."; sleep 2; EntryMenu02;;
          esac
     }
     EntryMenu01(){
          clear; fnbanner
          echo -e " [NOTE] Comment is optional can leave blank.\n"
          read -p "| Real Name: " RNAME
          read -p "|   Comment: " COMMENT
          if [ ! "$RNAME" ]; then
               echo -e "\n[FAIL!] Real Name is not valid."
               sleep 2
               EntryMenu01
          fi
          [ "$COMMENT" ] && COMMENTEXT="Name-Comment: $COMMENT"
     }
     ## Run Entry Menus and Check.
     EntryMenu01
     EntryMenu02
     ChkEntry01
}

#----< CALL CENTER >----#
case $1 in
	#donecom) fndonecom; exit;;
	*) MainChk; ChkEntryMenu; EntryProcess;;
esac
exit 0

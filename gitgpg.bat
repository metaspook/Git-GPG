:: Git-GPG.
:: Version: 1.0
:: Written by Metaspook
:: License: <http://opensource.org/licenses/MIT>
:: Copyright (c) 2019 Metaspook.
:: 
@echo off
busybox sh gitgpg.sh
>nul 2>&1 timeout /t 3
REM Sometime Batch script behaves weird like not clearing screen properly.
REM Problem with the .cmd extension or what exactly?

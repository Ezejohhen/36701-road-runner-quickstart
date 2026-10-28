@echo off
setlocal
title Team 36701 - Connect Control Hub
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0connect-control-hub.ps1" %*
set "helperExit=%ERRORLEVEL%"
echo.
pause
exit /b %helperExit%

@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0VERIFY.ps1"
set "VERIFY_EXIT=%ERRORLEVEL%"
echo.
if not "%VERIFY_EXIT%"=="0" (
  echo VERIFICATION FAILED with exit code %VERIFY_EXIT%.
) else (
  echo VERIFICATION PASSED.
)
pause
exit /b %VERIFY_EXIT%

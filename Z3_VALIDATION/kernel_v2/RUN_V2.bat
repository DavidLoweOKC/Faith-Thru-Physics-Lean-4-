@echo off
setlocal
set "REPO_ROOT=%~dp0..\.."
set "LOCAL_PYTHON=%REPO_ROOT%\.venv-z3\Scripts\python.exe"
if exist "%LOCAL_PYTHON%" (
  "%LOCAL_PYTHON%" "%~dp0kernel_v2.py" %*
) else (
  where py >nul 2>nul
  if not errorlevel 1 (
    py "%~dp0kernel_v2.py" %*
  ) else (
    python "%~dp0kernel_v2.py" %*
  )
)
exit /b %errorlevel%

@echo off

setlocal

if "%PYL4WIN_PYTHON_ARCH%" == "" (
    if "%PROCESSOR_ARCHITECTURE%" == "x86" set PYL4WIN_PYTHON_ARCH="x86"
    if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set PYL4WIN_PYTHON_ARCH=""
    if "%PROCESSOR_ARCHITECTURE%" == "ARM64" (
	    echo ARM not supported yet!
	    exit
    )
)

if "%PYL4WIN_HOME%" == "" set PYL4WIN_HOME=%USERPROFILE%\.pyl4win
if "%PYL4WIN_NUGET_EXE%" == "" set PYL4WIN_NUGET_EXE=%PYL4WIN_HOME%\nuget.exe

set _NUGET_CMD_ARGS=

if "%PYL4WIN_PYTHON_VERSION%" == "" set PYL4WIN_PYTHON_VERSION="3.11.7"

set _NUPKG_PYTHON_VERSION=.%PYL4WIN_PYTHON_VERSION%
set _NUGET_CMD_ARGS=%_NUGET_CMD_ARGS% -Version %PYL4WIN_PYTHON_VERSION%

if not exist "%PYL4WIN_HOME%" mkdir %PYL4WIN_HOME%

set PYL4WIN_PYTHON_EXE="%PYL4WIN_HOME%\python%PYL4WIN_PYTHON_ARCH%%_NUPKG_PYTHON_VERSION%\tools\python.exe"

if not exist "%PYL4WIN_PYTHON_EXE%" (
	if not exist "%PYL4WIN_NUGET_EXE%" (
        powershell -Command Invoke-WebRequest "https://aka.ms/nugetclidl" -OutFile "%PYL4WIN_NUGET_EXE%"
	)
	nuget install python%PYL4WIN_PYTHON_ARCH% %_NUGET_CMD_ARGS% -OutputDir %PYL4WIN_HOME%
)

cmd /C %PYL4WIN_PYTHON_EXE% %*
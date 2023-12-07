@echo off
:install
cls
setlocal enabledelayedexpansion

for /f "tokens=*" %%a in ('whoami') do set "FULL_NAME=%%a"
for /f "tokens=2 delims=\" %%b in ("!FULL_NAME!") do set "USERNAME=%%b

set "pasta=venvs/!USERNAME!"
set "lista_dependencias=dependencies.txt"

goto initialsetup

:initialsetup
if not exist "venvs" (
	mkdir venvs
)

goto checkinstallvenv


:checkinstallvenv

if not exist "%pasta%" (
	echo Bem vindo !USERNAME! pela primeira vez
	echo.
	echo Criando a virtual env do python para seu usuario...
	python -m venv "%pasta%"
	echo Venv criada.	
) else (
	echo Venv ok.
)

:checkdep

call "%pasta%\Scripts\activate"

for /f "tokens=*" %%i in (%lista_dependencias%) do (
    set "dependencia=%%i"
    
    rem Verifique se a dependência está instalada
    pip show !dependencia! >nul 2>nul
    
    if errorlevel 1 (
	echo.
        echo Instalando a dependencia: !dependencia!
        pip install !dependencia! > nul
    ) else (
	echo !dependencia! ok.
	)
)
goto checkdriver

:checkdriver
reg query "HKLM\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers" | findstr /I /C:"Hive" > nul
if %ERRORLEVEL% neq 0 (
	cls
	echo.
	echo Conector ODBC do Hive nao foi encontrado no computador.
	echo.
	echo Para instalar entre no service now e selecione "Desejo instalar um software", busque pelo ODBC for Hive e solicite.
	echo.
	pause
	exit
) else (
	echo Hive ok.
)
reg query "HKLM\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers" | findstr /I /C:"Impala" > nul
if %ERRORLEVEL% neq 0 (
	cls
	echo.
	echo Conector ODBC do Impala nao foi encontrado no computador.
	echo.
	echo Para instalar entre no service now e selecione "Desejo instalar um software", busque pelo ODBC for Impala e solicite.
	echo.
	pause
	exit
) else (
	echo Impala ok.
)
goto init



:init
cls
python main.py
pause
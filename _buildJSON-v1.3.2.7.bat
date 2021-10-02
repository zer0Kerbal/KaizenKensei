@echo off
cls

echo _buildJSON-v1.3.2.7-slck [sub][dll]

rem Set variables here:
set GAMEDATA=GameData
set JSONDIR=json

rem to fix json formatting issue
set TAB=" "
rem remove "" if present
for /f "useback tokens=*" %%a in ('%TAB%') do set TAB=%%~a

rem set derived variables here:
set RELEASEFILE=%JSONDIR%\_release.json

rem set utilities locations
set JQ=C:\ProgramData\chocolatey\lib\jq\tools\jq.exe

rem fetch mod folder name from release.json
%JQ% ".MODFOLDER" %RELEASEFILE% >tmpfile
set /P MODFOLDER=<tmpfile

rem fetch mod name from release.json
%JQ% ".MODNAME" %RELEASEFILE% >tmpfile
set /P MODNAME=<tmpfile

rem fetch mod license from release.json
%JQ% ".LICENSE" %RELEASEFILE% >tmpfile
set /P MODLICENSE=<tmpfile

rem fetch mod code.dnet from release.json
%JQ% ".CODE.DNET" %RELEASEFILE% >tmpfile
set /P DNET=<tmpfile

rem remove "" if present
for /f "useback tokens=*" %%a in ('%DNET%') do set DNET=%%~a

rem fetch mod code.unit from release.json
%JQ% ".CODE.UNIT" %RELEASEFILE% >tmpfile
set /P UNITY=<tmpfile

rem remove "" if present
for /f "useback tokens=*" %%a in ('%UNITY%') do set UNITY=%%~a

rem fetch mod code.lang from release.json
%JQ% ".CODE.LANG" %RELEASEFILE% >tmpfile
set /P LANG=<tmpfile

rem remove "" if present
for /f "useback tokens=*" %%a in ('%LANG%') do set LANG=%%~a

set CODE="<%DNET%> <%UNITY%> <%LANG%>"

del tmpfile

set VERSIONFILE=%MODFOLDER%.version

rem Get Version info
copy %VERSIONFILE% tmp.version
copy %VERSIONFILE% ksptmp.version
set VERSIONFILE=tmp.version
set KSPVERSIONFILE=ksptmp.version

rem The following requires the JQ program, available here: https://stedolan.github.io/jq/download/
rem extract mod version from .version file
%JQ% ".VERSION.MAJOR" %VERSIONFILE% >tmpfile
set /P major=<tmpfile

%JQ% ".VERSION.MINOR" %VERSIONFILE% >tmpfile
set /P minor=<tmpfile

%JQ% ".VERSION.PATCH" %VERSIONFILE% >tmpfile
set /P patch=<tmpfile

%JQ% ".VERSION.BUILD"  %VERSIONFILE% >tmpfile
set /P build=<tmpfile
del tmpfile
del tmp.version
set VERSION=%major%.%minor%.%patch%.%build%

rem .....................................
rem extract KSP version from .version file

%JQ% ".KSP_VERSION.MAJOR" %KSPVERSIONFILE% >tmpfile
set /P kspmajor=<tmpfile

%JQ% ".KSP_VERSION.MINOR" %KSPVERSIONFILE% >tmpfile
set /P kspminor=<tmpfile

%JQ% ".KSP_VERSION.PATCH" %KSPVERSIONFILE% >tmpfile
set /P ksppatch=<tmpfile

del tmpfile
del ksptmp.version
set KSPVERSION=%kspmajor%.%kspminor%.%ksppatch%

echo.
echo Version:  %VERSION%
echo for KSP version: %KSPVERSION%
echo License: %LICENSE%
echo Code: %CODE%
echo.

set FILE="%JSONDIR%\mod.json"
IF EXIST %FILE% del /F %FILE%

echo {>>%FILE%
echo %TAB%"schemaVersion": 1,>>%FILE%
echo %TAB%"label": %MODNAME%,>>%FILE%
echo %TAB%"labelColor": "darkgreen",>>%FILE%
echo %TAB%"message": "%VERSION%",>>%FILE%
echo %TAB%"color": "orange",>>%FILE%
echo %TAB%"style": "plastic">>%FILE%
echo }>>%FILE%

set FILE="%JSONDIR%\ksp.json"
IF EXIST %FILE% del /F %FILE%

echo {>>%FILE%
echo %TAB%"schemaVersion": 1,>>%FILE%
echo %TAB%"label": "KSP",>>%FILE%
echo %TAB%"labelColor": "darkblue",>>%FILE%
echo %TAB%"message": "%KSPVERSION%",>>%FILE%
echo %TAB%"color": "66ccff",>>%FILE%
echo %TAB%"style": "plastic">>%FILE%
echo }>>%FILE%


IF %MODLICENSE:~1,3% == MIT (
    echo MIT
    set COLOR=red
    set LABELCOLOR=black
) else (
IF %MODLICENSE:~1,3% == Exp (
    Echo Exp
    set COLOR=red
    set LABELCOLOR=black
) else (
IF %MODLICENSE:~1,3% == GPL (
    echo GPL
    set COLOR=red
    set LABELCOLOR=black
) else (
IF %MODLICENSE:~1,2% == CC (
    echo CC
    set COLOR=darkgrey
    set LABELCOLOR=blueviolet
))))

echo LabelColor: %LabelColor%
echo color: %COLOR%

set FILE="%JSONDIR%\license.json"
IF EXIST %FILE% del /F %FILE%

echo {>>%FILE%
echo %TAB%"schemaVersion": 1,>>%FILE%
echo %TAB%"label": "License",>>%FILE%
echo %TAB%"labelColor": "%LABELCOLOR%",>>%FILE%
echo %TAB%"message": %MODLICENSE%,>>%FILE%
echo %TAB%"color": "%COLOR%",>>%FILE%
echo %TAB%"style": "plastic">> %FILE%
echo }>>%FILE%
set FILE="%JSONDIR%\code.json"
IF EXIST %FILE% del /F %FILE%

set COLOR=darkblue
set LABELCOLOR=66ccff

IF %CODE% NEQ "" (
    echo {>>%FILE%
    echo %TAB%"schemaVersion": 1,>>%FILE%
    echo %TAB%"label": "Code",>>%FILE%
    echo %TAB%"labelColor": "%LABELCOLOR%",>>%FILE%
    echo %TAB%"message": %CODE%,>>%FILE%
    echo %TAB%"color": "%COLOR%",>>%FILE%
    echo %TAB%"style": "plastic">>%FILE%
    echo }>>%FILE%
) else (echo.No Code)

pause
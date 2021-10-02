cls

@echo off

echo _deploy-v1.1.1.0 [autosub][-dll]

rem Variables are pulled from json\_release.json

rem set directories
set GAMEDATA=GameData
set JSONDIR=json

rem set derived variables here:
set RELEASEFILE=%JSONDIR%\_release.json

rem set utilities locations
set PD=C:\ProgramData\chocolatey\bin\pandoc.exe
set JQ=C:\ProgramData\chocolatey\lib\jq\tools\jq.exe

rem fetch mod folder name from release.json
rem set MODFOLDER=TheGoldStandard
%JQ% ".MODFOLDER" %RELEASEFILE% >tmpfile
set /P MODFOLDER=<tmpfile

rem remove "" if present
for /f "useback tokens=*" %%a in ('%MODFOLDER%') do set MODFOLDER=%%~a

rem fetch mod name from release.json
rem set SUBDIR=""
%JQ% ".SUBFOLDER" %RELEASEFILE% >tmpfile
set /P SUBDIR=<tmpfile

rem remove "" if present
rem for /f "useback tokens=*" %%a in ('%SUBDIR%') do set SUBDIR=%%~a

rem fetch mod type from release.json
%JQ% ".MODTYPE" %RELEASEFILE% >tmpfile
set /P MODTYPE=<tmpfile

rem remove "" if present
for /f "useback tokens=*" %%a in ('%MODTYPE%') do set MODTYPE=%%~a

set RELEASEDIR=C:\KSPDEV\%MODTYPE%\Releases

rem fetch mod license from release.json
%JQ% ".LICENSE" %RELEASEFILE% >tmpfile
set /P MODLICENSE=<tmpfile

rem clean up
del tmpfile

rem remove "" if present
for /f "useback tokens=*" %%a in ('%MODLICENSE%') do set MODLICENSE=%%~a

rem set files
set CHANGELOG="Changelog.*"
set README="Readme.htm"
set LICENSETEXT=%MODLICENSE%.txt
set VERSIONFILE=%MODFOLDER%.version

    rem create HTML5 version of Readme.md
    pandoc -f gfm -t html5 Readme.md -o Readme.htm

if %SUBDIR% NEQ "" (
    echo %SUBDIR%

    copy /Y %VERSIONFILE% %GAMEDATA%\%SUBDIR%\%MODFOLDER%
    copy /Y %CHANGELOG% %GAMEDATA%\%SUBDIR%\%MODFOLDER%
    copy /Y %README% %GAMEDATA%\%SUBDIR%\%MODFOLDER%
    
    xcopy /y /s /I %GAMEDATA%\%SUBDIR%\%MODFOLDER% %RELEASEDIR%\%GameData%\%SUBDIR%\%MODFOLDER%
) else (
   echo No SUBDIR
    copy /Y %VERSIONFILE% %GAMEDATA%\%MODFOLDER%
    copy /Y %CHANGELOG% %GAMEDATA%\%MODFOLDER%
    copy /Y %README% %GAMEDATA%\%MODFOLDER%
    
    xcopy /y /s /I %GAMEDATA%\%MODFOLDER% %RELEASEDIR%\%GameData%\%MODFOLDER%
)
rem del Readme.htm
pause

@echo off
set clman_version=106
pushd %~dp0
setlocal enableextensions enabledelayedexpansion
	:: Rename config and call variables, add empty param to skip opening file using notepad
call config.cmd exec
title Looking for updates...
if exist update.cmd ( del update.cmd /s /q )
if exist version.cmd ( del version.cmd /s /q )
if exist map.list ( del map.list /s /q )
for /f "delims=" %%b in ( 'dir /B iw3_client_*' ) do del %%b /s /q >nul
if %update%==0 goto _ready


:_check
	:: download check.cmd file, call file and get variable value, compare to variable inside version.cmd
	:: if the variable returns a different value, ask for update
bitsadmin /transfer CHECK /download /priority high http://gmzorz.com/ZorWarfare/check.cmd "%cd%/check.cmd"
call check.cmd
if %clman_check% == %clman_version% del check.cmd /s /q >nul & goto _ready
cls
echo. 
echo Current version: %clman_version%
echo Latest version: %clman_check%
echo.
echo A new update is available, press any key to update
pause >nul


:_update
	:: download update.cmd (may contain additional scripts and even mods)
	:: update version.cmd to latest version
bitsadmin /transfer UPDATE /download /priority high http://gmzorz.com/ZorWarfare/update.cmd "%cd%/update.cmd"
cls
echo updating..
call update.cmd
timeout /t 1 >nul
del update.cmd /s /q >nul
del check.cmd /s /q >nul
echo update complete, please restart client manager
timeout /t 5 >nul
start notepad "update.log" & exit


:_ready
title Client Manager ^| Version %clman_version%
cls
	:: check for custom mods
if [%customMod%] == [] ( set mod=ZorWarfare ) else ( set mod=%customMod% & goto _cont )
	:: see if ZorWarfare exists. If not, download mod
if not exist "Mods/ZorWarfare/mod.ff" ( goto _prompt ) else ( goto _cont )


:_prompt
echo ZorWarfare not found, press any key to download
cd Mods
mkdir ZorWarfare
cd ZorWarfare
pause >nul
bitsadmin /transfer mod /download /priority high http://gmzorz.com/ZorWarfare/mod.ff "%cd%/mod.ff"
bitsadmin /transfer mod /download /priority high http://gmzorz.com/ZorWarfare/z_content.iwd "%cd%/z_content.iwd"
cd ../..


:_cont
cls
echo                           +--------------------------+ 
echo                           (    MADE BY JIM/GMZORZ    ) 
echo                           +--------------------------+ 
echo. 
echo                              .RrRrR.    .M_Mm mM_M. 
echo                             .Rr*R*rR.  .Mm~M*m*M~mM. 
echo                             R*R   R*R  M*m  M*M  M*M 
echo                             R*R   R*R  M*M  M*M  M*M 
echo                             R*R   R*R  M*M  M*M  M*M 
echo                             R*R   R*R  M*M  M*M  M*M 
echo                             R*R        M*M       M*M 
echo                             R*R        M*M       M*M 
echo                             R*R        M*M       M*M 
echo                             R*R        M*M       M*M 
echo                             R*R        M*M       M*M 
echo                             R*R        M*M       M*M 
echo. 
echo                           +--------------------------+ 
echo                           (  LICENSED BY RM ACADEMY  ) 
echo                           +--------------------------+ 
echo. 
	:: if hostname is empty in config, prompt user instead
if [%hostName%] == [] ( set /p hostName=Player name: %=% ) 	
echo. 
cls
	:: list custom maps (if available)
echo   custom maps:
if exist usermaps ( cd usermaps & dir /b & dir /b > "../map.list" )
cd ..
echo. 
echo   main maps:
cd zone/english
	:: list main maps and add to map.list
for /f "delims=" %%b in ( 'dir /B mp_* ^|findstr /i /v "_load.ff" ' ) do @echo %%~nb
for /f "delims=" %%b in ( 'dir /B mp_* ^|findstr /i /v "_load.ff" ' ) do @echo %%~nb >> "../../map.list"
cd ../..


:_selectmap
echo. 
if [%map%] == [] ( set /p map=Select map: %=% )
	:: check prompt and see if mapname is correct
findstr /r /s /i /m /c:"\<%map%\>" map.list >nul
if %errorlevel% equ 1 echo 	not a map & goto _selectmap 
if exist map.list ( del map.list /s /q )
	:: run base game with correct parameters
start iw3mp.exe +set ui_playerProfileAlreadyChosen 1 +set fs_game mods/%mod% +set name %hostName% +set sv_pure 0 +set sv_maxclients 12 +set sv_punkbuster 0 +set r_mode %gameRes% +set r_fullscreen %fullScreen% +set g_gametype dm +set scr_dm_timelimit 0 +devmap %map%
echo.


:_addClient
cls
echo Client manager version %clman_version%
echo.
echo map launched:
echo   %map%
echo.
echo mod loaded:
echo   %mod%
echo.
echo player name:
echo   %hostName%
echo.
echo clients available:
for /l %%z in (1,1,%maxClients%) do ( echo   !client_%%z! )
echo. 
echo please wait until the game has fully loaded before adding a client
timeout /t 2 >nul
echo.
echo press any key to add a client
	:: loop through maximum amount of clients, check for existing executables, copy and run executable with parameters
	:: connect to localhost using 127.0.0.1
for /l %%a in (1,1,%maxClients%) do (
	pause >nul
	if not exist iw3_client_%%a.exe ( copy iw3mp.exe iw3_client_%%a.exe >nul )
	start iw3_client_%%a.exe +set ui_playerProfileAlreadyChosen 1 +set r_mode 1; +set name !client_%%a! +set r_fullscreen 0 +set fs_game mods/%mod% +set net_port 28961 +connect 127.0.0.1 
	echo   Client !client_%%a! added
	)
	:: end of loop
echo.
echo Maximum amount of clients added. press any key to close all windows
pause >nul


:_endproc
	:: clean up executables
for /l %%b in (1,1,%maxClients%) do (
	if exist iw3_client_%%b.exe ( taskkill /im iw3_client_%%b.exe /f >nul )
	)
	:: after taskkill, a delay is required before deleting executables
echo quitting...
timeout /t 1 >nul
for /l %%c in (1,1,%maxClients%) do (
	if exist iw3_client_%%c.exe ( del iw3_client_%%c.exe /s /q >nul )
	)
	:: shut down
taskkill /im iw3mp.exe /f
exit

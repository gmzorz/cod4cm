		::::::::::::::IGNORE:::::::::::::::
		   if not [%1] == [] goto config
		 start notepad "config.cmd" & exit
		:::::::::::::::::::::::::::::::::::
		::::::  CoD4 Client Manager  ::::::
		::::::   http://gmzorz.com   ::::::
		:::::::::::::::::::::::::::::::::::

:config
set update=1
	:: Automatically check for updates (recommended)
	
set hostName=
	:: Set player name (can be left empty, you will be prompted instead)
	
set map=
	:: Set default map to load (can be left empty)
	
set maxClients=3
	:: Maximum clients
	
set client_1=Luckyy
set client_2=Delayz
set client_3=Jebasu
	:: extra clients can be added (client_4, client_5, etc..)
	
set fullScreen=0
	:: base game only (clients are windowed)
	
set gameRes=6
set clientRes=0
	:: window resolution
	:: 0  =  640x480
	:: 3  =  800x600
	:: 6  =  1280x720
	:: 15 =  1600x900
	:: 18 =  1920x1080
	:: for more info, run cod4 and write "r_mode " in console
	
set customMod=
	:: Load a custom mod instead of ZorWarfare, leave empty if you wish to use the default mod

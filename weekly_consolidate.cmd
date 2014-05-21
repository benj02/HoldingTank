@echo off
setlocal EnableDelayedExpansion

:: Change this
set MainDirectory=C:\Users\Ben Johnson\Desktop\camera stuff

:: Set up directories
	for /f "skip=1 tokens=1-6 delims= " %%a in ('wmic path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') do (
		if not "%%~f" == "" (
			set /a FormattedDate=10000 * %%f + 100 * %%d + %%a
			set Day=!FormattedDate:~6,2!
			set Month=!FormattedDate:~4,2!
			set Year=!FormattedDate:~0,4!
		)
	)
	
	cd "%MainDirectory%"
	if not "%cd%" == "%MainDirectory%" (
		echo error: Directory was not changed correctly. Aborting
		pause
		exit /b
	)

	set MonthDir=%Year%-%Month%
	echo %MonthDir%
	if not exist "%MonthDir%" (
		md "%MonthDir%"
	)
	
:: Move Files
	:: /d to match directories instead of files
	for /d %%X in (*) do (
		set DayDir=%%~nxX
		if "!DayDir:~5,2!" == "!Month!" (
			if not "!DayDir!" == "!MonthDir!" (
				echo !DayDir!
				move "!DayDir!" "!MonthDir!"
			)
		)
	)
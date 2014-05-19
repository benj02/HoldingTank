@echo off
setlocal EnableDelayedExpansion

:: Change this
set MainDirectory=C:\Users\Ben Johnson\Desktop\camera stuff
set HoldingDirectory=C:\Users\Ben Johnson\Desktop\camera stuff\Holding Tank

set count=1
:loop

:: Set up directories
	for /f "skip=1 tokens=1-6 delims= " %%a in ('wmic path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') do (
		if not "%%~f" == "" (
			set /a FormattedDate=10000 * %%f + 100 * %%d + %%a
			set Day=!FormattedDate:~6,2!
			set Month=!FormattedDate:~4,2!
			set Year=!FormattedDate:~0,4!
		)
	)

	set DateDir=%MainDirectory%\%Year%-%Month%-%Day%
	if not exist "%DateDir%" (
		md "%DateDir%"
	)
	
:: Move Files
	cd "%HoldingDirectory%"
	if not "%cd%" == "%HoldingDirectory%" (
		echo error: Directory was not changed correctly. Aborting
		pause
		exit /b
	)
	:: Count directory items, if >= 30 abort for safety
	set dircount=0
	for %%X in (*) do (
		set /a dircount=!dircount!+1
	)

	if "%dircount%" GEQ "30" (
		echo error: 30 or more files to move. Aborting
		pause
		exit /b
	)

	for %%X in (*) do (
		move "%%X" "%DateDir%\!count!-%%~nxX"
		set /a count=!count!+1
	)

:: Windows has no sleep command, pinging localhost is a reasonable approximation
ping localhost -n 4 > nul
goto loop
pause
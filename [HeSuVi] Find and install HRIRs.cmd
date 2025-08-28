@echo off
SetLocal EnableExtensions
SetLocal EnableDelayedExpansion

pushd "%~dp0"
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\EqualizerAPO" /v "InstallPath" 2^>^>^"NUL^"') do SET "HeSuViPath=%%b\Config\HeSuVi"
	ECHO HeSuVi path detected: "%HeSuViPath%"
	ECHO.
	IF EXIST "%HeSuViPath%\hrir\more" (
		FOR /D /R %%D in (*) DO (
			Set "HRIRPath=%%D"
			If "!HRIRPath!"=="!HRIRPath:[HeSuVi]=!" (
				IF EXIST "!HRIRPath!\44" (
					Echo %%~nxD
					robocopy "!HRIRPath!\44"	"%HeSuViPath%\hrir\44\more"	*.wav /MOVE /NS /NC /NFL /NDL /NJH /NJS >NUL
					robocopy "!HRIRPath!"		"%HeSuViPath%\hrir\more"	*.wav /MOVE /NS /NC /NFL /NDL /NJH /NJS >NUL
					)
				)
			)
		) ELSE (
		ECHO Failed to find HeSuVi hrir folder path. Please make sure EqualizerAPO and HeSuVi are properly installed.
		pause
		exit
		)

echo Badda-bing badda-boom!
taskkill /im "HeSuVi.exe" /T /F 1>>NUL 2>&1
START /B /SEPARATE "" "%HeSuViPath%\HeSuVi.exe" >NUL
PAUSE
EXIT
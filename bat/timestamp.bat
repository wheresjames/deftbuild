FOR /F "tokens=2-4 delims=/ " %%a in ('date /t') do set LDATE=%%c%%a%%b
FOR /F "tokens=1-4 delims=: " %%a in ('time /t') do set LTIME=%%a%%b%%c
set LTIMESTAMP=%LDATE%-%LTIME: =%

FOR /F "tokens=1-4 delims=/ " %%a in ('date /t') do set LDATE=%%c%%b%%a
FOR /F "tokens=1-4 delims=: " %%a in ('time /t') do set LTIME=%%a%%b%%c
set LTIMESTAMP=%LDATE%-%LTIME: =%

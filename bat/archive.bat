REM echo %1 %2

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

IF EXIST %2 (

echo *** Archiving : %2

IF NOT EXIST !DIR_ARC! md !DIR_ARC!

cd "!DIR_LIB!"

set FILE=!DIR_ARC!\%%a.tgz
tar -czf "!FILE!" "%%a"

)
)
)

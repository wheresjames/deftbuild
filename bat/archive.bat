REM echo %1 %2

REM ----------------------------------------------------------------
REM Where the archive should go
REM ----------------------------------------------------------------
set ARCHDIR=!DIR_ARC!\!LTIMESTAMP!
IF NOT EXIST !ARCHDIR! md !ARCHDIR!

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

IF EXIST %2 (

echo *** Archiving : %2

cd "!DIR_LIB!"

REM tar -hczf "!ARCHDIR!\%%a.tgz" "%%a"

tar -hc %%a | bzip2 > "!ARCHDIR!\%%a.tar.bz2"

REM zip -q -r "!ARCHDIR!\%%a.zip" %%a

)
)
)

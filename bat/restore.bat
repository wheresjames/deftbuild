REM echo %1 %2 %3

REM ----------------------------------------------------------------
REM Where the archive should go
REM ----------------------------------------------------------------
set ARCHDIR=!DIR_ARC!\!EXT!
IF NOT EXIST !ARCHDIR! md !ARCHDIR!

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

IF EXIST %2 (

echo *** Ignoring : %2

) ELSE (

echo *** Restoring : %2

cd "!DIR_LIB!"

IF NOT EXIST !ARCHDIR! md !ARCHDIR!

set FILE=!ARCHDIR!\%%a.tar.bz2
!DIR_WBIN!\wget -O "!FILE!" "!EX2!/%%a.tar.bz2"

ECHO !EX2!

IF EXIST !FILE! (
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
)

)
)
)

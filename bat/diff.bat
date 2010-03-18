REM echo %1 %2

REM ----------------------------------------------------------------
REM Where the diff should go
REM ----------------------------------------------------------------
set ARCHDIR=!DIR_DIF!\!LTIMESTAMP!
IF NOT EXIST !ARCHDIR! md !ARCHDIR!

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

IF EXIST %2 (

echo *** Diffing %%a : %%c : %2

cd "!DIR_LIB!"

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
cd %2
FOR /f "delims=" %%a in ('git rev-parse --verify HEAD') do set CVER=%%a
set CVER=!CVER:M=!
git diff > "!ARCHDIR!/%%a.!CVER!.git.diff"
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
cd %2
FOR /f "delims=" %%a in ('svnversion') do set CVER=%%a
set CVER=!CVER:M=!
svn diff > "!ARCHDIR!/%%a.!CVER!.svn.diff"
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (

set CVER="---"

set FILE=!ARCHDIR!\%%a.tgz
tar -czf "!FILE!" "%%a"

cd %2
cvs -Q diff > "!ARCHDIR!/%%a.!CVER!.cvs.diff"

)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
set FILE=!ARCHDIR!\%%a.tar.gz
tar -cf - %%a | gzip -c > !FILE!
)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
set FILE=!ARCHDIR!\%%a.tar.bz2
tar -cf - %%a | bzip2 -c > !FILE!
)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
set FILE=!ARCHDIR!\%%a.zip
zip -q -r "!FILE!" "%%a"
)


)
)
)

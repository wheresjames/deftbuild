
REM ----------------------------------------------------------------
REM Where the patches should be
REM ----------------------------------------------------------------

set SPATCH=%3
IF /I !SPATCH! EQU 0 SET SPATCH=default

set ARCHDIR=!DIR_LPAT!\!SPATCH!

IF NOT EXIST !ARCHDIR! (
exit /b
)

IF NOT EXIST !ARCHDIR! (
exit /b
)

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

set PRJDIR=!DIR_LIB!\%%a

IF EXIST !PRJDIR! (

set PATCHFILE=!ARCHDIR!/%%a.%%b.!EXT_PATCH!

IF EXIST !PATCHFILE! (

cd !PRJDIR!

echo *** Applying patch for %%a

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
cd %2
git apply "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
cd %2
patch -p0 -N < "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (
cd %2
patch -p0 -N < "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
cd %2
patch -p0 -N < "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
cd %2
patch -p0 -N < "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
cd %2
patch -p0 -N < "!PATCHFILE!"
)

)
)
)
)

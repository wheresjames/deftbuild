@echo off

REM ----------------------------------------------------------------
REM Configure
REM ----------------------------------------------------------------

CALL %~dp0\config.bat
SETLOCAL EnableDelayedExpansion

REM ----------------------------------------------------------------
REM Ensure directories
REM ----------------------------------------------------------------

IF NOT EXIST !DIR_LIB! md !DIR_LIB!

REM ----------------------------------------------------------------
REM Process the command line
REM ----------------------------------------------------------------

FOR /F "tokens=1-8" %%a in ("%*") do (
set CMD=%%a
set GRP=%%b
set PRJ=%%c
set EXT=%%d
)

set LTIMESTAMP=!EXT!
IF /I !LTIMESTAMP! EQU 0 (
CALL !DIR_LBAT!\timestamp.bat
)

IF /I !CMD! EQU 0 SET /P CMD=Which Command? 
IF /I !GRP! EQU 0 SET /P GRP=Which Groups? 
IF /I !PRJ! EQU 0 SET /P PRJ=Which Projects? 

IF !CMD!==- set CMD=
IF !GRP!==- set GRP=
IF !PRJ!==- set PRJ=

IF /I !CMD! EQU 0 (
echo CMD : !CMD!
echo GRP : !GRP!
echo PRJ : !PRJ!
echo EXT : !EXT!
echo LTIMESTAMP : !LTIMESTAMP!
)

REM ----------------------------------------------------------------
REM Find group files if not specified
REM ----------------------------------------------------------------

set UGRP=!GRP!
IF /I !UGRP! EQU 0 (

FOR /f %%a in ('dir !DIR_LPRJ!\* /b /ad') do (
IF /I !UGRP! NEQ 0 set UGRP=!UGRP!,
set _TMP=%%a
set UGRP=!UGRP!!_TMP:.repo=!
)

)

IF /I !UGRP! EQU 0 exit /b

REM ----------------------------------------------------------------
REM For each group
REM ----------------------------------------------------------------

FOR %%g in (!UGRP!) do (

REM ----------------------------------------------------------------
REM Find project files if not specified
REM ----------------------------------------------------------------

IF /I !PRJ! NEQ 0 ( 
SET UPRJ=!PRJ! 
) ELSE (
SET UPRJ=
)
IF /I !UPRJ! EQU 0 (

FOR /f %%a in ('dir !DIR_LPRJ!\%%g\*.!EXT_REPO! /b /a-d') do (
IF /I !UPRJ! NEQ 0 set UPRJ=!UPRJ!,
set _TMP=%%a
set UPRJ=!UPRJ!!_TMP:.repo=!
)

)

REM ----------------------------------------------------------------
REM For each project
REM ----------------------------------------------------------------

FOR %%p in (!UPRJ!) do (

set REPOPATH=!DIR_LPRJ!\%%g\%%p.!EXT_REPO!
set MAKEPATH=!DIR_LPRJ!\%%g\%%p.!EXT_REPO!
set LIBPATH=!DIR_LIB!\%%p

IF EXIST !REPOPATH! (

IF /I !CMD! EQU 0 (
echo %%g : %%p
) ELSE (

REM ----------------------------------------------------------------
REM Build
REM ----------------------------------------------------------------
IF !CMD!==build set CMD=bld
IF !CMD!==bld (
call %DIR_LBAT%\checkout-prj.bat !REPOPATH! !LIBPATH!
call %DIR_LBAT%\applypatch.bat !REPOPATH! !LIBPATH! !EXT!
call %DIR_LBAT%\compile.bat !MAKEPATH! !LIBPATH!
)

REM ----------------------------------------------------------------
REM Checkout
REM ----------------------------------------------------------------
IF !CMD!==checkout set CMD=co
IF !CMD!==co (
call %DIR_LBAT%\checkout-prj.bat !REPOPATH! !LIBPATH!
)

REM ----------------------------------------------------------------
REM update
REM ----------------------------------------------------------------
IF !CMD!==update set CMD=up
IF !CMD!==up (
call %DIR_LBAT%\update.bat !MAKEPATH! !LIBPATH!
)

REM ----------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------
IF !CMD!==archive set CMD=arc
IF !CMD!==arc (
call %DIR_LBAT%\archive.bat !REPOPATH! !LIBPATH!
)

REM ----------------------------------------------------------------
REM diff
REM ----------------------------------------------------------------
IF !CMD!==diff set CMD=dif
IF !CMD!==dif (
call %DIR_LBAT%\diff.bat !REPOPATH! !LIBPATH!
)

REM ----------------------------------------------------------------
REM makepatch
REM ----------------------------------------------------------------
IF !CMD!==makepatch set CMD=mp
IF !CMD!==mp (
call %DIR_LBAT%\makepatch.bat !REPOPATH! !LIBPATH! !EXT!
)

REM ----------------------------------------------------------------
REM applypatch
REM ----------------------------------------------------------------
IF !CMD!==applypatch set CMD=ap
IF !CMD!==ap (
call %DIR_LBAT%\applypatch.bat !REPOPATH! !LIBPATH! !EXT!
)

REM ----------------------------------------------------------------
REM compile
REM ----------------------------------------------------------------
IF !CMD!==applypatch set CMD=ap
IF !CMD!==ap (
call %DIR_LBAT%\compile.bat !MAKEPATH! !LIBPATH!
)

)
)

)
)

cd !DIR_CURRENT!
echo.

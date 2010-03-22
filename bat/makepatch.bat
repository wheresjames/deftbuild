
REM ----------------------------------------------------------------
REM Where the patches should go
REM ----------------------------------------------------------------

set SPATCH=%3
IF /I !SPATCH! EQU 0 SET SPATCH=default

set ARCHDIR=!DIR_LPAT!\!SPATCH!
IF NOT EXIST !ARCHDIR! md !ARCHDIR!

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

set PRJDIR=!DIR_LIB!\%%a

IF EXIST !PRJDIR! (

cd !PRJDIR!

set PATCHFILE=!ARCHDIR!\%%a.%%b.!EXT_PATCH!

echo *** Creating patch for %%a

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
git diff > "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
svn diff > "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (
cvs -Q diff > "!PATCHFILE!"
)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (

IF NOT EXIST !DIR_DNL! md !DIR_DNL!
set FILE=!DIR_DNL!\%%a.tar.gz
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

cd !DIR_DNL!
IF %%c==- (
cd "%%a"
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)

diff -rupwN "!DIR_DNL!\%%a" "%2" > "!PATCHFILE!"
rmdir /s /q "!DIR_DNL!\%%a\"

)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.bz2
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

cd !DIR_DNL!
IF %%c==- (
cd "%%a"
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)

diff -rupwN "!DIR_DNL!\%%a" "%2" > "!PATCHFILE!"
rmdir /s /q "!DIR_DNL!\%%a\"

)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.zip
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

cd !DIR_DNL!
IF %%c==- (
cd "%%a"
!DIR_WBIN!\unzip -q !FILE!
) ELSE (
!DIR_WBIN!\unzip -q !FILE!
rename "%%c" "%%a"
)

diff -rupwN "!DIR_DNL!\%%a" "%2" > "!PATCHFILE!"
rmdir /s /q "!DIR_DNL!\%%a\"

)

REM FOR /F %%A IN ("File") DO IF %%~zA EQU 0 ECHO "File" is 0 in size
REM ----------------------------------------------------------------
REM Remove empty patch files
REM ----------------------------------------------------------------
IF EXIST !PATCHFILE! (
REM IF "!~zPATCHFILE!" == "0" (
FOR %%a IN (!PATCHFILE!) DO IF %%~za equ 0 (
del /F /Q "!PATCHFILE!"
)
)


)
)
)

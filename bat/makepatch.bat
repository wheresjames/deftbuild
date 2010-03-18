
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

IF EXIST %2 (

echo *** Creating patch for %%a

cd "!DIR_LIB!"

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
cd %2
git diff > "!ARCHDIR!/%%a.git.diff"
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
cd %2
svn diff > "!ARCHDIR!/%%a.svn.diff"
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (

cd %2
cvs -Q diff > "!ARCHDIR!/%%a.cvs.diff"

)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.gz
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

cd !DIR_DNL!
IF %%c==* (
cd "%%a"
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)

diff -rupN "!DIR_DNL!\%%a" "%2" > "!ARCHDIR!/%%a.targz.diff"
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
IF %%c==* (
cd "%%a"
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)

diff -rupN "!DIR_DNL!\%%a" "%2" > "!ARCHDIR!/%%a.tarbz2.diff"
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
IF %%c==* (
cd "%%a"
!DIR_WBIN!\unzip -q !FILE!
) ELSE (
!DIR_WBIN!\unzip -q !FILE!
rename "%%c" "%%a"
)

diff -rupN "!DIR_DNL!\%%a" "%2" > "!ARCHDIR!/%%a.zip.diff"
rmdir /s /q "!DIR_DNL!\%%a\"

)


)
)
)

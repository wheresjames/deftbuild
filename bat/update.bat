REM echo %1 %2

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

IF EXIST %2 (

echo *** Updating %%a : %%b : %2

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
cd %2
git pull
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
cd %2
svn update
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (
cd %2
cvs update
)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.gz
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

IF EXIST !FILE! (

rmdir /s /q "%%a"

IF %%c==- (
cd "%%a"
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)
)
)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.bz2
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

IF EXIST !FILE! (

rmdir /s /q "%%a"

IF %%c==- (
cd "%%a"
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)
)
)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.zip
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

IF EXIST !FILE! (

rmdir /s /q "%%a"

IF %%c==- (
cd "%%a"
!DIR_WBIN!\unzip -q !FILE!
) ELSE (
!DIR_WBIN!\unzip -q !FILE!
rename "%%c" "%%a"
)
)
)


)
)
)

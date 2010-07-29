REM echo %1 %2

REM ----------------------------------------------------------------
REM For each project in the file
REM ----------------------------------------------------------------
FOR /f "tokens=1-8 delims= " %%a IN (%1) DO (

IF NOT %%a==# (

set LPATH=!DIR_LIB!\%%a
set LPATH=!LPATH:/=\!

IF EXIST !LPATH! (

echo  .  Ignoring %%a : %%c : !LPATH!

) ELSE (

echo *** Checking out %%a : %%c : !LPATH!

cd "!DIR_LIB!"

REM ----------------------------------------------------------------
REM git
REM ----------------------------------------------------------------
IF %%b==git (
git clone %%d %%a
IF NOT %%c==- (
cd !LPATH!
git checkout %%c
)
)

REM ----------------------------------------------------------------
REM svn
REM ----------------------------------------------------------------
IF %%b==svn (
IF %%c==- (
svn co -q "%%d" "!LPATH!"
) ELSE (
svn co -q -r %%c "%%d" "!LPATH!"
)
)

REM ----------------------------------------------------------------
REM cvs
REM ----------------------------------------------------------------
IF %%b==cvs (
IF %%c==- (
cvs -Q -z3 -d %%f%%d co -d %%a %%e
) ELSE (
cvs -Q -z3 -d "%%f%%d" co -r %%c -d %%a "%%e"
)
)

REM ----------------------------------------------------------------
REM targz
REM ----------------------------------------------------------------
IF %%b==targz (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.gz
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

IF %%c==- (
cd "%%a"
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\gzip -c -d !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)

)

REM ----------------------------------------------------------------
REM tarbz2
REM ----------------------------------------------------------------
IF %%b==tarbz2 (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.tar.bz2
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

IF %%c==- (
cd "%%a"
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
) ELSE (
!DIR_WBIN!\bunzip2 -c !FILE! | !DIR_WBIN!\tar xf -
rename "%%c" "%%a"
)

)

REM ----------------------------------------------------------------
REM zip
REM ----------------------------------------------------------------
IF %%b==zip (
IF NOT EXIST !DIR_DNL! md !DIR_DNL!

set FILE=!DIR_DNL!\%%a.zip
IF NOT EXIST !FILE! !DIR_WBIN!\wget -O "!FILE!" "%%d"

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

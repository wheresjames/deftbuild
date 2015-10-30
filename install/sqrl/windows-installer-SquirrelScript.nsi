; InstallSquirrelScript.nsi
;

;--------------------------------
; The name of the installer and output file

!ifdef DVER
	!define APPNAME "Squirrel Script Engine ${PROC} ${DVER} ${BUILD}"
!else
	!define APPNAME "Squirrel Script Engine ${PROC} ${BUILD}"
!endif

!define FILENAME "SquirrelScript"

!define KEYNAME "${FILENAME}_${PROC}_${BUILD}"
!define GCCKEYNAME "${FILENAME}_${PROC}_gcc"

Name "${APPNAME}"

!ifdef FVER
!define FULL_FILENAME "Install${FILENAME}${POSTFIX}_${FVER}_${PROC}_${BUILD}.exe"
!define FULL_GCC_FILENAME "Install${FILENAME}${POSTFIX}_${FVER}_${PROC}_gcc.exe"
!else
!define FULL_FILENAME "Install${FILENAME}${POSTFIX}_${PROC}_${BUILD}.exe"
!define FULL_GCC_FILENAME "Install${FILENAME}${POSTFIX}_${PROC}_gcc.exe"
!endif
OutFile "${OUTROOT}\${FULL_FILENAME}"

!if "${PROC}" == "x64"
!define BITS 64
!else
!define BITS 32
!endif

!if "${BUILD}" == "vs"
!define INCLUDE_GCC_VERSION
!endif

!ifdef INCLUDE_GCC_VERSION
!define FULL_GCC_PATH "..\windows-gcc-${OS}-${PROC}-mingw${BITS}-${LIBLINK}\${FULL_GCC_FILENAME}"
!endif 

; The default installation director
!if "${PROC}" == "x64"
	InstallDir "$PROGRAMFILES64\Squirrel Script Engine ${PROC} ${BUILD}"
!else
	InstallDir "$PROGRAMFILES\Squirrel Script Engine ${PROC} ${BUILD}"
!endif

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${KEYNAME}" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------
; Pages

Page license
LicenseData "License.txt"
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------
; http://nsis.sourceforge.net/Check_if_a_file_exists_at_compile_time
!macro !defineifexist _VAR_NAME _FILE_NAME
	!tempfile _TEMPFILE
	!ifdef NSIS_WIN32_MAKENSIS
		; Windows - cmd.exe
		!system 'if exist "${_FILE_NAME}" echo !define ${_VAR_NAME} > "${_TEMPFILE}"'
	!else
		; Posix - sh
		!system 'if [ -e "${_FILE_NAME}" ]; then echo "!define ${_VAR_NAME}" > "${_TEMPFILE}"; fi'
	!endif
	!include '${_TEMPFILE}'
	!delfile '${_TEMPFILE}'
	!undef _TEMPFILE
!macroend
!define !defineifexist "!insertmacro !defineifexist"

;--------------------------------
; The stuff to install

Section "${APPNAME} (required)"

  SectionIn RO
  
!if "${PROC}" == "x64"
	SetRegView 64
!endif

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  SetOverwrite on
  File "License.txt"
  File "${OUTROOT}\sqrl${POSTFIX}.exe"
  File "${OUTROOT}\sqrl-cgi${POSTFIX}.exe"

  ; Hack - install GCC version if needed and it exists
!ifdef INCLUDE_GCC_VERSION
${!defineifexist} GCC_BUILD_EXISTS "${OUTROOT}\${FULL_GCC_PATH}"
!ifdef GCC_BUILD_EXISTS
	File "${OUTROOT}\${FULL_GCC_PATH}"
!endif
!endif  
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\modules
  
  ; Put file there
  SetOverwrite on
  File "${OUTROOT}\_sqmod\sqmod_asio${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_cell${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_curl${POSTFIX}.dll"
;!if "${PROC}" != "x64"
;  File "${OUTROOT}\_sqmod\sqmod_ffmpeg${POSTFIX}.dll"
;!else
!if "${BUILD}" != "vs"
  File "${OUTROOT}\_sqmod\sqmod_ffmpeg${POSTFIX}.dll"
!endif
;!endif
  File "${OUTROOT}\_sqmod\sqmod_fftw${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_freetype2${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_gdchart${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_irrlicht${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_live555${POSTFIX}.dll"
;!if "${BUILD}" != "vs"
;  File "${OUTROOT}\_sqmod\sqmod_mysql${POSTFIX}.dll"
;!endif
  File "${OUTROOT}\_sqmod\sqmod_openssl${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_poco${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_portaudio${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_rtmpd${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_ssh2${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_tinyxml${POSTFIX}.dll"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "Software\${KEYNAME}" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "DisplayName" "${APPNAME}"
!ifdef DVER
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "DisplayVersion" "${DVER}"
!endif
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "InstallLocation" '$INSTDIR'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  ; Hack - install GCC version
!ifdef INCLUDE_GCC_VERSION
  ExecWait '"$INSTDIR\${FULL_GCC_FILENAME}" /S'
!endif  
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

;  CreateDirectory "$SMPROGRAMS\${APPNAME}"
;  CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

;--------------------------------
; Uninstaller

Section "Uninstall"
  
!if "${PROC}" == "x64"
	SetRegView 64
!endif

!ifdef INCLUDE_GCC_VERSION
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GCCKEYNAME}" "UninstallString"
  ReadRegStr $R1 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GCCKEYNAME}" "InstallLocation"
  StrCmp $R0 "" gcc_done
    ExecWait '$R0 /S _?=$R1'
	Delete "$R1\uninstall.exe"
	RMDir "$R1"
gcc_done: 
!endif

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}"
  DeleteRegKey HKLM "Software\${KEYNAME}"

  ; Remove files and uninstaller
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\License.txt
  
  Delete $INSTDIR\sqrl.exe  
  Delete $INSTDIR\sqrl.exe.debug.log  
  Delete $INSTDIR\sqrl-cgi.exe  
  Delete $INSTDIR\sqrl-cgi.exe.debug.log  
  Delete $INSTDIR\modules\sqmod_asio.dll
  Delete $INSTDIR\modules\sqmod_cell.dll
  Delete $INSTDIR\modules\sqmod_curl.dll
  Delete $INSTDIR\modules\sqmod_ffmpeg.dll
  Delete $INSTDIR\modules\sqmod_fftw.dll
  Delete $INSTDIR\modules\sqmod_freetype2.dll
  Delete $INSTDIR\modules\sqmod_gdchart.dll
  Delete $INSTDIR\modules\sqmod_irrlicht.dll
  Delete $INSTDIR\modules\sqmod_live555.dll
  Delete $INSTDIR\modules\sqmod_mysql.dll
  Delete $INSTDIR\modules\sqmod_openssl.dll
  Delete $INSTDIR\modules\sqmod_poco.dll
  Delete $INSTDIR\modules\sqmod_portaudio.dll
  Delete $INSTDIR\modules\sqmod_rtmpd.dll
  Delete $INSTDIR\modules\sqmod_ssh2.dll
  Delete $INSTDIR\modules\sqmod_tinyxml.dll

!ifdef INCLUDE_GCC_VERSION
  Delete "$INSTDIR\${FULL_GCC_FILENAME}"
!endif  
  
  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\${APPNAME}\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\${APPNAME}"
  RMDir "$INSTDIR\modules"
  RMDir "$INSTDIR"

SectionEnd

;--------------------------------
; Remove previous version

Function .onInit
!if "${PROC}" == "x64"
	SetRegView 64
!endif
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "UninstallString"
  ReadRegStr $R1 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "InstallLocation"
  StrCmp $R0 "" done
    MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
			   "A previous version of ${APPNAME} was found.$\n$\nIt is recommended that you uninstall it first.$\n$\nDo you want to do that now?" \
			   /SD IDYES IDNO done IDYES uninst
      Abort
uninst:
    ExecWait '$R0 /S _?=$R1'
done: 

  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILENAME}" "UninstallString"
  ReadRegStr $R1 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILENAME}" "InstallLocation"
  StrCmp $R0 "" done_old
    MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
			   "A previous version of ${APPNAME} was found.$\n$\nIt is recommended that you uninstall it first.$\n$\nDo you want to do that now?" \
			   /SD IDYES IDNO done_old IDYES uninst_old
      Abort
uninst_old:
    ExecWait '$R0 /S _?=$R1'
done_old: 

FunctionEnd



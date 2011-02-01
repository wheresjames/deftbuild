; InstallSquirrelScript.nsi
;

;--------------------------------
; The name of the installer and output file

!ifdef DVER
	!define APPNAME "Squirrel Script Engine ${DVER}"
!else
	!define APPNAME "Squirrel Script Engine"
!endif

!define KEYNAME "SquirrelScript"

Name "${APPNAME}"

!ifdef FVER
	OutFile "${OUTROOT}\InstallSquirrelScript${POSTFIX}_${FVER}_${PROC}.exe"
!else
	OutFile "${OUTROOT}\InstallSquirrelScript${POSTFIX}_${PROC}.exe"
!endif

; The default installation directory
InstallDir "$PROGRAMFILES\Squirrel Script Engine"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\SquirrelScript" "Install_Dir"

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
; The stuff to install

Section "${APPNAME} (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  SetOverwrite on
  File "License.txt"
  File "${OUTROOT}\sqrl${POSTFIX}.exe"
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\modules
  
  ; Put file there
  SetOverwrite on
  File "${OUTROOT}\_sqmod\sqmod_cell${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_curl${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_ffmpeg${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_fftw${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_freetype2${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_gdchart${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_irrlicht${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_live555${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_mysql${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_openssl${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_poco${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_portaudio${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_ssh2${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_tinyxml${POSTFIX}.dll"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${KEYNAME}" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "DisplayName" "${APPNAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Squirrel Script Engine"
  CreateShortCut "$SMPROGRAMS\Squirrel Script Engine\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

;--------------------------------
; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}"
  DeleteRegKey HKLM "SOFTWARE\${KEYNAME}"

  ; Remove files and uninstaller
  Delete $INSTDIR\uninstall.exe
  
  Delete $INSTDIR\sqrl.exe  
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
  Delete $INSTDIR\modules\sqmod_ssh2.dll
  Delete $INSTDIR\modules\sqmod_tinyxml.dll

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Squirrel Script Engine\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Squirrel Script Engine"
  RMDir "$INSTDIR\modules"
  RMDir "$INSTDIR"

SectionEnd

;--------------------------------
; Remove previous version

Function .onInit
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${KEYNAME}" "UninstallString"
  StrCmp $R0 "" done
    MessageBox MB_YESNOCANCEL|MB_ICONQUESTION  "A previous version of ${APPNAME} was found.$\n$\nIt is recommended that you uninstall it first.$\n$\nDo you want to do that now?" IDNO done IDYES uninst
      Abort
uninst:
    ExecWait $R0
done: 
FunctionEnd

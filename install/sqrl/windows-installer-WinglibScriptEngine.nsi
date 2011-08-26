; InstallWinglibScriptEngine.nsi
;
;--------------------------------

!define APPNAME "Winglib Script Engine ${PROC}"

!define FILENAME "WinglibScriptEngine"

!define APPKEY "${FILENAME}_${PROC}"

; The name of the installer

; The file to write
!ifdef DVER
	!define APPVNAME "${APPNAME} ${DVER}"
!else
	!define APPVNAME "${APPNAME}"
!endif

Name "${APPVNAME}"

!ifdef FVER
	OutFile "${OUTROOT}\Install${FILENAME}${POSTFIX}_${FVER}_${PROC}.exe"
!else
	OutFile "${OUTROOT}\Install${FILENAME}${POSTFIX}_${PROC}.exe"
!endif

; The default installation director
!if "${PROC}" == "x64"
	InstallDir "$PROGRAMFILES64\${APPNAME}"
!else
	InstallDir "$PROGRAMFILES\${APPNAME}"
!endif

; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "SOFTWARE\${APPKEY}" "Install_Dir"

;--------------------------------
; Pages

;!define MUI_FINISHPAGE_NOAUTOCLOSE
;!define MUI_FINISHPAGE_RUN
;!define MUI_FINISHPAGE_RUN_TEXT "Open Scripts Folder"
;!define MUI_FINISHPAGE_RUN_FUNCTION "OpenScriptsFolder"
;!insertmacro MUI_PAGE_FINISH
;Function OpenScriptsFolder
;	ExecShell "open" "$INSTDIR/scripts"
;FunctionEnd

Page license
LicenseData "License.txt"
Page components
Page directory
Page instfiles


UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "${APPVNAME} (required)"

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
  File "${OUTROOT}\wlink${POSTFIX}.exe"
  File "${LIBROOT}\winglib\etc\scripts\reg_winglib.nut"
  File "${LIBROOT}\winglib\etc\scripts\unreg_winglib.nut"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${APPKEY}" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "DisplayName" "${APPVNAME}"
!ifdef DVER
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "DisplayVersion" "${DVER}"
!endif
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  ; Associate extension
  ExecWait '"$INSTDIR\sqrl${POSTFIX}.exe" "$INSTDIR\reg_winglib.nut"'
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Set PATH for command line"

;	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR"
  
SectionEnd

Section "Squirrel Modules"

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\modules
  
  ; Put file there
  SetOverwrite on
  File "${OUTROOT}\_sqmod\sqmod_cell${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_curl${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_ffmpeg${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_fftw${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_freenect${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_freetype2${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_gdchart${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_haru${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_irrlicht${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_live555${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_mysql${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_openssl${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_poco${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_portaudio${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_quickfix${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_ssh2${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_tinyxml${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_usb${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_vmime${POSTFIX}.dll"

!if "${PROC}" == "x64"
  File "${OUTROOT}\_sqmod\sqmod_mysql${POSTFIX}.dll"
!endif
  
SectionEnd

Section "Media Files"

  ; Media
  SetOutPath $INSTDIR\media
  
  SetOverwrite on
  File "${LIBROOT}\winglib\etc\media\wall_street.jpg"
  File "${LIBROOT}\winglib\etc\media\nurse_shark.avi"
  File "${LIBROOT}\winglib\etc\media\tennis.jpg"
  File "${LIBROOT}\winglib\etc\media\softball.jpg"
  File "${LIBROOT}\winglib\etc\media\basketball.jpg"
  File "${LIBROOT}\winglib\etc\media\440hz.ogg"  
  File "${LIBROOT}\winglib\etc\media\car.png"  

SectionEnd

Section "Example Scripts"

  ; Scripts
  SetOutPath $INSTDIR\scripts
  
  SetOverwrite on
  File "${LIBROOT}\winglib\etc\scripts\auto_logout.nut"
  File "${LIBROOT}\winglib\etc\scripts\irr_bouncing_ball.nut"
  ;File "${LIBROOT}\winglib\etc\scripts\irr_editor.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_capture.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_cell.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_curl.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_ffmpeg.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_fftw.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_freenect.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_freetype2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_gdchart.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_haru.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_http.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_https.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_inline.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_inline.squ"
  File "${LIBROOT}\winglib\etc\scripts\test_int64.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_irrlicht.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_irrlicht2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_memshare.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_mysql.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_openssl.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_poco_mime.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_poco_smtp.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_portaudio.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_portaudio_fftw.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_quickfix.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_registry.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_reboot.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_rtspstream.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_serial_port.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sntp_client.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sntp_server.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sockets.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sockets_server.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sockets_session.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sqexe.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sqlite.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_ssh2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threadkill.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threads.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threads_1.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threads_2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_tinyxml.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_usb.nut"
  File "${LIBROOT}\winglib\etc\scripts\z_primes.nut"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "WetCoin.com Integration"

  ; Start service
  ExecWait '"$INSTDIR\wlink.exe" -install -start'
  
SectionEnd


;--------------------------------
; Uninstaller

Section "Uninstall"
  
!if "${PROC}" == "x64"
	SetRegView 64
!endif

  ; Unassociate extension
  ExecWait '"$INSTDIR\sqrl.exe" "$INSTDIR\unreg_winglib.nut"'

  ; Stop wlink service
  ExecWait '"$INSTDIR\wlink.exe" -stop -uninstall'

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}"
  DeleteRegKey HKLM "SOFTWARE\${APPKEY}"

  ; Remove files and uninstaller
  Delete $INSTDIR\uninstall.exe
  
  Delete $INSTDIR\sqrl.exe  
  Delete $INSTDIR\sqrl-cgi.exe  
  Delete $INSTDIR\wlink.exe  
  Delete $INSTDIR\License.txt  
  Delete $INSTDIR\reg_winglib.nut
  Delete $INSTDIR\unreg_winglib.nut
  
  Delete $INSTDIR\modules\sqmod_cell.dll
  Delete $INSTDIR\modules\sqmod_curl.dll
  Delete $INSTDIR\modules\sqmod_ffmpeg.dll
  Delete $INSTDIR\modules\sqmod_fftw.dll
  Delete $INSTDIR\modules\sqmod_freenect.dll
  Delete $INSTDIR\modules\sqmod_freetype2.dll
  Delete $INSTDIR\modules\sqmod_gdchart.dll
  Delete $INSTDIR\modules\sqmod_haru.dll
  Delete $INSTDIR\modules\sqmod_irrlicht.dll
  Delete $INSTDIR\modules\sqmod_live555.dll
  Delete $INSTDIR\modules\sqmod_mysql.dll
  Delete $INSTDIR\modules\sqmod_openssl.dll
  Delete $INSTDIR\modules\sqmod_poco.dll
  Delete $INSTDIR\modules\sqmod_portaudio.dll
  Delete $INSTDIR\modules\sqmod_ssh2.dll
  Delete $INSTDIR\modules\sqmod_tinyxml.dll
  Delete $INSTDIR\modules\sqmod_usb.dll
  Delete $INSTDIR\modules\sqmod_vmime.dll

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\${APPNAME}\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\${APPNAME}"
  RMDir "$INSTDIR\modules"
  RMDir "$INSTDIR"
  
  ; Remove from path
  ; ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"  

SectionEnd

;--------------------------------
; Remove previous version

Function .onInit
!if "${PROC}" == "x64"
	SetRegView 64
!endif
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "UninstallString"
  StrCmp $R0 "" done
    MessageBox MB_YESNOCANCEL|MB_ICONQUESTION \
			   "A previous version of ${APPNAME} was found.$\n$\nIt is recommended that you uninstall it first.$\n$\nDo you want to do that now?" \
			   /SD IDYES IDNO done IDYES uninst
      Abort
uninst:
    ExecWait '$R0 /S _?=$INSTDIR'
done: 
FunctionEnd


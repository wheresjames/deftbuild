; InstallSquirrelScript.nsi
;

;--------------------------------

!define APPNAME "OSV Squirrel Script Engine"

!define APPKEY "OSVSquirrelScript"

; The name of the installer
Name "${APPNAME}"

; The file to write
OutFile "${OUTROOT}\Install${APPKEY}${POSTFIX}.exe"

; The default installation director
InstallDir "$PROGRAMFILES\${APPNAME}"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${APPKEY}" "Install_Dir"

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
  File "windows-installer-gcc.nsi"
  File "License.txt"
  File "${OUTROOT}\sqrl${POSTFIX}.exe"
  File "${LIBROOT}\winglib\etc\scripts\reg_squirrel.nut"
  File "${LIBROOT}\winglib\etc\scripts\unreg_squirrel.nut"
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\modules
  
  ; Put file there
  SetOverwrite on
  ;File "${OUTROOT}\_sqmod\sqmod_cell${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_curl${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_ffmpeg${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_fftw${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_freetype2${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_gdchart${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_irrlicht${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_live555${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_mysql${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_poco${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_portaudio${POSTFIX}.dll"
  File "${OUTROOT}\_sqmod\sqmod_tinyxml${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_usb${POSTFIX}.dll"
  ;File "${OUTROOT}\_sqmod\sqmod_vmime${POSTFIX}.dll"
  
  ; Media
  SetOutPath $INSTDIR\media
  SetOverwrite off
  File "${LIBROOT}\winglib\etc\media\wall_street.jpg"
  File "${LIBROOT}\winglib\etc\media\nurse_shark.avi"
  File "${LIBROOT}\winglib\etc\media\tennis.jpg"
  File "${LIBROOT}\winglib\etc\media\softball.jpg"
  File "${LIBROOT}\winglib\etc\media\basketball.jpg"
  File "${LIBROOT}\winglib\etc\media\440hz.ogg"  
  File "${LIBROOT}\winglib\etc\media\car.png"  

  ; Scripts
  SetOutPath $INSTDIR\scripts
  SetOverwrite off
  File "${LIBROOT}\winglib\etc\scripts\irr_bouncing_ball.nut"
  File "${LIBROOT}\winglib\etc\scripts\irr_editor.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_capture.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_curl.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_ffmpeg.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_freetype2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_http.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_https.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_irrlicht.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_irrlicht2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_memshare.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_mysql.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_openssl.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_poco.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_portaudio.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_serial_port.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sntp_client.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sntp_server.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sockets.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sockets_server.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sockets_session.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_sqlite.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threads.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threads_1.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_threads_2.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_tinyxml.nut"
  File "${LIBROOT}\winglib\etc\scripts\test_usb.nut"
  File "${LIBROOT}\winglib\etc\scripts\z_primes.nut"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\${APPKEY} "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "DisplayName" "Squirrel Script Engine"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  ; Associate extension
  ExecShell "open" "${OUTROOT}\sqrl.exe reg_squirrel.nut"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Unassociate extension
  ExecShell "open" "${OUTROOT}\sqrl.exe unreg_squirrel.nut"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPKEY}"
  DeleteRegKey HKLM SOFTWARE\${APPKEY}

  ; Remove files and uninstaller
  Delete $INSTDIR\InstallSquirrelScript.nsi
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
  Delete $INSTDIR\modules\sqmod_poco.dll
  Delete $INSTDIR\modules\sqmod_portaudio.dll
  Delete $INSTDIR\modules\sqmod_tinyxml.dll
  Delete $INSTDIR\modules\sqmod_usb.dll
  Delete $INSTDIR\modules\sqmod_vmime.dll

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\${APPNAME}\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\${APPNAME}"
  RMDir "$INSTDIR\modules"
  RMDir "$INSTDIR"

SectionEnd

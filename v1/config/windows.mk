
PRJ_DEFS := $(PRJ_DEFS) _USING_V110_SDK71_
#PRJ_DEFS := $(PRJ_DEFS) _USING_V110_SDK71_

#define _WIN32_WINNT_NT4                    0x0400 // Windows NT 4.0
#define _WIN32_WINNT_WIN2K                  0x0500 // Windows 2000
#define _WIN32_WINNT_WINXP                  0x0501 // Windows XP
#define _WIN32_WINNT_WS03                   0x0502 // Windows Server 2003
#define _WIN32_WINNT_WIN6                   0x0600 // Windows Vista
#define _WIN32_WINNT_VISTA                  0x0600 // Windows Vista
#define _WIN32_WINNT_WS08                   0x0600 // Windows Server 2008
#define _WIN32_WINNT_LONGHORN               0x0600 // Windows Vista
#define _WIN32_WINNT_WIN7                   0x0601 // Windows 7
#define _WIN32_WINNT_WIN8                   0x0602 // Windows 8
#define _WIN32_WINNT_WINBLUE                0x0603 // Windows 8.1
#define _WIN32_WINNT_WINTHRESHOLD           0x0A00 // Windows 10
#define _WIN32_WINNT_WIN10                  0x0A00 // Windows 10

ifneq ($(strip $(findstring 8,$(VSVER))),)
	WINVER := 0x0502
else
	WINVER := 0x0600
endif

PRJ_DEFS := $(PRJ_DEFS) WINVER=$(WINVER) _WIN32_WINNT=$(WINVER)
# PRJ_DEFS := $(PRJ_DEFS) _WINNT=$(WINVER) WINNT=$(WINVER)
# PRJ_DEFS := $(PRJ_DEFS) NTDDI_VERSION=NTDDI_WINXP
	
ifeq ($(OS),win64)
	PRJ_DEFS := $(PRJ_DEFS) WIN64 _WIN64
else
	PRJ_DEFS := $(PRJ_DEFS) WIN32 _WIN32
endif

ifneq ($(findstring windows,$(PRJ_GUIT)),)
	ifeq ($(BUILD),vs)
		CFG_LFLAGS := $(CFG_LFLAGS) /SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup
	else
		CFG_LFLAGS := $(CFG_LFLAGS) -mwindows
	endif
endif

ifneq ($(findstring gui,$(PRJ_GUIT)),)
	ifeq ($(BUILD),vs)
		PRJ_DEFS := $(PRJ_DEFS) OEX_GUI
		PRJ_OSLB := $(PRJ_OSLB) qtmain
		CFG_LFLAGS := $(CFG_LFLAGS) /SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup
	else
		CFG_LFLAGS := $(CFG_LFLAGS) -mwindows
	endif
endif

CFG_OBJ_EXT  := obj
CFG_DEP_EXT  := d
CFG_JAV_EXT  := class
CFG_LIB_PRE	 :=
CFG_LIB_POST := .lib
CFG_EXE_POST := .exe
CFG_DLL_POST := .dll
CFG_IDL_EXT  := idl.log.txt
CFG_ZIP_POST := zip
CFG_DEX_POST := dex
CFG_APK_POST := apk

ifeq ($(BUILD),vs)
	CFG_RES_EXT  := res
else
	CFG_RES_EXT  := $(CFG_OBJ_EXT)
endif

EXISTS_YASM := $(wildcard $(CFG_LIBROOT)/yasm-win)
ifneq ($(strip $(EXISTS_YASM)),)
	ifneq ($(findstring x64,$(BLD)),)
		CFG_YASMROOT := $(CFG_LIBROOT)/yasm-win/x64
	else
		CFG_YASMROOT := $(CFG_LIBROOT)/yasm-win/x86
	endif
	PATH := $(CFG_YASMROOT):$(PATH)
	CFG_YASM := yasm
endif

EXISTS_NSIS := $(wildcard $(CFG_LIBROOT)/nsis)
ifneq ($(strip $(EXISTS_NSIS)),)
	CFG_NSISROOT := $(CFG_LIBROOT)/nsis
	PATH := $(PATH):$(CFG_NSISROOT)
	ifeq ($(BUILD),vs)
		CFG_NSIS := makensis.exe
	else
		ifneq ($(WBLD),)
			CFG_NSIS := makensis.exe
		else
			ifneq ($(XBLD),)
				CFG_NSIS := wine "$(CFG_NSISROOT)/makensis.exe"
			else
				CFG_NSIS := makensis.exe
			endif
		endif
	endif
endif

EXISTS_MSCAB := $(wildcard $(CFG_LIBROOT)/mscab)
ifneq ($(strip $(EXISTS_MSCAB)),)
	CFG_MSCABROOT := $(CFG_LIBROOT)/mscab
	PATH := $(PATH):$(CFG_MSCABROOT)
	CFG_MSCAB := cabarc.exe
endif

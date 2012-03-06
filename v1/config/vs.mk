
CFG_CUR_ROOT := $(subst \,/,$(shell pwd))

PLATFORM := windows

ifdef CFG_VER
	CFG_VER_DEF := /DOEX_PROJECT_VERSION="\"$(CFG_VER)\""
endif
ifdef CFG_FVER
	CFG_VER_DEF := $(CFG_VER_DEF) /DOEX_PROJECT_FILEVERSION="\"$(CFG_FVER)\""
endif
CFG_DEFS := /DOEX_PROJECT_NAME="\"$(CFG_NAME)\"" /DOEX_PROJECT_LNAME="\"$(CFG_LNAME)\"" /DOEX_PROJECT_DESC="\"$(CFG_DESC)\"" $(CFG_VER_DEF)
ifdef SQENGINE
	CFG_DEFS := $(CFG_DEFS) /DOEX_SQENGINE="\"$(SQENGINE)\""
endif	

ifeq ($(PROC),x64)
	OS := win64
else
	ifeq ($(PROC),amd64)
		OS := win64
	else
		ifeq ($(PROC),ia64)
			OS := win64
		else
			OS := win32
		endif
	endif
endif

CFG_LOCAL_TOOL_JOIN := "$(CFG_LOCAL_BUILD_TYPE)/join.exe"

ifdef PRJ_SQEX
	CFG_LOCAL_TOOL_RESCMP  	:= "$(CFG_LOCAL_BUILD_TYPE)/sqrbld.exe"
else
	CFG_LOCAL_TOOL_RESCMP  	:= "$(CFG_LOCAL_BUILD_TYPE)/resbld.exe"
endif

ifeq ($(CFG_STDLIBS),)
	CFG_STDLIBS	:= ws2_32.lib ole32.lib oleaut32.lib user32.lib gdi32.lib comdlg32.lib comctl32.lib rpcrt4.lib shell32.lib advapi32.lib vfw32.lib
endif

# Debug info options
ifneq ($(DBGINFO),)
	CFG_DBGINFO := $(DBGINFO)
endif

ifdef DBG

	ifeq ($(CFG_DBGINFO),)
		# /Z7
		CFG_DBGINFO := /Zi
	endif

	# /Zp16 
	CFG_CEXTRA	 := /DDEBUG /D_DEBUG /D_MT /MTd $(CFG_DBGINFO) $(CFG_CEXTRA)
	ifeq ($(LIBLINK),static)
		ifeq ($(PRJ_TYPE),dll)
			CFG_CEXTRA	 := /D_USRDLL /D_WINDLL $(CFG_CEXTRA)
		endif
	else
		ifeq ($(PRJ_TYPE),dll)
			CFG_CEXTRA 	:= /D_USRDLL /D_WINDLL /D_AFXDLL $(CFG_CEXTRA)
		endif
	endif
	CFG_DPOSTFIX := _d

	# MFC Stuff
	ifeq ($(NOMFC),)
		CFG_MFCV := 42
		ifneq ($(findstring msvs8,$(TGT)),)
			CFG_MFCV := 80
		endif
		ifneq ($(findstring msvs9,$(TGT)),)
			CFG_MFCV := 90
		endif
		ifneq ($(findstring msvs10,$(TGT)),)
			CFG_MFCV := 100
		endif
		CFG_CEXTRA := /D_AFX_NOFORCE_LIBS $(CFG_CEXTRA)
		ifeq ($(LIBLINK),static)
			ifeq ($(UNICODE),)
				ifdef DBG
					CFG_STDLIBS := nafxcwd.lib libcmtd.lib $(CFG_STDLIBS)
				else
					CFG_STDLIBS := nafxcw.lib libcmt.lib $(CFG_STDLIBS)
				endif
			else
				ifdef DBG
					CFG_STDLIBS := unafxcwd.lib libcmtd.lib $(CFG_STDLIBS)
				else
					CFG_STDLIBS := unafxcw.lib libcmt.lib $(CFG_STDLIBS)
				endif
			endif
		else
			ifeq ($(UNICODE),)
				ifdef DBG
					CFG_STDLIBS := mfc$(CFG_MFCV)d.lib mfcs$(CFG_MFCV)d.lib msvcrtd.lib $(CFG_STDLIBS)
				else
					CFG_STDLIBS := mfc$(CFG_MFCV).lib mfcs$(CFG_MFCV).lib msvcrt.lib $(CFG_STDLIBS)
				endif
			else
				ifdef DBG
					CFG_STDLIBS := mfc$(CFG_MFCV)ud.lib mfcs$(CFG_MFCV)ud.lib msvcrtd.lib $(CFG_STDLIBS)
				else
					CFG_STDLIBS := mfc$(CFG_MFCV)u.lib mfcs$(CFG_MFCV)u.lib msvcrt.lib $(CFG_STDLIBS)
				endif
			endif
		endif
	endif

else
	ifeq ($(LIBLINK),static)
		# /Zp16 
		CFG_CEXTRA	 := /D_MT /MT /O2 /DNDEBUG=1 $(CFG_DBGINFO) $(CFG_CEXTRA)
		ifeq ($(PRJ_TYPE),dll)
			CFG_CEXTRA	 := /D_USRDLL /D_WINDLL $(CFG_CEXTRA)
		endif
	else
		ifeq ($(PRJ_TYPE),dll)
			CFG_CEXTRA 	:= /D_USRDLL /D_WINDLL /D_AFXDLL $(CFG_CEXTRA)
		endif
	endif
endif

ifeq ($(PROC),x86)
	CFG_LEXTRA := /MACHINE:x86 $(CFG_LEXTRA)
else
	ifeq ($(PROC),x64)
		CFG_LEXTRA := /MACHINE:x64 $(CFG_LEXTRA)
	else
		CFG_LEXTRA := /MACHINE:$(PROC) $(CFG_LEXTRA)
	endif
endif

ifneq ($(VERBOSELIB),)
	CFG_LEXTRA := $(CFG_LEXTRA) /verbose:lib
endif

ifneq ($(PRJ_ILIB),)
	CFG_LEXTRA := $(CFG_LEXTRA) $(foreach f,$(PRJ_ILIB),/NOD:$(f))
endif

ifneq ($(VSVER),)

	EXISTS_VSROOT := $(wildcard $(CFG_LIBROOT)/$(VSVER))
	ifneq ($(strip $(EXISTS_VSROOT)),)

		CFG_VSROOT := $(CFG_LIBROOT)/$(VSVER)
		CFG_PATHROOT := $(CFG_VSROOT)
		PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC/include
		ifeq ($(NOMFC),)
			PRJ_SYSI := $(PRJ_SYSI) $(CFG_VSROOT)/VC/atlmfc/include
		endif

		ifneq ($(findstring msvs6,$(VSVER)),)
			PATH := $(PATH):$(CFG_PATHROOT)/VC98/Bin:$(CFG_PATHROOT)/COMMON/IDE/IDE98
			PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC98/Include
			ifeq ($(NOMFC),)
				PRJ_SYSI := $(PRJ_SYSI) $(CFG_VSROOT)/VC98/ATL/Include $(CFG_VSROOT)/VC98/MFC/Include
			endif
			PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC98/Lib
			ifeq ($(NOMFC),)
				PRJ_LIBP := $(CFG_VSROOT)/VC98/MFC/Lib
			endif
		else

			PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC/include 
			ifeq ($(NOMFC),)
				PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC/atlmfc 
			endif

			ifeq ($(PROC),x86)
				PATH := $(PATH):$(CFG_PATHROOT)/VC/bin:$(CFG_PATHROOT)/Common7/IDE
				PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/lib
				ifeq ($(NOMFC),)
					PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/atlmfc/lib
				endif
			else
				ifeq ($(PROC),x64)
					MSPROC := amd64
				else
					MSPROC := $(PROC)
				endif
				ifneq ($(findstring x64,$(BLD)),)
					PATH := $(PATH):$(CFG_PATHROOT)/VC/bin/$(MSPROC):$(CFG_PATHROOT)/Common7/IDE
				else
					PATH := $(PATH):$(CFG_PATHROOT)/VC/bin/x86_$(MSPROC):$(CFG_PATHROOT)/VC/bin:$(CFG_PATHROOT)/Common7/IDE
				endif
				PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/lib/$(MSPROC)
				ifeq ($(NOMFC),)
					PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/atlmfc/lib/$(MSPROC)
				endif
			endif
		endif
	endif
endif

#user override?
ifdef PRE
	CFG_TOOLPREFIX = $(strip $(PRE))
endif

ifeq ($(XBLD),)

	CFG_DP 			:= makedepend
	CFG_RM 			:= rmdir /s /q
#		CFG_DEL			:= del /f /q
	CFG_DEL			:= rm -f
	CFG_MD 			:= mkdir -p
	CFG_CPY			:= cp
	CFG_CD 			:= cd
	CFG_SAR			:= sed -i
#		CFG_MD 			:= $(PRJ_LIBROOT)/make_directory.bat
	# +++ As to the line above, I have no clue why, but *sometimes*
	#     make complains that the 'md' command cannot be found on
	#     Windows.  Moving it to a batch file seems to fix the problem.
	#     BTW, it's *not* the embedded relative ellipsis, I suspected
	#     that too.

	ifneq ($(CFG_TOOLPREFIX),)
		CFG_PP := "$(CFG_TOOLPREFIX)cl.exe" /nologo /wd4996
		CFG_CC := "$(CFG_TOOLPREFIX)cl.exe" /nologo /wd4996 /Tc
		CFG_LD := "$(CFG_TOOLPREFIX)link.exe" /nologo
		CFG_AR := "$(CFG_TOOLPREFIX)lib.exe" /nologo
	else
		CFG_PP := "cl.exe" /nologo /wd4996
		CFG_CC := "cl.exe" /nologo /wd4996 /Tc
		CFG_LD := "link.exe" /nologo
		CFG_AR := "lib.exe" /nologo
	endif

else
	CFG_MD 			:= mkdir -p
	CFG_RM 			:= rm -rf
	CFG_DEL			:= rm -f
	CFG_CMDSHELL	:= wine
	CFG_CPY			:= cp
	CFG_CD 			:= cd
	CFG_SAR			:= sed -i
	CFG_PP := wine "$(CFG_TOOLPREFIX)cl" /nologo /wd4996
	CFG_CC := wine "$(CFG_TOOLPREFIX)cl" /nologo /wd4996 /Tc
	CFG_LD := wine $(CFG_TOOLPREFIX)link /NOLOGO
	CFG_AR := wine $(CFG_TOOLPREFIX)lib /nologo
endif

# Tools	


CFG_CC_OUT := /Fo
CFG_LD_OUT := /OUT:
CFG_AR_OUT := /OUT:
CFG_CC_INC := /I

CFG_FLAG_EXPORT := /EXPORT:

CFG_CFLAGS := $(CFG_CFLAGS) /EHsc /c $(CFG_CEXTRA)
CFG_LFLAGS := $(CFG_LEXTRA)

ifeq ($(PRJ_TYPE),dll)
	CFG_LFLAGS := $(CFG_LFLAGS) /DLL
endif

#ifneq ($(CFG_DBGINFO),)
ifdef DBG
	CFG_CFLAGS := $(CFG_CFLAGS)
	CFG_LFLAGS := $(CFG_LFLAGS) /DEBUG
endif

EXISTS_DXSDK := $(wildcard $(CFG_LIBROOT)/msdxsdk)
ifneq ($(strip $(EXISTS_DXSDK)),)
	CFG_DXSDK := $(CFG_LIBROOT)/msdxsdk
	PRJ_SYSI := $(PRJ_SYSI) $(CFG_DXSDK)/Include
	ifeq ($(PROC),x86)			
		PRJ_LIBP := $(PRJ_LIBP) $(CFG_DXSDK)/Lib/x86
	else
		PRJ_LIBP := $(PRJ_LIBP) $(CFG_DXSDK)/Lib/x64
	endif
endif

ifeq ($(strip $(EXISTS_MSPSDK)),)
	EXISTS_MSSIGN := $(wildcard $(CFG_LIBROOT)/mssign)
	ifneq ($(strip $(EXISTS_MSSIGN)),)
		CFG_SIGNROOT := $(CFG_LIBROOT)/mssign
		PATH := $(PATH):$(CFG_SIGNROOT)
		CFG_CODESIGN := codesign.bat
	endif
endif

EXISTS_MSTOOLS := $(wildcard $(CFG_LIBROOT)/mstools)
ifneq ($(strip $(EXISTS_MSTOOLS)),)
	PATH := $(PATH):$(CFG_LIBROOT)/mstools/bin:$(CFG_LIBROOT)/mstools
endif


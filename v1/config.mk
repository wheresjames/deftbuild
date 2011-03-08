
#SHELL=/bin/sh
#SHELL=CMD.EXE

# Example
# make TGT=x86-windows-vs
# make TGT=x86-windows-msvs10
# make TGT=x64-windows-vs BLD=x86-windows-vs
# make TGT=arm-linux-gnu BLD=x86-linux-gnu

# Tuple examples
# x86-windows-vs
# x86-windows-gnu
# x64-windows-vs
# x64-windows-mingw
# x86-linux-gnu
# arm-linux-android
# powerpc-mac-gnu
# arm-linux-buildroot
# arm-iphone-gnu

ifeq ($(TGT),)
	TGT := x86-linux-gnu
endif

#ifeq ($(BLD),)
#	BLD := TGT
#endif

PROC := $(strip $(foreach t,x86 x64 amd64 ia64 arm powerpc,$(findstring $(t),$(TGT))))
ifeq ($(PROC),)
	PROC := x86
endif

ifneq ($(findstring debug,$(TGT)),)
	DBG := 1
endif

ifneq ($(findstring xbld,$(TGT)),)
	XBLD := 1
endif

ifneq ($(findstring vs,$(TGT)),)
	BUILD := vs
	TOOLS := local
	LIBLINK := static
	ifneq ($(findstring msvs,$(TGT)),)
		VSVER := $(strip $(foreach t,msvs6 msvs7 msvs8 msvs9 msvs10,$(findstring $(t),$(TGT))))
	endif		
	ifneq ($(findstring vsexp,$(TGT)),)
		VSVER := $(strip $(foreach t,vsexp8 vsexp9 vsexp10,$(findstring $(t),$(TGT))))
	endif		
else
	BUILD := gcc
	ifneq ($(findstring windows,$(TGT)),)
		LIBLINK := static
		ifeq ($(PROC),x86)
			TOOLS := mingw32
		else
			TOOLS := mingw64
		endif
	else
		TOOLS := local
		LIBLINK := shared
 	endif
endif

ifneq ($(findstring static,$(TGT)),)
	LIBLINK := static
endif
ifneq ($(findstring shared,$(TGT)),)
	LIBLINK := shared
endif

ifneq ($(findstring cygwin,$(BLD)),)
	CYGBLD := 1
endif

ifeq ($(findstring nocyg,$(BLD)),)
	ifneq ($(findstring cygdrive,$(PATH)),)
		CYGBLD := 1
	endif
endif

# config.mk
# Cross compiler config

CFG_NAME := $(PRJ_NAME)
ifndef PRJ_DESC
	CFG_DESC := $(PRJ_NAME)
else
	CFG_DESC := $(PRJ_DESC)
endif

ifndef PRJ_LNAME
	CFG_LNAME := $(CFG_DESC)
else
	CFG_LNAME := $(PRJ_LNAME)
endif

ifneq ($(VER),)
	CFG_VER := $(VER)
	ifndef FVER
		FVER := $(VER)
	endif
else
	ifneq ($(PRJ_VERSION),)
		CFG_VER := $(PRJ_VERSION)
		ifndef PRJ_FVERSION
			PRJ_FVERSION := $(PRJ_VERSION)
		endif
	endif
endif

ifneq ($(FVER),)
	CFG_FVER := $(subst .,_,$(FVER))
else
	ifneq ($(PRJ_FVERSION),)
		CFG_FVER := $(subst .,_,$(PRJ_FVERSION))
	endif
endif

ifdef DIDX
	CFG_IDX=$(DIDX)
else
	CFG_IDX=3
endif

ifeq ($(BUILD),vs)
.PHONE cfg_set_path:
	- $(shell set PATH='$(subst :,':',$(subst ;,:,$(subst \,/,$(PATH))))')
	- $(shell export PATH='$(subst :,':',$(subst ;,:,$(subst \,/,$(PATH))))')
else
.PHONE cfg_set_path:
endif

ifdef PRJ_NAME
ifdef PRJ_DESC

.PHONY cfg_init: cfg_set_path
	- @echo .=======================================================
	- @echo .= $(PRJ_NAME) - $(PRJ_DESC)
	- @echo .=======================================================
	
else

.PHONY cfg_init: cfg_set_path
	- @echo .=======================================================
	- @echo .= $(PRJ_NAME)
	- @echo .=======================================================
	
endif
else

.PHONY cfg_init: cfg_set_path
	- @echo .=======================================================
	- @echo .= PRJ_NAME NOT SPECIFIED
	- @echo .=======================================================
	
endif

#BUILD	 := gcc
#BUILD	 := vs

#OS		 := linux
#OS		 := win32
#OS		 := win64
#OS		 := wince

#PROC	 := x86
#PROC	 := x64
#PROC	 := arm

#TOOLS	 := local
#TOOLS	 := debian
#TOOLS	 := codesourcery
#TOOLS	 := snapgear
#TOOLS	 := buildroot
#TOOLS	 := crosstool
#TOOLS	 := nihilism
#TOOLS	 := openmoko
#TOOLS	 := uclinux
#TOOLS	 := armel
#TOOLS	 := cegcc
#TOOLS	 := mingw32
#TOOLS	 := mingw32ce
#TOOLS	 := iphone
#TOOLS	 := openmoko
#TOOLS	 := mac

DEFLIB	:= lib$(CFG_IDX)

#OS := $(shell uname -o)
#ifeq $(OS) GNU/Linux

#CFG_CURDIR := $(shell pwd)

ifdef PRJ_LOCAL
	CFG_PROC	 := $(CFG_LOCAL_PROC)
	CFG_TOOLS	 := $(CFG_LOCAL_TOOLS)
else
	CFG_PROC	 := $(PROC)
	CFG_TOOLS	 := $(TOOLS)
endif

ifndef PRJ_TYPE
	PRJ_TYPE := exe
endif

ifdef PRJ_ROOT
	CFG_ROOT := $(PRJ_ROOT)
	CFG_TOOLROOT := $(PRJ_ROOT)/tools
	CFG_LIBROOT  := $(PRJ_OSROOT)
	CFG_LIB2BLD  := ../deftbuld/v1
else
	CFG_ROOT := $(PRJ_LIBROOT)/../..
	CFG_TOOLROOT := $(CFG_ROOT)/tools
	CFG_LIBROOT  := $(CFG_ROOT)/$(DEFLIB)
	CFG_LIB2BLD  := ../deftbuild/v1
endif

# Set tools into path
ifeq ($(BUILD),vs)
	EXISTS_MSTOOLS := $(wildcard $(CFG_LIBROOT)/mstools)
	ifneq ($(strip $(EXISTS_MSTOOLS)),)
		PATH := $(CFG_LIBROOT)/mstools/bin;$(CFG_LIBROOT)/mstools;$(PATH)
	endif
endif

ifneq ($(strip $(PRJ_DEPS)),)
	EXISTS_LIBSRC := $(wildcard $(foreach dep,$(PRJ_DEPS),$(CFG_LIBROOT)/$(strip $(dep))))
else
	EXISTS_LIBSRC := nodeps
endif

ifeq ($(strip $(EXISTS_LIBSRC)),) 
UNSUPPORTED := $(PRJ_DEPS) is not checked out
include $(PRJ_LIBROOT)/unsupported.mk
PLATFORM := none
else

ifeq ($(BUILD),vs)
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
else
	ifdef CFG_VER
		CFG_VER_DEF := -DOEX_PROJECT_VERSION="\"$(CFG_VER)\""
	endif
	ifdef CFG_FVER
		CFG_VER_DEF := $(CFG_VER_DEF) -DOEX_PROJECT_FILEVERSION="\"$(CFG_FVER)\""
	endif
	CFG_DEFS := -DOEX_PROJECT_NAME="\"$(CFG_NAME)\"" -DOEX_PROJECT_LNAME="\"$(CFG_LNAME)\"" -DOEX_PROJECT_DESC="\"$(CFG_DESC)\"" $(CFG_VER_DEF)
	ifdef SQENGINE
		CFG_DEFS := $(CFG_DEFS) -DOEX_SQENGINE="\"$(SQENGINE)\""
	endif	
endif

ifdef PRJ_SQRL
	PRJ_INCS := $(PRJ_INCS) winglib/lib/oexlib winglib/lib/sqbind SqPlus/include SqPlus/sqplus
	PRJ_LIBS := $(PRJ_LIBS) sqbind oexlib sqplus sqstdlib squirrel cximage jpeg png tiff zlib
	PRJ_RESD := $(PRJ_RESD) sq
	PRJ_SQEX := $(PRJ_SQEX);*.nut;*.squ
	ifeq ($(PRJ_SQRL),service)
		PRJ_DEFS := $(PRJ_DEFS) OEX_SERVICE
	endif
	ifeq ($(PRJ_TYPE),dll)
		PRJ_EXPORTS := DllMain SRV_GetModuleInfo SRV_Start SRV_Idle SRV_Stop $(PRJ_EXPORTS)
	endif
endif

ifdef SQMOD_STATIC
	PRJ_DEFS := $(PRJ_DEFS) SQBIND_STATIC $(foreach mod,$(SQMOD_STATIC),SQBIND_STATIC_$(mod) )
endif

ifndef PRJ_OPTS
	PRJ_OPTS := -O3
endif

CFG_CEXTRA := $(CFG_CEXTRA) $(PRJ_CFLAGS)

ifdef UNICODE
	CFG_CEXTRA := $(CFG_CEXTRA) -DUNICODE -D_UNICODE
endif

ifdef NOIMAGE
	CFG_CEXTRA := $(CFG_CEXTRA) -DOEX_NOIMAGE
endif

ifneq ($(CXX_INCS),)
	PRJ_SYSI := $(PRJ_SYSI) $(subst :, ,$(subst ;, ,$(subst  ,:,$(CXX_INCS))))
endif
ifneq ($(CXX_LIBP),)
	PRJ_LIBP := $(PRJ_LIBP) $(subst :, ,$(subst ;, ,$(subst  ,:,$(CXX_LIBP))))
endif

ifneq ($(CXX_INCS_$(PROC)),)
	PRJ_SYSI := $(PRJ_SYSI) $(subst :, ,$(subst ;, ,$(subst  ,:,$(CXX_INCS_$(PROC)))))
endif
ifneq ($(CXX_LIBP_$(PROC)),)
	PRJ_LIBP := $(PRJ_LIBP) $(subst :, ,$(subst ;, ,$(subst  ,:,$(CXX_LIBP_$(PROC)))))
endif

ifeq ($(BUILD),vs)

	#CFG_CUR_ROOT := $(shell cd)
	CFG_CUR_ROOT := $(subst \,/,$(shell pwd))

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
	PLATFORM := windows

	ifneq ($(VSVER),)
		ifneq ($(findstring x64,$(BLD)),)
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_ROOT)/bin$(CFG_IDX)/windows-$(VSVER)-win64-x64-local-static
		else
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_ROOT)/bin$(CFG_IDX)/windows-$(VSVER)-win32-x86-local-static
		endif
	else
		ifneq ($(findstring x64,$(BLD)),)
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_ROOT)/bin$(CFG_IDX)/windows-vs-win64-x64-local-static
		else
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_ROOT)/bin$(CFG_IDX)/windows-vs-win32-x86-local-static
		endif
	endif
	#PATH := $(CFG_LOCAL_BUILD_TYPE);$(PATH)
	
	CFG_LOCAL_TOOL_JOIN  	:= "$(CFG_LOCAL_BUILD_TYPE)/join.exe"

	ifdef PRJ_SQEX
		CFG_LOCAL_TOOL_RESCMP  	:= "$(CFG_LOCAL_BUILD_TYPE)/sqrbld.exe"
	else
		CFG_LOCAL_TOOL_RESCMP  	:= "$(CFG_LOCAL_BUILD_TYPE)/resbld.exe"
	endif

	ifdef DBG
		ifeq ($(LIBLINK),static)
			CFG_CEXTRA	 := /DDEBUG /D_DEBUG /D_MT /MTd /Z7 $(CFG_CEXTRA)
		else
			ifeq ($(PRJ_TYPE),dll)
				CFG_CEXTRA	 := /DDEBUG /D_DEBUG /D_MT /MDd /Z7 $(CFG_CEXTRA)
			else
				CFG_CEXTRA	 := /DDEBUG /D_DEBUG /D_MT /MDd /Z7 $(CFG_CEXTRA)
			endif
		endif
		ifeq ($(LIBLINK),static)
			CFG_LEXTRA	 := /DEBUG
		else
			CFG_LEXTRA	 := /DEBUG /NODEFAULTLIB:libcmtd
		endif
		CFG_DPOSTFIX := _d
		ifeq ($(CFG_STDLIBS),)
			CFG_STDLIBS	 := ole32.lib Oleaut32.lib user32.lib gdi32.lib comdlg32.lib comctl32.lib rpcrt4.lib shell32.lib advapi32.lib vfw32.lib
		endif
	else
		ifeq ($(LIBLINK),static)
			CFG_CEXTRA	 := /MT /O2 /Zp16 /DNDEBUG=1 $(CFG_CEXTRA)
		else
			CFG_CEXTRA	 := /MD /O2 /Zp16 /DNDEBUG=1 $(CFG_CEXTRA)
		endif
		CFG_LEXTRA	 :=
		ifeq ($(CFG_STDLIBS),)
			CFG_STDLIBS	 := ole32.lib Oleaut32.lib user32.lib gdi32.lib comdlg32.lib comctl32.lib rpcrt4.lib shell32.lib Advapi32.lib vfw32.lib
		endif
	endif

	ifneq ($(VSVER),)

		EXISTS_VSROOT := $(wildcard $(CFG_LIBROOT)/$(VSVER))
		ifneq ($(strip $(EXISTS_VSROOT)),)

#			ifneq ($(CYGBLD),)
				CFG_VSROOT := $(CFG_LIBROOT)/$(VSVER)
				CFG_PATHROOT := $(CFG_VSROOT)
#				CFG_PATHROOT := $(abspath $(CFG_CUR_ROOT)/$(CFG_VSROOT)
#				CFG_PATHROOT := $(CFG_CUR_ROOT)/$(CFG_VSROOT)
#			else
#				CFG_VSROOT := $(CFG_LIBROOT)/$(VSVER)
#				CFG_PATHROOT := $(CFG_VSROOT)
#			endif
			PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC/include $(CFG_VSROOT)/VC/atlmfc/include

			ifneq ($(findstring msvs6,$(VSVER)),)
				PATH := $(CFG_PATHROOT)/VC98/Bin;$(CFG_PATHROOT)/COMMON/IDE/IDE98;$(PATH)
				PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC98/Include $(CFG_VSROOT)/VC98/ATL/Include $(CFG_VSROOT)/VC98/MFC/Include
				PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC98/Lib $(CFG_VSROOT)/VC98/MFC/Lib
				#CFG_TOOLPREFIX := $(CFG_VSROOT)/VC98/Bin/
			else

				PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC/include 
				ifneq ($(findstring msvs,$(VSVER)),)
					PRJ_SYSI := $(PRJ_SYSI)	$(CFG_VSROOT)/VC/atlmfc 
				endif

				ifeq ($(PROC),x86)			
					PATH := $(CFG_PATHROOT)/VC/bin;$(CFG_PATHROOT)/Common7/IDE;$(CFG_PATHROOT)/VC/redist/x86/Microsoft.VC80.CRT;$(PATH)
					PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/lib
					ifneq ($(findstring msvs,$(VSVER)),)
						PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/atlmfc/lib
					endif
					#CFG_TOOLPREFIX := $(CFG_VSROOT)/VC/bin/
				else
					ifeq ($(PROC),x64)
						MSPROC := amd64
					else
						MSPROC := $(PROC)
					endif
					ifneq ($(findstring x64,$(BLD)),)
						MSCROSS :=
					else
						MSCROSS := x86_
					endif
					PATH := $(CFG_PATHROOT)/VC/bin/$(MSCROSS)$(MSPROC);$(CFG_PATHROOT)/Common7/IDE;$(PATH)
					PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/lib/$(MSPROC)
					ifneq ($(findstring msvs,$(VSVER)),)
						PRJ_LIBP := $(PRJ_LIBP) $(CFG_VSROOT)/VC/atlmfc/lib/$(MSPROC)
					endif
					#CFG_TOOLPREFIX := $(CFG_VSROOT)/VC/bin/$(MSCROSS)$(MSPROC)/
				endif
			endif

#			ifneq ($(CYGBLD),)
				CFG_TOOLPREFIX :=
#			else
				# +++ Not sure of the exact pattern here, but VS 8-10 will crash
				#     having something to do with the combination of forward or 
				#     backslashes in the command line invocation, and the use of 
				#     forward or backslashes in #include statements
#				ifeq ($(findstring win_fwd_slashes,$(PRJ_HACK)),)
#					CFG_TOOLPREFIX := $(subst /,\,$(CFG_TOOLPREFIX))
#				endif
#			endif
			
		endif
	endif

	ifeq ($(OS),win64)
		PRJ_DEFS := $(PRJ_DEFS) WIN64
	else
		PRJ_DEFS := $(PRJ_DEFS) WIN32
	endif
	
	ifeq ($(XBLD),)
	
		CFG_DP 			:= makedepend
		CFG_RM 			:= rmdir /s /q
		CFG_DEL			:= del /f /q
		CFG_MD 			:= mkdir -p
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

	CFG_CFLAGS := /EHsc /c $(CFG_CEXTRA)
	CFG_LFLAGS := $(CFG_LEXTRA)

	ifeq ($(PRJ_TYPE),dll)
		CFG_LFLAGS := $(CFG_LFLAGS) /DLL
	endif

else

	# --with-sysroot
	# --with-headers

	CFG_LOCAL_BUILD_TYPE 	:= $(CFG_ROOT)/bin$(CFG_IDX)/posix-gcc-linux-x86-local-shared
	CFG_LOCAL_TOOL_JOIN  	:= $(CFG_LOCAL_BUILD_TYPE)/join

	ifdef PRJ_SQEX
		CFG_LOCAL_TOOL_RESCMP  	:= "$(CFG_LOCAL_BUILD_TYPE)/sqrbld"
	else
		CFG_LOCAL_TOOL_RESCMP 	:= $(CFG_LOCAL_BUILD_TYPE)/resbld
	endif

	ifdef DBG
		CFG_CEXTRA	 := -g -DDEBUG -D_DEBUG $(CFG_CEXTRA)
		CFG_LEXTRA	 := -g
		CFG_DPOSTFIX := _d
	else
		CFG_CEXTRA	 := $(PRJ_OPTS) -s -DNDEBUG=1 $(CFG_CEXTRA)
		ifneq ($(PRJ_TYPE),dll)
			CFG_LEXTRA	 := -s
		endif
	endif

	# Arm compiler
	ifeq ($(CFG_PROC),arm)

		ifeq ($(CFG_TOOLS),snapgear)

			OS := linux
			PLATFORM := posix

			# Snapgear
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/local/bin/arm-linux-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-linux

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSTRUCTINIT -DOEX_PACKBROKEN -DOEX_NOSHM -DOEX_NODL
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),codesourcery)

			OS := android
			PLATFORM := posix

			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/bin/arm-none-eabi-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/arm-none-eabi

			CFG_STDLIB := -lc -lstdc++ -lg
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_PACKBROKEN -DOEX_NODIRENT -DOEX_NODL
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq
			
			CFG_NODL := 1

		endif
		ifeq ($(CFG_TOOLS),android)

			OS := android
			PLATFORM := posix

			# ./download-toolchain-sources.sh --release=atc --package --verbose
			# ./rebuild-all-prebuilt.sh --verbose --package --toolchain-src-pkg=/tmp/android-ndk-toolchain-atc.tar.bz2

			# Google Android
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/android-ndk/build/prebuilt/linux-x86/arm-eabi-4.4.0/bin/arm-eabi-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/android-ndk/build/platforms/android-8/arch-arm

			CFG_STDLIB := -nostdlib -lgcc -lc -lgcc -lstdc++ -L$(CFG_TOOLROOT)/$(CFG_TOOLS)/android-ndk/build/platforms/android-8/arch-arm/usr/lib
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_PACKBROKEN -DOEX_NODIRENT \
									    -DOEX_NODL -DOEX_NOEXECINFO -DOEX_NOPTHREADCANCEL -DOEX_NOMSGBOX \
									    -DOEX_NOWCSTO -DOEX_NOSETTIME -DOEX_NOTIMEGM -DOEX_NOTHREADTIMEOUTS
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

			ifeq ($(LIBLINK),static)
				CFG_NODL := 1
			endif

		endif
		ifeq ($(CFG_TOOLS),crystax)

			OS := android
			PLATFORM := posix

			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build/prebuilt/linux-x86/arm-eabi-4.4.0/bin/arm-eabi-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build/platforms/android-8/arch-arm

			CFG_STDLIB := -nostdlib -lgcc -lc -lgcc -lstdc++ -L$(CFG_TOOLROOT)/$(CFG_TOOLS)/build/platforms/android-8/arch-arm/usr/lib
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_PACKBROKEN -DOEX_NODIRENT \
									    -DOEX_NODL -DOEX_NOEXECINFO -DOEX_NOPTHREADCANCEL -DOEX_NOMSGBOX \
									    -DOEX_NOWCSTO -DOEX_NOSETTIME -DOEX_NOTIMEGM -DOEX_NOTHREADTIMEOUTS
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq
			
			ifeq ($(LIBLINK),static)
				CFG_NODL := 1
			endif

		endif
		ifeq ($(CFG_TOOLS),nihilism)

			OS := linux
			PLATFORM := posix

			# nihilism
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/arm-unknown-linux-gnu-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-unknown-linux-gnu

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_PACKBROKEN -DOEX_NOVIDEO -DOEX_NODL
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),uclinux)

			OS := linux
			PLATFORM := posix

			# uclinux
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/local/bin/arm-linux-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/local/arm-linux

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_PACKBROKEN -DOEX_NOVIDEO -D__GCC_FLOAT_NOT_NEEDED
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),openmoko)

			OS := linux
			PLATFORM := posix

			# openmoko
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/bin/arm-angstrom-linux-gnueabi-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm/arm-angstrom-linux-gnueabi

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOVIDEO
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),armel)

			OS := linux
			PLATFORM := posix

			# armel
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/bin/arm-linux-gnu-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOVIDEO
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),buildroot)

			OS := linux
			PLATFORM := posix

			# buildroot
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build_arm/staging_dir/usr/bin/arm-linux-uclibcgnueabi-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/build_arm/staging_dir/

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOSTAT64 \
											    -DOEX_NOWCHAR -DOEX_NOEXECINFO -D_FILE_OFFSET_BITS=32
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),crosstool)

			OS := linux
			PLATFORM := posix

			# crosstool
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/bin/arm-crosstool-linux-gnueabi-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/usr/arm-crosstool-linux-gnueabi

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT -DOEX_NOSTAT64 \
										   -DOEX_NOWCHAR -DOEX_NOEXECINFO
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),scratchbox)

			OS := linux
			PLATFORM := posix

			# scratchbox/compilers/arm-linux-gcc3.4.cs-glibc2.3/bin/arm-linux-g++
			# scratchbox/compilers/arm-linux-gcc3.4.cs-glibc2.3/bin

			# martin's crosstool build
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-gcc3.4-uclibc0.9.28/bin/arm-linux-
			#CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-gcc3.4-uclibc0.9.28

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM -DOEX_NOSTRUCTINIT \
												-DOEX_NOSTAT64 -DOEX_NOWCHAR -DOEX_NOEXECINFO -DOEX_PACKBROKEN
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),iphone)

			OS := darwin9
			PLATFORM := posix

			# iphone
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/tc/toolchain/pre/bin/arm-apple-darwin9-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/tc/toolchain/sys/

			CFG_STDLIB :=
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -DOEX_IPHONE -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSHM \
											    -DOEX_NOSTRUCTINIT -DOEX_NOSTAT64 -DOEX_NOVIDEO -DOEX_NOEPOLL
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),cegcc)

			OS := wince
			PLATFORM := windows

			# cegcc
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/arm-wince-cegcc-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-wince-cegcc/

			CFG_STDLIB := -lole32
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -D_WIN32_WCE=0x0400 -DOEX_ARM -D__int64="long long" \
											    -DOEX_LOWRAM -DOEX_NOVIDEO -DOEX_NOCRTDEBUG -DOEX_NOXIMAGE
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

			CFG_EXE_POST := .exe

		endif
		ifeq ($(CFG_TOOLS),mingw32ce)

			OS := wince
			PLATFORM := windows

			# mingw32ce
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/arm-wince-mingw32ce-
			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/arm-wince-mingw32ce/

			CFG_STDLIB := -lole32 -laygshell -lwinsock -lws2
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -D_WIN32_WCE=0x0400 -DOEX_ARM -D__int64="long long" \
											    -DOEX_LOWRAM -DOEX_NOCRTDEBUG -DOEX_NODSHOW -DOEX_NOVFW
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

			CFG_EXE_POST := .exe

		endif
		ifeq ($(CFG_TOOLS),)


			OS := linux
			PLATFORM := posix

			# Custom tools
			CFG_TOOLPREFIX := $(CFG_TOOLROOT)/$(CFG_TOOLS)/bin/$(CFG_TOOLS)-
#			CFG_SYSROOT := $(CFG_TOOLROOT)/$(CFG_TOOLS)/sysroot
			override CFG_TOOLS := custom

			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -fexceptions -MMD -DOEX_ARM -DOEX_LOWRAM -DOEX_NOSTRUCTINIT \
									                         -DOEX_PACKBROKEN -DOEX_NOSHM
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif

	else

		ifeq ($(CFG_TOOLS),mingw32)

			OS := win32
			PLATFORM := windows

			# Cross compile for windows
			CFG_TOOLPREFIX := i586-mingw32msvc-
			# CFG_TOOLPREFIX := ~/mingw32/bin/i586-pc-mingw32-
			# --whole-archive -rdynamic

			CFG_STDLIB := -lole32 -lgdi32 -lwsock32 -lws2_32 -lvfw32
			CFG_LFLAGS := $(CFG_LEXTRA) -export-all-symbols
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -Wall -fno-strict-aliasing \
										-DOEX_NODSHOW -DOEX_NOCRTDEBUG -D__int64="long long" -DOEX_NOSTRUCTINIT
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),mingw64)

			OS := win64
			PLATFORM := windows
			
			EXISTS_MINGW64 := $(wildcard $(CFG_LIBROOT)/mingw64)
			ifneq ($(strip $(EXISTS_MINGW64)),)
			
				CFG_TOOLPREFIX := $(CFG_LIBROOT)/mingw64/bin/x86_64-w64-mingw32-
				CFG_SYSROOT := $(CFG_LIBROOT)/mingww64/x86_64-w64-mingw32
				
			else

				# Cross compile for windows
				CFG_TOOLPREFIX := amd64-mingw32msvc-
				# CFG_TOOLPREFIX := ~/mingw64/bin/amd64-mingw32msvc
			
			endif

			# -fstack-check
			CFG_STDLIB := -lole32 -lgdi32 -lwsock32 -lws2_32 -lavicap32 -lmsvfw32
			CFG_LFLAGS := $(CFG_LEXTRA) -export-all-symbols -fno-leading-underscore -static-libgcc -static-libstdc++
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -Wall -fno-strict-aliasing -fno-leading-underscore \
										-DOEX_NODSHOW -DOEX_NOCRTDEBUG -DOEX_NOSTRUCTINIT -D__int64="long long"
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),mac)

			OS := apple
			PLATFORM := posix

			# Cross compile for mac
			CFG_TOOLPREFIX :=

			CFG_STDLIB :=
			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -Wall -fno-strict-aliasing \
									    -DOEX_NOSTRUCTINIT
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq

		endif
		ifeq ($(CFG_TOOLS),local)

			OS := linux
			PLATFORM := posix

			# Local platform
			CFG_TOOLPREFIX :=

			# -mtune=generic -mfpmath=387 -mno-sse2
			# -lregex -lpng -ljpeg -lzlib -ltiff -lstdc++ -lgcc -lodbc32 -lwsock32 -lwinspool -lwinmm -lshell32 -lcomctl32 -lctl3d32 -lodbc32 -ladvapi32 -lodbc32 -lwsock32 -lopengl32 -lglu32 -lole32 -loleaut32
			# --whole-archive
			
			CFG_STDLIB := -lrt -pthread
			CFG_LFLAGS := $(CFG_LEXTRA) -rdynamic -Wl,-E -Wl,--export-dynamic
#			CFG_LFLAGS := $(CFG_LEXTRA)
			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -Wall -fno-strict-aliasing
#			CFG_CFLAGS := $(CFG_CEXTRA) -c -MMD -Wall
			CFG_SFLAGS := $(CFG_CFLAGS) -S -MMD
			CFG_AFLAGS := cq
			CFG_ASFLAGS := -f elf32 -a x86
			
		endif

	endif

	ifeq ($(LIBLINK),shared)
		CFG_LFLAGS := $(CFG_LFLAGS)
		ifndef PRJ_NPIC
			CFG_CFLAGS := $(CFG_CFLAGS) -fPIC -DPIC
		endif
	endif

	ifeq ($(PRJ_TYPE),dll)
		CFG_LFLAGS := $(CFG_LFLAGS) -shared
	else
		ifeq ($(LIBLINK),static)
			CFG_LFLAGS := $(CFG_LFLAGS) -static -static-libgcc
		endif
	endif


	# you can't use dlopen() [-ldl] with static linking!
	# http://www.qnx.com/developers/docs/6.3.2/neutrino/lib_ref/d/dlopen.html
	ifeq ($(PLATFORM),posix)
#		ifeq ($(LIBLINK),shared)
		ifndef CFG_NODL
			CFG_STDLIB := $(CFG_STDLIB) -ldl
		endif
#		endif
	endif

#	ifeq ($(PRJ_TYPE),dll)
#		CFG_LD := $(CFG_TOOLPREFIX)ld -E --export-dynamic
#	else
#		ifeq ($(PRJ_TYPE),lib)
#			CFG_LD := $(CFG_TOOLPREFIX)ld -E --export-dynamic
#		else
#			CFG_LD := $(CFG_TOOLPREFIX)g++ -rdynamic -Wl,-E -Wl,--export-dynamic
#		endif
#	endif

	ifneq ($(CFG_SYSROOT),)
		CFG_SYSROOT_OPTIONS := --sysroot=$(CFG_SYSROOT)
	endif

	ifneq ($(CFG_SYSROOT_HEADERS),)
		CFG_SYSROOT_OPTIONS := $(CFG_SYSROOT_OPTIONS) --headers=$(CFG_SYSROOT_HEADERS)
	endif

	# Tools
	CFG_PP := $(CFG_TOOLPREFIX)g++ $(CFG_SYSROOT_OPTIONS)
	CFG_LD := $(CFG_TOOLPREFIX)g++
	CFG_CC := $(CFG_TOOLPREFIX)gcc $(CFG_SYSROOT_OPTIONS)
	CFG_AR := $(CFG_TOOLPREFIX)ar
	CFG_DT := $(CFG_TOOLPREFIX)dlltool
	CFG_DP := $(CFG_TOOLPREFIX)makedepend
	CFG_AS := $(CFG_TOOLPREFIX)as
	
	CFG_ASM := yasm

	CFG_MD := mkdir -p
	CFG_RM := rm -rf
	CFG_DEL:= rm -f

	CFG_CC_OUT := -o $(nullstring)
	CFG_LD_OUT := -o $(nullstring)

	CFG_CUR_ROOT := $(shell pwd)

	CFG_CC_INC := -I

endif

ifeq ($(PLATFORM),windows)

	CFG_OBJ_EXT  := obj
	CFG_RES_EXT  := res
	CFG_DEP_EXT  := d
	CFG_LIB_PRE	 :=
	CFG_LIB_POST := .lib
	CFG_EXE_POST := .exe
	CFG_DLL_POST := .dll
	
	PRJ_DEFS := $(PRJ_DEFS) WINVER=0x0501 _WIN32_WINNT=0x0501
	#PRJ_DEFS := $(PRJ_DEFS) NTDDI_VERSION=NTDDI_WINXP
		
	EXISTS_MSPSDK := $(wildcard $(CFG_LIBROOT)/mspsdk)
	ifneq ($(strip $(EXISTS_MSPSDK)),)
		CFG_MSPSDK := $(CFG_LIBROOT)/mspsdk
		PRJ_SYSI := $(CFG_MSPSDK)/Samples/multimedia/directshow/baseclasses $(CFG_MSPSDK)/Include $(PRJ_SYSI)
		ifeq ($(PROC),x86)			
			PRJ_LIBP := $(CFG_MSPSDK)/Lib $(PRJ_LIBP)
		else
			ifeq ($(PROC),ia64)			
				PRJ_LIBP := $(CFG_MSPSDK)/Lib/IA64 $(PRJ_LIBP)
			else
				PRJ_LIBP := $(CFG_MSPSDK)/Lib/x64 $(PRJ_LIBP)
			endif
		endif
		ifeq ($(BUILD),vs)
			CFG_RC := $(CFG_MSPSDK)/Bin/rc
		else
			CFG_RC := rc
		endif
	else
		CFG_RC := rc
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

else

	CFG_OBJ_EXT := o
	CFG_DEP_EXT := d
	CFG_LIB_PRE	 := lib
	CFG_LIB_POST := .a
	CFG_DLL_PRE	 := lib
	CFG_DLL_POST := .so
	
endif

ifdef PRJ_DEFS
	ifeq ($(BUILD),vs)
		CFG_DEFS := $(CFG_DEFS) $(foreach def,$(PRJ_DEFS),/D$(def) )
	else
		CFG_DEFS := $(CFG_DEFS) $(foreach def,$(PRJ_DEFS),-D$(def) )
	endif
	PRJ_DEFS :=
endif

#ifneq ($(VSVER),)
#	UTOOLS := $(VSVER)
#else
	UTOOLS := $(TOOLS)
#endif

ifneq ($(VSVER),)
	CFG_BUILD_TYPE := $(PLATFORM)-$(VSVER)-$(OS)-$(PROC)-$(UTOOLS)
else
	CFG_BUILD_TYPE := $(PLATFORM)-$(BUILD)-$(OS)-$(PROC)-$(UTOOLS)
endif

ifdef UNICODE
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-unicode
endif

ifdef DBG
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-debug
endif

ifeq ($(LIBLINK),static)
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-static
else
	CFG_BUILD_TYPE := $(CFG_BUILD_TYPE)-shared
endif

CFG_BINROOT  := $(CFG_ROOT)/bin$(CFG_IDX)/$(CFG_BUILD_TYPE)
CFG_LOCAL_BINROOT  := $(CFG_ROOT)/bin$(CFG_IDX)/$(CFG_LOCAL_BUILD_TYPE)

ifdef PRJ_BINROOT
	CFG_OUTROOT := $(PRJ_BINROOT)/bin$(CFG_IDX)/$(CFG_BUILD_TYPE)
else
	CFG_OUTROOT  := $(CFG_BINROOT)
endif

ifdef PRJ_SUBROOT
	CFG_OUTROOT := $(CFG_OUTROOT)/$(PRJ_SUBROOT)
endif

CFG_INCS := $(foreach inc,$(PRJ_INCS), $(CFG_CC_INC)$(CFG_LIBROOT)/$(inc))

#ifneq ($(PROC),x86)
	CFG_TOOL_RESCMP  := $(CFG_LOCAL_TOOL_RESCMP)
	CFG_TOOL_JOIN  := $(CFG_LOCAL_TOOL_JOIN)
	CFG_TOOL_TOUCH := touch
#else
#	CFG_TOOL_RESCMP  := $(CFG_OUTROOT)/$(CFG_EXE_PRE)resbld$(CFG_DPOSTFIX)$(CFG_EXE_POST)
#	CFG_TOOL_JOIN  := $(CFG_OUTROOT)/$(CFG_EXE_PRE)join$(CFG_DPOSTFIX)$(CFG_EXE_POST)
#endif

ifdef PRJ_RESD

ifdef PRJ_RESP
	CFG_RES_INP := $(foreach res,$(PRJ_RESD),$(PRJ_RESP)/$(res))
else
	CFG_RES_INP := $(foreach res,$(PRJ_RESD),$(res))
endif

CFG_RES_OUT := $(CFG_OUTROOT)/_0_res/$(PRJ_NAME)
CFG_RES_DEP := $(CFG_RES_OUT)/oexres.dpp
CFG_RES_INC := $(CFG_RES_OUT)/oexres.h
CFG_RES_MAK := $(CFG_RES_OUT)/oexres.mk

.PRECIOUS: $(CFG_RES_DEP)
$(CFG_RES_MAK):
	$(CFG_TOOL_RESCMP) -d:"$(CFG_RES_INP)" -o:"$(CFG_RES_OUT)" -c:"$(PRJ_SQEX)"

.PRECIOUS: $(CFG_RES_MAK)
include $(CFG_RES_MAK)
CFG_RES_OBJ := $(subst .cpp,.$(CFG_OBJ_EXT),$(RES_CPP))

.PRECIOUS: $(CFG_RES_DEP)
$(CFG_RES_DEP): $(CFG_RES_MAK) $(RES_CPP)
	$(CFG_TOOL_RESCMP) -d:"$(CFG_RES_INP)" -o:"$(CFG_RES_OUT)" -c:"$(PRJ_SQEX)"

include $(CFG_RES_DEP)

ifneq ($(BUILD),vs)
	include $(wildcard $(CFG_RES_OUT)/*.$(CFG_DEP_EXT))
endif

#.PRECIOUS: $(CFG_RES_OUT)/%.cpp: $(RES_CPP)
$(CFG_RES_OUT)/%.cpp:
	$(CFG_TOOL_TOUCH) "$@"

.PRECIOUS: $(CFG_RES_OUT)/%.$(CFG_OBJ_EXT)
$(CFG_RES_OUT)/%.$(CFG_OBJ_EXT): $(CFG_RES_OUT)/%.cpp $(CFG_RES_DEP)
	$(CFG_PP) $(CFG_CFLAGS) $(CFG_INCS) $< $(CFG_CC_OUT)$@

endif

endif


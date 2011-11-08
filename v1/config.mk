
#SHELL=/bin/bash
#SHELL=CMD.EXE

# iii. I'm permanently giving up on the Windows command line,
#      there are just too many bugs and limitations.
#	   You will need to use cygwin on Windows.

# delete / new already defined in nafxcwd.lib;libcmtd.lib
# http://support.microsoft.com/kb/148652

CFG_COMMA:=,
CFG_SPACE:=
CFG_SPACE+=
CFG_FWD_ESCAPE = $(subst /,\/,$(1))

ifdef DIDX
	CFG_IDX=$(DIDX)
else
	CFG_IDX=3
endif

DEFLIB	:= lib$(CFG_IDX)

# Setup basic paths
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
	CFG_PATH_CONFIG := $(PRJ_LIBROOT)/config
	CFG_PATH_BUILD := $(PRJ_LIBROOT)/build
	CFG_PATH_GO := $(PRJ_LIBROOT)/go
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
include $(CFG_PATH_CONFIG)/tgt.mk

#ifeq ($(BLD),)
#	BLD := TGT
#endif
include $(CFG_PATH_CONFIG)/bld.mk

# config.mk
# Cross compiler config
#
#BUILD	 := gcc vs
#
#OS		 := linux win32 win64 wince osx android iphone
#
#PROC	 := x86 x64 arm
#
#TOOLS	 := local debian codesourcery snapgear buildroot crosstool nihilism openmoko \
#			uclinux armel cegcc mingw32 mingw32ce iphone openmoko mac

include $(CFG_PATH_CONFIG)/init.mk

ifdef PRJ_SQRL
	include $(CFG_PATH_CONFIG)/sqrl.mk
endif

ifdef PRJ_QTWK
	include $(CFG_PATH_CONFIG)/qtwk.mk
endif

# +++ ???
CFG_CEXTRA := $(CFG_CEXTRA) $(PRJ_CFLAGS)

ifdef UNICODE
	CFG_CEXTRA := $(CFG_CEXTRA) -DUNICODE -D_UNICODE
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

# What are we building on?
ifneq ($(WBLD),)
	include $(CFG_PATH_CONFIG)/windows-build.mk
	include $(CFG_PATH_CONFIG)/tools-win.mk
else
	include $(CFG_PATH_CONFIG)/linux-build.mk
	include $(CFG_PATH_CONFIG)/tools-linux.mk
endif

# Which compiler is building the target?
ifeq ($(BUILD),vs)
	include $(CFG_PATH_CONFIG)/vs.mk
else
	include $(CFG_PATH_CONFIG)/gcc.mk
endif

# What platform are we targeting?
ifeq ($(PLATFORM),windows)
	include $(CFG_PATH_CONFIG)/windows.mk
else
	include $(CFG_PATH_CONFIG)/posix.mk
endif

# Import project defs
ifdef PRJ_DEFS
	ifeq ($(BUILD),vs)
		CFG_DEFS := $(CFG_DEFS) $(foreach def,$(PRJ_DEFS),/D$(def) )
	else
		CFG_DEFS := $(CFG_DEFS) $(foreach def,$(PRJ_DEFS),-D$(def) )
	endif
	PRJ_DEFS :=
endif

include $(CFG_PATH_CONFIG)/paths.mk

ifdef PRJ_RESD
	include $(CFG_PATH_CONFIG)/res.mk
endif

CFG_EOF := 1

# UNSUPPORTED
endif


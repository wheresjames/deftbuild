
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := scintilla
PRJ_DEPS := scintilla
PRJ_TYPE := lib
PRJ_INCS := scintilla/include scintilla/src
PRJ_LIBS := 
PRJ_DEFS := STATIC_BUILD

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PROC),arm)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := cxx
LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/scintilla/src
include $(PRJ_LIBROOT)/build.mk

ifeq ($(PLATFORM),windows)
	export LOC_TAG := win
	LOC_CXX_win := cxx
	LOC_BLD_win := cpp
	LOC_SRC_win := $(CFG_LIBROOT)/scintilla/win32
	include $(PRJ_LIBROOT)/build.mk
endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

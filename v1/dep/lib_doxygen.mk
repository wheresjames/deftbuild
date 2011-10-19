
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := doxygen
PRJ_DEPS := doxygen
PRJ_TYPE := exe
PRJ_INCS := doxygen/libmd5 doxygen/qtools
PRJ_LIBS := 
PRJ_WINL := iconv
#PRJ_WINL := winmm strmiids wininet odbc32

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

ifeq ($(PLATFORM),windows)
	PRJ_LIBP := $(PRJ_LIBP) $(CFG_LIBROOT)/doxygen/winbuild
	PRJ_INCS := $(PRJ_INCS) doxygen/winbuild
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/doxygen/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := c
LOC_CXX_c := c
LOC_SRC_c := $(CFG_LIBROOT)/doxygen/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := qtools
LOC_SRC_qtools := $(CFG_LIBROOT)/doxygen/qtools
ifeq ($(PLATFORM),windows)
	LOC_WEX_qtools := *unix*
endif
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := libmd5
LOC_SRC_libmd5 := $(CFG_LIBROOT)/doxygen/libmd5
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif



default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := lame
PRJ_DEPS := lame
PRJ_TYPE := lib
PRJ_INCS := lame/include
PRJ_LIBS := 
PRJ_DEFS := HAVE_CONFIG_H=1

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
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/lame/inc/windows $(PRJ_INCS)
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/lame/inc/posix $(PRJ_INCS)
endif

ifeq ($(BUILD),gcc)
    CFG_CFLAGS := $(CFG_CFLAGS) -ffast-math -fomit-frame-pointer -std=c99   
    ifdef DBG
		CFG_CFLAGS := $(CFG_CFLAGS) -fno-stack-check -O1
    endif
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := common
LOC_CXX_common := c
LOC_SRC_common := $(CFG_LIBROOT)/lame/libmp3lame
LOC_EXC_common := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

#endif

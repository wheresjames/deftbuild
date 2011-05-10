
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := mimetic
PRJ_DEPS := mimetic
PRJ_TYPE := lib
PRJ_INCS := mimetic
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_DEFS := uint32_t=unsigned
	endif
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/mimetic/inc/windows $(PRJ_INCS)
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/mimetic/inc/posix $(PRJ_INCS)
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := cxx
LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/mimetic/mimetic
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := codec
LOC_CXX_codec := cxx
LOC_BLD_codec := cpp
LOC_SRC_codec := $(CFG_LIBROOT)/mimetic/mimetic/codec
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := os
LOC_CXX_os := cxx
LOC_BLD_os := cpp
LOC_SRC_os := $(CFG_LIBROOT)/mimetic/mimetic/os
ifeq ($(PLATFORM),windows)
	LOC_EXC_os := mmfile
endif
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := rfc822
LOC_CXX_rfc822 := cxx
LOC_BLD_rfc822 := cpp
LOC_SRC_rfc822 := $(CFG_LIBROOT)/mimetic/mimetic/rfc822
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

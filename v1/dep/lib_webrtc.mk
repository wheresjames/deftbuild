
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := webrtc
PRJ_DEPS := webrtc
PRJ_TYPE := lib
PRJ_INCS := jsoncpp/include webrtc
PRJ_DEFS := WEBRTC_WIN
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_CXX_def := cc
LOC_BLD_def := cpp
LOC_WEX_def := *_unittest *_main
LOC_EXC_def := checks testclient latebindingsymboltable
ifeq ($(PLATFORM),windows)
	LOC_EXC_def := $(LOC_EXC_def) unixfilesystem posix x11windowpicker \
				   timeutils
	LOC_WEX_def := $(LOC_WEX_def) mac*
endif
LOC_SRC_def := $(CFG_LIBROOT)/webrtc/webrtc/base
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


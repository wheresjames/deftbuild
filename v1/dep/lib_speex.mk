
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := speex
PRJ_DEPS := speex
PRJ_TYPE := lib
PRJ_INCS := speex/include fftw/api
PRJ_LIBS := 
PRJ_DEFS := FLOATING_POINT EXPORT= USE_GPL_FFTW3

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(BUILD),vs)
	PRJ_DEFS := inline=__inline
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
#LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/speex/libspeex
LOC_EXC_def :=
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := os
#LOC_CXX_os := c
#LOC_SRC_os := $(CFG_LIBROOT)/libusb/libusb/os
#ifeq ($(PLATFORM),windows)
#	LOC_LST_os := poll_windows windows_usb threads_windows
#else
#	LOC_LST_os := linux_usbfs
#endif
#include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

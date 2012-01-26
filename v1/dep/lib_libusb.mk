
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := usb
PRJ_DEPS := libusb
PRJ_TYPE := lib
PRJ_INCS := libusb libusb/libusb
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

#ifeq ($(BUILD),vs)
#UNSUPPORTED := BUILD=$(BUILD) is invalid, ffmpeg can only be built with 'gcc'
#include $(PRJ_LIBROOT)/unsupported.mk
#else

ifeq ($(BUILD),vs)
	PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/vs/inc/c99
	PRJ_DEFS := $(PRJ_DEFS) ssize_t=unsigned
else
	CFG_CFLAGS := $(CFG_CFLAGS) -std=gnu99
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/libusb/libusb
LOC_EXC_def :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := os
LOC_CXX_os := c
LOC_SRC_os := $(CFG_LIBROOT)/libusb/libusb/os
ifeq ($(PLATFORM),windows)
	LOC_LST_os := poll_windows windows_usb threads_windows
else
	LOC_LST_os := linux_usbfs
endif
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

#endif

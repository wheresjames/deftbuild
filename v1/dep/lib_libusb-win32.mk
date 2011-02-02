
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := usb-win32
PRJ_DEPS := libusb-win32
PRJ_TYPE := lib
PRJ_INCS := libusb-win32/libusb libusb-win32/msvc
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),windows)
UNSUPPORTED := PLATFORM=$(PLATFORM) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

PRJ_INCS := $(PRJ_INCS) libusb-win32/libusb libusb-win32/msvc

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/libusb-win32/libusb
LOC_EXC_def :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := os
LOC_CXX_os := c
LOC_SRC_os := $(CFG_LIBROOT)/libusb-win32/libusb/os
LOC_EXC_os := darwin_usb linux_usbfs
include $(PRJ_LIBROOT)/build.mk


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif


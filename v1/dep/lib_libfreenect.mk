
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := freenect
PRJ_DEPS := libfreenect
PRJ_TYPE := lib
PRJ_INCS := libfreenect/include
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(BUILD),vs)
	PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/vs/inc/c99 \
							libusb libusb/libusb
#							libusb-win32/libusb libusb-win32/msvc
	PRJ_DEFS := $(PRJ_DEFS) ssize_t=unsigned
	PRJ_LIBS := $(PRJ_LIBS) usb
else
	PRJ_INCS := $(PRJ_INCS) libusb libusb/libusb
	PRJ_LIBS := $(PRJ_LIBS) usb
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
ifeq ($(BUILD),vs)
	LOC_BLD_def := cpp
endif
LOC_SRC_def := $(CFG_LIBROOT)/libfreenect/src
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


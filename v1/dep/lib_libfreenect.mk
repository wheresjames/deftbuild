
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

ifeq ($(PLATFORM),windows)
	PRJ_INCS := libusb-win32/libusb $(PRJ_INCS)		
	ifeq ($(BUILD),vs)
		PRJ_DEFS := ssize_t=unsigned
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/vs $(PRJ_INCS)		
	endif
else
	PRJ_INCS := $(PRJ_INCS) libusb libusb/libusb
	PRJ_LIBS := $(PRJ_LIBS) usb
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/libfreenect/src
LOC_EXC_def :=
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


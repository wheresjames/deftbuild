
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := portaudio
PRJ_DEPS := portaudio
PRJ_TYPE := lib
PRJ_INCS := portaudio/include portaudio/src/common
PRJ_LIBS := 
PRJ_DEFS :=

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
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/portaudio/src/common
include $(PRJ_LIBROOT)/build.mk

ifeq ($(PLATFORM),windows)
export LOC_TAG := win
LOC_CXX_win := c
LOC_SRC_win := $(CFG_LIBROOT)/portaudio/src/os/win
include $(PRJ_LIBROOT)/build.mk
else
export LOC_TAG := unix
LOC_CXX_unix := c
LOC_SRC_unix := $(CFG_LIBROOT)/portaudio/src/os/unix
include $(PRJ_LIBROOT)/build.mk
endif


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk



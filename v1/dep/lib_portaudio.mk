
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

PRJ_DEFS := $(PRJ_DEFS) PA_NO_ASIO PA_NO_WASAPI
PRJ_INCS := $(PRJ_INCS) portaudio/src/os/win

export LOC_TAG := win
LOC_CXX_win := c
LOC_SRC_win := $(CFG_LIBROOT)/portaudio/src/os/win
include $(PRJ_LIBROOT)/build.mk

# export LOC_TAG := asio
# LOC_SRC_asio := $(CFG_LIBROOT)/portaudio/src/hostapi/asio
# include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := dsound
LOC_CXX_dsound := c
LOC_SRC_dsound := $(CFG_LIBROOT)/portaudio/src/hostapi/dsound
include $(PRJ_LIBROOT)/build.mk

# export LOC_TAG := wasapi
# LOC_CXX_wasapi := c
# LOC_SRC_wasapi := $(CFG_LIBROOT)/portaudio/src/hostapi/wasapi
# include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmme
LOC_CXX_wmme := c
LOC_SRC_wmme := $(CFG_LIBROOT)/portaudio/src/hostapi/wmme
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



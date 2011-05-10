
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := portaudio
PRJ_DEPS := portaudio
PRJ_TYPE := lib
PRJ_INCS := portaudio/include portaudio/src/common
PRJ_LIBS := 
PRJ_DEFS := TIME_KILL_SYNCHRONOUS=0x0100

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) PA_NO_ASIO PA_NO_WASAPI
	PRJ_INCS := $(PRJ_INCS) portaudio/src/os/win
ifneq ($(BUILD),vs)
	PRJ_DEFS := $(PRJ_DEFS) PA_NO_DS
endif

else
	PRJ_DEFS := $(PRJ_DEFS) PA_USE_ALSA
	PRJ_INCS := $(PRJ_INCS) portaudio/src/os/unix
endif


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
LOC_EXC_win := pa_win_wdmks_utils
ifneq ($(BUILD),vs)
	LOC_EXC_win := $(LOC_EXC_win) pa_x86_plain_converters
endif

include $(PRJ_LIBROOT)/build.mk

# export LOC_TAG := asio
# LOC_SRC_asio := $(CFG_LIBROOT)/portaudio/src/hostapi/asio
# include $(PRJ_LIBROOT)/build.mk

ifeq ($(BUILD),vs)

export LOC_TAG := dsound
LOC_CXX_dsound := c
LOC_SRC_dsound := $(CFG_LIBROOT)/portaudio/src/hostapi/dsound
include $(PRJ_LIBROOT)/build.mk

endif

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

export LOC_TAG := alsa
LOC_CXX_alsa := c
LOC_SRC_alsa := $(CFG_LIBROOT)/portaudio/src/hostapi/alsa
include $(PRJ_LIBROOT)/build.mk

# export LOC_TAG := jack
# LOC_CXX_jack := c
# LOC_SRC_jack := $(CFG_LIBROOT)/portaudio/src/hostapi/jack
# include $(PRJ_LIBROOT)/build.mk

# export LOC_TAG := oss
# LOC_CXX_oss := c
# LOC_SRC_oss := $(CFG_LIBROOT)/portaudio/src/hostapi/oss
# include $(PRJ_LIBROOT)/build.mk

endif


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk



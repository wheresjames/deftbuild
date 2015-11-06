
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := webrtc-talk
PRJ_DEPS := webrtc
PRJ_TYPE := lib
PRJ_INCS := jsoncpp/include webrtc libyuv/include vpx \
			libsrtp/include libsrtp/crypto/include
PRJ_DEFS := NOMINMAX \
			LIBPEERCONNECTION_LIB \
			HAVE_SRTP SRTP_RELATIVE_PATH HAVE_X86 \
			SSL_USE_OPENSSL HAVE_OPENSSL_SSL_H FEATURE_ENABLE_SSL \
			HAVE_WEBRTC_VOICE HAVE_WEBRTC_VIDEO
PRJ_LIBS := 
PRJ_FWRK := mfc

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

# ifeq ($(PLATFORM)-$(BUILD),windows-gcc)
# UNSUPPORTED := BUILD=$(BUILD) is invalid, webrtc can only be built on windows with Visual Studio
# include $(PRJ_LIBROOT)/unsupported.mk
# else

# PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/nullconfig $(PRJ_INCS)
PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/srtp/inc/$(PLATFORM)/$(PROC) $(PRJ_INCS)

PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/$(PLATFORM)/$(BUILD)/$(PROC) $(PRJ_INCS)

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_DEFS := _WINSOCKAPI_ WEBRTC_WIN COMPILER_MSVC
	else
		PRJ_DEFS := _WINSOCKAPI_ WEBRTC_WIN AI_ADDRCONFIG=0
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=c++0x
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=gnu++0x
		CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11 -fpermissive
		CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2
	endif
else
	PRJ_DEFS := WEBRTC_POSIX WEBRTC_LINUX UINT16_MAX=65535
	CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11
	CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := talk_webrtc
LOC_CXX_talk_webrtc := cc
LOC_BLD_talk_webrtc := cpp
LOC_WEX_talk_webrtc := *_unittest*
LOC_EXC_talk_webrtc := statscollector
ifeq ($(PLATFORM),windows)
endif
LOC_SRC_talk_webrtc := $(CFG_LIBROOT)/webrtc/talk/app/webrtc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := tmd
LOC_CXX_tmd := cc
LOC_BLD_tmd := cpp
ifeq ($(PLATFORM),windows)
	LOC_WEX_tmd := *_unittest* libudev* mac* linux* v4l* carbon* gtk*
	ifeq ($(BUILD),gcc)
		LOC_WEX_tmd := $(LOC_WEX_tmd) win32devicemanager
	endif
else
	LOC_WEX_tmd := *_unittest* libudev* mac* win32* carbon* gtk* linux* v4l*
endif
LOC_EXC_tmd := 
LOC_SRC_tmd := $(CFG_LIBROOT)/webrtc/talk/media/devices
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := tsm
LOC_CXX_tsm := cc
LOC_BLD_tsm := cpp
LOC_WEX_tsm := *_unittest*
LOC_EXC_tsm :=
LOC_SRC_tsm := $(CFG_LIBROOT)/webrtc/talk/session/media
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := tmb
LOC_CXX_tmb := cc
LOC_BLD_tmb := cpp
LOC_WEX_tmb := *_unittest* test*
LOC_EXC_tmb := 
LOC_SRC_tmb := $(CFG_LIBROOT)/webrtc/talk/media/base
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := tmw
LOC_CXX_tmw := cc
LOC_BLD_tmw := cpp
LOC_WEX_tmw := *_unittest*
LOC_EXC_tmw := dummyinstantiation
LOC_SRC_tmw := $(CFG_LIBROOT)/webrtc/talk/media/webrtc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := tmd
LOC_CXX_tmd := cc
LOC_BLD_tmd := cpp
LOC_WEX_tmd := *_unittest* mac* linux* lib* gtk* win32* carbon* v4l*
LOC_EXC_tmd := 
LOC_SRC_tmd := $(CFG_LIBROOT)/webrtc/talk/media/devices
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := taw
LOC_CXX_taw := cc
LOC_BLD_taw := cpp
LOC_WEX_taw := *_unittest*
LOC_EXC_taw := 
LOC_SRC_taw := $(CFG_LIBROOT)/webrtc/talk/app/webrtc
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

# endif

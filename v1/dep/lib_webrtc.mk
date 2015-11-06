
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := webrtc
PRJ_DEPS := webrtc
PRJ_TYPE := lib
PRJ_INCS := jsoncpp/include webrtc libyuv/include vpx \
			libsrtp/include libsrtp/crypto/include openssl/include
PRJ_DEFS := NOMINMAX \
			LIBPEERCONNECTION_LIB \
			HAVE_SRTP SRTP_RELATIVE_PATH HAVE_X86 \
			HAVE_WEBRTC_VOICE HAVE_WEBRTC_VIDEO \
			SSL_USE_OPENSSL HAVE_OPENSSL_SSL_H FEATURE_ENABLE_SSL \
			WEBRTC_NS_FIXED
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

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_DEFS := _WINSOCKAPI_
		PRJ_DEFS := $(PRJ_DEFS) WEBRTC_WIN COMPILER_MSVC
	else
		PRJ_DEFS := _WINSOCKAPI_
		PRJ_DEFS := $(PRJ_DEFS) WEBRTC_WIN AI_ADDRCONFIG=0
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=c++0x
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=gnu++0x
		CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11 -fpermissive
		CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2
	endif
else
	PRJ_DEFS := WEBRTC_POSIX WEBRTC_LINUX
	CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11
	CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := wb
LOC_CXX_wb := cc
LOC_BLD_wb := cpp
LOC_WEX_wb := *_unittest* *_main*
LOC_EXC_wb := testclient latebindingsymboltable winfirewall
ifeq ($(PLATFORM),windows)
	LOC_EXC_wb := $(LOC_EXC_wb) unixfilesystem posix x11windowpicker
	LOC_WEX_wb := $(LOC_WEX_wb) mac*
else
	LOC_EXC_wb := $(LOC_EXC_wb) unixfilesystem x11windowpicker schanneladapter winping
	LOC_WEX_wb := $(LOC_WEX_wb) mac* *win32* *win*
endif
LOC_SRC_wb := $(CFG_LIBROOT)/webrtc/webrtc/base
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := sys
LOC_CXX_sys := cc
LOC_BLD_sys := cpp
ifeq ($(PLATFORM),windows)
	LOC_WEX_sys := *_unittest* *_posix* *_android* *_mac* logcat_*
else
	LOC_WEX_sys := *_unittest* *_android* *_mac* logcat_* *_win*
endif
LOC_EXC_sys := 
LOC_SRC_sys := $(CFG_LIBROOT)/webrtc/webrtc/system_wrappers/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wrtc
LOC_CXX_wrtc := cc
LOC_BLD_wrtc := cpp
LOC_WEX_wrtc := *_unittest*
LOC_EXC_wrtc := 
LOC_SRC_wrtc := $(CFG_LIBROOT)/webrtc/webrtc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := p2p
LOC_CXX_p2p := cc
LOC_BLD_p2p := cpp
LOC_WEX_p2p := *_unittest*
LOC_EXC_p2p := 
LOC_SRC_p2p := $(CFG_LIBROOT)/webrtc/webrtc/p2p/base
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wpc
LOC_CXX_wpc := cc
LOC_BLD_wpc := cpp
LOC_WEX_wpc := *_unittest*
LOC_EXC_wpc := 
LOC_SRC_wpc := $(CFG_LIBROOT)/webrtc/webrtc/p2p/client
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := voixeng
LOC_CXX_voixeng := cc
LOC_BLD_voixeng := cpp
LOC_WEX_voixeng := *_unittest*
LOC_EXC_voixeng := 
LOC_SRC_voixeng := $(CFG_LIBROOT)/webrtc/webrtc/voice_engine
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wca
LOC_CXX_wca := cc
LOC_BLD_wca := cpp
LOC_WEX_wca := *_unittest* *_neon*
LOC_EXC_wca := real_fourier
LOC_SRC_wca := $(CFG_LIBROOT)/webrtc/webrtc/common_audio
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wca
LOC_CXX_wca := c
#LOC_BLD_wca := cpp
LOC_WEX_wca := *_unittest*
LOC_EXC_wca :=
LOC_SRC_wca := $(CFG_LIBROOT)/webrtc/webrtc/common_audio
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wcavad
LOC_CXX_wcavad := cc
LOC_BLD_wcavad := cpp
LOC_WEX_wcavad := *_unittest* *_neon*
LOC_EXC_wcavad := real_fourier
LOC_SRC_wcavad := $(CFG_LIBROOT)/webrtc/webrtc/common_audio/vad
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wcavadc
LOC_CXX_wcavadc := c
#LOC_BLD_wcavadc := cpp
LOC_WEX_wcavadc := *_unittest* *_neon*
LOC_EXC_wcavadc := 
LOC_SRC_wcavadc := $(CFG_LIBROOT)/webrtc/webrtc/common_audio/vad
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wcavare
LOC_CXX_wcavare := cc
LOC_BLD_wcavare := cpp
LOC_WEX_wcavare := *_unittest* *_neon*
LOC_EXC_wcavare := 
LOC_SRC_wcavare := $(CFG_LIBROOT)/webrtc/webrtc/common_audio/resampler
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wcsp
LOC_CXX_wcsp := c
#LOC_BLD_wcsp := cpp
LOC_WEX_wcsp := *_unittest* *_neon* *_mips*
LOC_EXC_wcsp := 
LOC_SRC_wcsp := $(CFG_LIBROOT)/webrtc/webrtc/common_audio/signal_processing
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := videng
LOC_CXX_videng := cc
LOC_BLD_videng := cpp
LOC_WEX_videng := *_unittest*
LOC_EXC_videng := 
LOC_SRC_videng := $(CFG_LIBROOT)/webrtc/webrtc/video_engine
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wcv
LOC_CXX_wcv := cc
LOC_BLD_wcv := cpp
LOC_WEX_wcv := *_unittest*
LOC_EXC_wcv :=
LOC_SRC_wcv := $(CFG_LIBROOT)/webrtc/webrtc/common_video
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wcyuv
LOC_CXX_wcyuv := cc
LOC_BLD_wcyuv := cpp
LOC_WEX_wcyuv := *_unittest*
LOC_EXC_wcyuv :=
LOC_SRC_wcyuv := $(CFG_LIBROOT)/webrtc/webrtc/common_video/libyuv
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

# endif

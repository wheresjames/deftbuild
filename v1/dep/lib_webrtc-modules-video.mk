
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := webrtc-modules-video
PRJ_DEPS := webrtc
PRJ_TYPE := lib
PRJ_INCS := jsoncpp/include webrtc libyuv/include vpx \
			libsrtp/include libsrtp/crypto/include
PRJ_DEFS := NOMINMAX _WINSOCKAPI_ \
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

ifeq ($(PLATFORM)-$(BUILD),windows-gcc)
UNSUPPORTED := BUILD=$(BUILD) is invalid, webrtc can only be built on windows with Visual Studio
include $(PRJ_LIBROOT)/unsupported.mk
else

# PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/nullconfig $(PRJ_INCS)
PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/srtp/inc/$(PLATFORM)/$(PROC) $(PRJ_INCS)

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/windows/vs $(PRJ_INCS)
	else 
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/windows/gcc $(PRJ_INCS)
	endif
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/posix $(PRJ_INCS)
endif

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_DEFS := WEBRTC_WIN COMPILER_MSVC
	else
		PRJ_DEFS := WEBRTC_WIN AI_ADDRCONFIG=0
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=c++0x
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=gnu++0x
		CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11 -fpermissive
	endif
else
	PRJ_DEFS := 
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := wmu
LOC_CXX_wmu := cc
LOC_BLD_wmu := cpp
LOC_WEX_wmu := *_unittest *_android
LOC_EXC_wmu := 
LOC_SRC_wmu := $(CFG_LIBROOT)/webrtc/webrtc/modules/utility
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmus
LOC_CXX_wmus := cc
LOC_BLD_wmus := cpp
LOC_WEX_wmus := *_unittest *_android
LOC_EXC_wmus := 
LOC_SRC_wmus := $(CFG_LIBROOT)/webrtc/webrtc/modules/utility/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmmf
LOC_CXX_wmmf := cc
LOC_BLD_wmmf := cpp
LOC_WEX_wmmf := *_unittest
LOC_EXC_wmmf := 
LOC_SRC_wmmf := $(CFG_LIBROOT)/webrtc/webrtc/modules/media_file/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmrbe
LOC_CXX_wmrbe := cc
LOC_BLD_wmrbe := cpp
LOC_WEX_wmrbe := *_unittest
LOC_EXC_wmrbe := 
LOC_SRC_wmrbe := $(CFG_LIBROOT)/webrtc/webrtc/modules/remove_bitrate_estimator
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvm
LOC_CXX_wmvm := cc
LOC_BLD_wmvm := cpp
LOC_WEX_wmvm := *_unittest
LOC_EXC_wmvm := 
LOC_SRC_wmvm := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_processing/main/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8
LOC_CXX_vp8 := cc
LOC_BLD_vp8 := cpp
LOC_WEX_vp8 := *_unittest
LOC_EXC_vp8 := vp8_sequence_coder
LOC_SRC_vp8 := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_coding/codecs/vp8
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9
LOC_CXX_vp9 := cc
LOC_BLD_vp9 := cpp
LOC_WEX_vp9 := *_unittest
LOC_EXC_vp9 := 
LOC_SRC_vp9 := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_coding/codecs/vp9
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := i428
LOC_CXX_i428 := cc
LOC_BLD_i428 := cpp
LOC_WEX_i428 := *_unittest
LOC_EXC_i428 := 
LOC_SRC_i428 := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_coding/codecs/i420/main/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvm
LOC_CXX_wmvm := cc
LOC_BLD_wmvm := cpp
LOC_WEX_wmvm := *_unittest *_tests
LOC_EXC_wmvm := 
LOC_SRC_wmvm := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_coding/main/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvu
LOC_CXX_wmvu := cc
LOC_BLD_wmvu := cpp
LOC_WEX_wmvu := *_unittest
LOC_EXC_wmvu := 
LOC_SRC_wmvu := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_coding/utility
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvc
LOC_CXX_wmvc := cc
LOC_BLD_wmvc := cpp
LOC_WEX_wmvc := *_unittest
LOC_EXC_wmvc := 
LOC_SRC_wmvc := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_capture
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvce
LOC_CXX_wmvce := cc
LOC_BLD_wmvce := cpp
LOC_WEX_wmvce := *_unittest
LOC_EXC_wmvce := 
LOC_SRC_wmvce := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_capture/external
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvr
LOC_CXX_wmvr := cc
LOC_BLD_wmvr := cpp
LOC_WEX_wmvr := *_unittest
LOC_EXC_wmvr := 
LOC_SRC_wmvr := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_render
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvre
LOC_CXX_wmvre := cc
LOC_BLD_wmvre := cpp
LOC_WEX_wmvre := *_unittest
LOC_EXC_wmvre := 
LOC_SRC_wmvre := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_render/external
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmvrw
LOC_CXX_wmvrw := cc
LOC_BLD_wmvrw := cpp
LOC_WEX_wmvrw := *_unittest
LOC_EXC_wmvrw := 
LOC_SRC_wmvrw := $(CFG_LIBROOT)/webrtc/webrtc/modules/video_render/windows
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmrtp
LOC_CXX_wmrtp := cc
LOC_BLD_wmrtp := cpp
LOC_WEX_wmrtp := *_unittest *_helper
LOC_EXC_wmrtp := 
LOC_SRC_wmrtp := $(CFG_LIBROOT)/webrtc/webrtc/modules/rtp_rtcp/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmbc
LOC_CXX_wmbc := cc
LOC_BLD_wmbc := cpp
LOC_WEX_wmbc := *_unittest
LOC_EXC_wmbc := 
LOC_SRC_wmbc := $(CFG_LIBROOT)/webrtc/webrtc/modules/bitrate_controller
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmrbe
LOC_CXX_wmrbe := cc
LOC_BLD_wmrbe := cpp
LOC_WEX_wmrbe := *_unittest *_test
LOC_EXC_wmrbe := bwe_simulations
LOC_EXI_wmrbe := $(CFG_LIBROOT)/webrtc/webrtc/modules/remote_bitrate_estimator/include
LOC_SRC_wmrbe := $(CFG_LIBROOT)/webrtc/webrtc/modules/remote_bitrate_estimator
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmp
LOC_CXX_wmp := cc
LOC_BLD_wmp := cpp
LOC_WEX_wmp := *_unittest
LOC_EXC_wmp := 
LOC_SRC_wmp := $(CFG_LIBROOT)/webrtc/webrtc/modules/pacing
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif


default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := webrtc-modules-audio
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

export LOC_TAG := wma
LOC_CXX_wma := cc
LOC_BLD_wma := cpp
LOC_WEX_wma := *_unittest *_helper
LOC_EXC_wma := 
LOC_SRC_wma := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmad
LOC_CXX_wmad := cc
LOC_BLD_wmad := cpp
LOC_WEX_wmad := *_unittest
LOC_EXC_wmad := 
LOC_SRC_wmad := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_device
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmadd
LOC_CXX_wmadd := cc
LOC_BLD_wmadd := cpp
LOC_WEX_wmadd := *_unittest
LOC_EXC_wmadd := 
LOC_SRC_wmadd := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_device/dummy
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmadw
LOC_CXX_wmadw := cc
LOC_BLD_wmadw := cpp
LOC_WEX_wmadw := *_unittest
LOC_EXC_wmadw := 
LOC_SRC_wmadw := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_device/win
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapaec
LOC_CXX_wmapaec := c
#LOC_BLD_wmapaec := cpp
LOC_WEX_wmapaec := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapaec := 
LOC_SRC_wmapaec := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/utility
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapaec
LOC_CXX_wmapaec := c
#LOC_BLD_wmapaec := cpp
LOC_WEX_wmapaec := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapaec := 
LOC_SRC_wmapaec := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/aec
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapans
LOC_CXX_wmapans := c
#LOC_BLD_wmapans := cpp
LOC_WEX_wmapans := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapans := 
LOC_SRC_wmapans := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/ns
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapaecm
LOC_CXX_wmapaecm := c
#LOC_BLD_wmapaecm := cpp
LOC_WEX_wmapaecm := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapaecm := 
LOC_SRC_wmapaecm := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/aecm
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapagcc
LOC_CXX_wmapagcc := c
#LOC_BLD_wmapagcc := cpp
LOC_WEX_wmapagcc := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapagcc := 
LOC_SRC_wmapagcc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/agc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapagc
LOC_CXX_wmapagc := cc
LOC_BLD_wmapagc := cpp
LOC_WEX_wmapagc := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapagc := 
LOC_SRC_wmapagc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/agc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmamneteq
LOC_CXX_wmamneteq := cc
LOC_BLD_wmamneteq := cpp
LOC_WEX_wmamneteq := *_unittest
LOC_EXC_wmamneteq := 
LOC_EXI_wmamneteq := $(CFG_LIBROOT)/libopus/include $(CFG_LIBROOT)/libopus/celt $(CFG_LIBROOT)/libopus/src
LOC_SRC_wmamneteq := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/neteq
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapagcl
LOC_CXX_wmapagcl := c
#LOC_BLD_wmapagcl := cpp
LOC_WEX_wmapagcl := *_unittest *_helper *_mips *_neon
LOC_EXC_wmapagcl := 
LOC_SRC_wmapagcl := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/agc/legacy
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmapt
LOC_CXX_wmapt := cc
LOC_BLD_wmapt := cpp
LOC_WEX_wmapt := *_unittest *_test
LOC_EXC_wmapt := 
LOC_SRC_wmapt := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_processing/transient
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmamacm2
LOC_CXX_wmamacm2 := c
#LOC_BLD_wmamacm2 := cpp
LOC_WEX_wmamacm2 := *_unittest
LOC_EXC_wmamacm2 := 
LOC_SRC_wmamacm2 := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/main/acm2
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmamacm2cc
LOC_CXX_wmamacm2cc := cc
LOC_BLD_wmamacm2cc := cpp
LOC_WEX_wmamacm2cc := *_unittest *_test
LOC_EXC_wmamacm2cc := 
LOC_SRC_wmamacm2cc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/main/acm2
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacad
LOC_CXX_wmacad := cc
LOC_BLD_wmacad := cpp
LOC_WEX_wmacad := *_unittest *_test
LOC_EXC_wmacad := 
LOC_SRC_wmacad := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmaccng
LOC_CXX_wmaccng := cc
LOC_BLD_wmaccng := cpp
LOC_WEX_wmaccng := *_unittest *_test
LOC_EXC_wmaccng := 
LOC_SRC_wmaccng := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/cng
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmaccngc
LOC_CXX_wmaccngc := c
#LOC_BLD_wmaccngc := cpp
LOC_EXI_wmaccngc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/cng/include \
					$(CFG_LIBROOT)/webrtc/webrtc/common_audio/signal_processing/include
LOC_WEX_wmaccngc := *_unittest *_test
LOC_EXC_wmaccngc := 
LOC_SRC_wmaccngc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/cng
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacred
LOC_CXX_wmacred := cc
LOC_BLD_wmacred := cpp
LOC_WEX_wmacred := *_unittest *_test
LOC_EXC_wmacred := 
LOC_SRC_wmacred := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/red
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmag711
LOC_CXX_wmag711 := cc
LOC_BLD_wmag711 := cpp
LOC_WEX_wmag711 := *_unittest *_test
LOC_EXC_wmag711 := 
LOC_SRC_wmag711 := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/g711
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmag711c
LOC_CXX_wmag711c := c
#LOC_BLD_wmag711c := cpp
LOC_WEX_wmag711c := *_unittest *_test
LOC_EXC_wmag711c := 
LOC_EXI_wmag711c := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/g711/include
LOC_SRC_wmag711c := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/g711
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmag722
LOC_CXX_wmag722 := cc
LOC_BLD_wmag722 := cpp
LOC_WEX_wmag722 := *_unittest *_test
LOC_EXC_wmag722 := 
LOC_SRC_wmag722 := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/g722
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmag722c
LOC_CXX_wmag722c := c
#LOC_BLD_wmag722c := cpp
LOC_WEX_wmag722c := *_unittest *_test
LOC_EXC_wmag722c := 
LOC_EXI_wmag722c := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/g722/include
LOC_SRC_wmag722c := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/g722
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacpcm16
LOC_CXX_wmacpcm16 := cc
LOC_BLD_wmacpcm16 := cpp
LOC_WEX_wmacpcm16 := *_unittest *_test
LOC_EXC_wmacpcm16 := 
LOC_SRC_wmacpcm16 := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/pcm16b
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacpcm16c
LOC_CXX_wmacpcm16c := c
#LOC_BLD_wmacpcm16c := cpp
LOC_WEX_wmacpcm16c := *_unittest *_test
LOC_EXC_wmacpcm16c := 
LOC_EXI_wmacpcm16c := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/pcm16b/include
LOC_SRC_wmacpcm16c := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/pcm16b
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacilbc
LOC_CXX_wmacilbc := cc
LOC_BLD_wmacilbc := cpp
LOC_WEX_wmacilbc := *_unittest *_test
LOC_EXC_wmacilbc := 
LOC_SRC_wmacilbc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/ilbc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacilbcc
LOC_CXX_wmacilbcc := c
#LOC_BLD_wmacilbcc := cpp
LOC_WEX_wmacilbcc := *_unittest *_test
LOC_EXC_wmacilbcc := 
LOC_EXI_wmacilbcc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/ilbc/interface \
					 $(CFG_LIBROOT)/webrtc/webrtc/common_audio/signal_processing/include
LOC_SRC_wmacilbcc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/ilbc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmaisacc
LOC_CXX_wmaisacc := c
#LOC_BLD_wmaisacc := cpp
LOC_WEX_wmaisacc := *_unittest *_test
LOC_EXC_wmaisacc := 
LOC_EXI_wmaisacc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/isac/main/interface \
				    $(CFG_LIBROOT)/webrtc/webrtc/common_audio/signal_processing/include
LOC_SRC_wmaisacc := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/isac/main/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmaisac
LOC_CXX_wmaisac := cc
LOC_BLD_wmaisac := cpp
LOC_WEX_wmaisac := *_unittest *_test
LOC_EXC_wmaisac := 
LOC_SRC_wmaisac := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_coding/codecs/isac/main/source
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := wmacm
LOC_CXX_wmacm := cc
LOC_BLD_wmacm := cpp
LOC_WEX_wmacm := *_unittest *_test
LOC_EXC_wmacm := 
LOC_SRC_wmacm := $(CFG_LIBROOT)/webrtc/webrtc/modules/audio_conference_mixer/source
include $(PRJ_LIBROOT)/build.mk


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

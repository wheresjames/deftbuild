
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := peercon-client
PRJ_DEPS := peercon
PRJ_TYPE := exe
PRJ_INCS := webrtc jsoncpp/include
PRJ_LIBS := webrtc-talk webrtc-modules-video webrtc-modules-audio webrtc yuv srtp \
			openssl_a openssl_b openssl_c openssl_a openssl_b openssl_c vpx jsoncpp
PRJ_DEFS := NOMINMAX _WINSOCKAPI_ WEBRTC_WIN \
			LIBPEERCONNECTION_LIB \
			HAVE_SRTP SRTP_RELATIVE_PATH HAVE_X86 \
			HAVE_WEBRTC_VOICE HAVE_WEBRTC_VIDEO \
			SSL_USE_OPENSSL HAVE_OPENSSL_SSL_H FEATURE_ENABLE_SSL \
			WEBRTC_NS_FIXED
PRJ_WINL := winmm strmiids secur32 dmoguids wmcodecdspuuid msdmo crypt32 \
			uxtheme winspool windowscodecs
PRJ_FWRK := mfc

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PLATFORM),_dont_build_)
UNSUPPORTED := PLATFORM=$(PLATFORM) is invalid, $(PRJ_NAME) can only be built on Windows
include $(PRJ_LIBROOT)/unsupported.mk
else

CFG_LFLAGS := $(CFG_LFLAGS) /SUBSYSTEM:WINDOWS

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := def
LOC_CXX_def := cc
LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/peercon/peerconnection/client
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif



default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := ffb
PRJ_DEPS := ffmpeg
PRJ_TYPE := lib
PRJ_INCS := ffmpeg openssl/include x264
PRJ_LIBS := 
PRJ_DEFS := HAVE_AV_CONFIG_H=1 __STDC_CONSTANT_MACROS
PRJ_OPTS := -O2

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PROC),arm)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(BUILD),gcc)
UNSUPPORTED := BUILD=$(BUILD) is invalid, ffmpeg can only be built with 'gcc'
include $(PRJ_LIBROOT)/unsupported.mk
else

include lib_ffmpeg.i

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := avf
LOC_CXX_avf := c
LOC_SRC_avf := $(CFG_LIBROOT)/ffmpeg/libavformat
LOC_EXC_avf := avisynth bluray rtpdec_theora
LOC_WLS_avf := g h i j k l m n o p q r s t u v w x y z
LOC_WEX_avf := lib* tls_*
LOC_EXC_avf := sctp
ifeq ($(PLATFORM),windows)
	LOC_EXC_avf := $(LOC_EXC_avf) unix
endif
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

endif

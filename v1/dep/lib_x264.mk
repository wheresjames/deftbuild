
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := x264
PRJ_DEPS := x264
PRJ_TYPE := lib
PRJ_INCS := x264
PRJ_LIBS := 
PRJ_DEFS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(BUILD),gcc)
UNSUPPORTED := BUILD=$(BUILD) is invalid, ffmpeg can only be built with 'gcc'
include $(PRJ_LIBROOT)/unsupported.mk
else

CFG_CFLAGS := $(CFG_CFLAGS) -ffast-math -fomit-frame-pointer

ifdef DBG
	CFG_CFLAGS := $(CFG_CFLAGS) -fno-stack-check -O1 -std=c99
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

#export LOC_TAG := def
#LOC_CXX_def := c
#LOC_SRC_def := $(CFG_LIBROOT)/x264
#LOC_EXC_def := x264dll
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := common
LOC_CXX_common := c
LOC_SRC_common := $(CFG_LIBROOT)/x264/common
LOC_EXC_common := visualize
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := common_x86
LOC_CXX_common_x86 := c
LOC_SRC_common_x86 := $(CFG_LIBROOT)/x264/common/x86
LOC_EXC_common_x86 := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := common_asm
LOC_CXX_common_asm := asm
LOC_BLD_common_asm := asm
LOC_ASM_common_asm := yasm -f elf32 -a x86
LOC_SRC_common_asm := $(CFG_LIBROOT)/x264/common/x86
LOC_EXC_common_asm := dct-64
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := encoder
LOC_CXX_encoder := c
LOC_BLD_encoder := c
LOC_SRC_encoder := $(CFG_LIBROOT)/x264/encoder
LOC_EXC_encoder := rdo slicetype
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif


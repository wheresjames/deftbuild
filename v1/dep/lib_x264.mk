
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

ifeq ($(PROC),arm)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifneq ($(BUILD),gcc)
    ifeq ($(findstring msvs14,$(TGT)),)
	NOTSUPPORTED := 1
    endif
endif

ifneq ($(NOTSUPPORTED),)
UNSUPPORTED := $(BUILD)-$(TGT) is invalid for ffmpeg
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(BUILD),gcc)
	CFG_CFLAGS := $(CFG_CFLAGS) -ffast-math -fomit-frame-pointer -std=c99
	ifdef DBG
		CFG_CFLAGS := $(CFG_CFLAGS) -fno-stack-check -O1
	endif
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := common
LOC_CXX_common := c
LOC_SRC_common := $(CFG_LIBROOT)/x264/common
LOC_EXC_common := visualize
ifeq ($(PLATFORM),windows)
	LOC_EXC_common := $(LOC_EXC_common) display-x11
else
	LOC_EXC_common := $(LOC_EXC_common) win32thread
endif
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := common_x86
LOC_CXX_common_x86 := c
LOC_SRC_common_x86 := $(CFG_LIBROOT)/x264/common/x86
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := common_asm
LOC_CXX_common_asm := asm
LOC_BLD_common_asm := asm
ifeq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		LOC_ASM_common_asm := yasm -f win64 -DBIT_DEPTH=8 -DARCH_X86=1 -DARCH_X86_64=1 -DWIN32 -DWIN64 -DHIGH_BIT_DEPTH=0
	else
		LOC_ASM_common_asm := yasm -f win32 -a x86 -DPREFIX -DBIT_DEPTH=8 -DARCH_X86=0 -DARCH_X86_64=0 -DWIN32 -DHIGH_BIT_DEPTH=0
	endif
else
	ifeq ($(PROC),x64)
		LOC_ASM_common_asm := yasm -f elf64 -DPIC -DBIT_DEPTH=8 -DARCH_X86=1 -DARCH_X86_64=1 -DHIGH_BIT_DEPTH=0
	else
		LOC_ASM_common_asm := yasm -f elf32 -a x86 -DPIC -DBIT_DEPTH=8 -DARCH_X86=0 -DARCH_X86_64=0 -DHIGH_BIT_DEPTH=0
	endif
endif
ifeq ($(PROC),x64)
	LOC_EXC_common_asm := dct-32 pixel-32 trellis-32
else
	LOC_EXC_common_asm := dct-64 pixel-64 trellis-64
endif
ifdef NOVPPERM
	LOC_EXC_common_asm := $(LOC_EXC_common_asm) dct-a mc-a2 pixel-a quant-a
endif
LOC_EXC_common_asm := $(LOC_EXC_common_asm) sad16-a
LOC_SRC_common_asm := $(CFG_LIBROOT)/x264/common/x86
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

endif

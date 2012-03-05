
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := vpx
PRJ_DEPS := vpx
PRJ_TYPE := lib
PRJ_INCS := vpx vpx/vpx_scale/include/generic
PRJ_LIBS := 
PRJ_DEFS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/windows/vs $(PRJ_INCS)
	else 
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/windows/gcc $(PRJ_INCS)
	endif
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/posix $(PRJ_INCS) zlib
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := vpx
LOC_CXX_vpx := c
LOC_SRC_vpx := $(CFG_LIBROOT)/vpx/vpx/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vpx_mem
LOC_CXX_vpx_mem := c
LOC_SRC_vpx_mem := $(CFG_LIBROOT)/vpx/vpx_mem
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8
LOC_CXX_vp8 := c
LOC_SRC_vp8 := $(CFG_LIBROOT)/vpx/vp8
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn
LOC_CXX_cmn := c
LOC_SRC_cmn := $(CFG_LIBROOT)/vpx/vp8/common
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn_gen
LOC_CXX_cmn_gen := c
LOC_SRC_cmn_gen := $(CFG_LIBROOT)/vpx/vp8/common/generic
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := enc
LOC_EXC_enc := mr_dissim ssim
LOC_CXX_enc := c
LOC_SRC_enc := $(CFG_LIBROOT)/vpx/vp8/encoder
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := enc_gen
LOC_CXX_enc_gen := c
LOC_SRC_enc_gen := $(CFG_LIBROOT)/vpx/vp8/encoder/generic
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vpxs_gen
LOC_CXX_vpxs_gen := c
# LOC_INC_vpxs_gen := $(CFG_LIBROOT)/vpx/vpx_scale/include/generic
LOC_SRC_vpxs_gen := $(CFG_LIBROOT)/vpx/vpx_scale/generic
include $(PRJ_LIBROOT)/build.mk


ifneq ($(PROC),arm)

# HAVE_AVX = Intel Sandy Bridge vector extension ???

	ifeq ($(PLATFORM),windows)
		ASMOPTS := $(ASMOPTS) -DHAVE_MMX2 
		ifeq ($(BUILD),vs)
			ASMOPTS := $(ASMOPTS) -I$(CFG_LIB2BLD)/dep/etc/vpx/inc/windows/vs
		else 
			ASMOPTS := $(ASMOPTS) -I$(CFG_LIB2BLD)/dep/etc/vpx/inc/windows/gcc
		endif
	else
		ifneq ($(PROC),x64)
			ASMOPTS := $(ASMOPTS) -DHAVE_MMX2 
		endif
		ASMOPTS := $(ASMOPTS) -I$(CFG_LIB2BLD)/dep/etc/vpx/inc/posix
	endif

	ASMOPTS := $(ASMOPTS) -I$(CFG_LIBROOT)/vpx/vp8/encoder/x86	
	ASMOPTS := $(ASMOPTS) -DHAVE_SSE -DHAVE_AVX -DHAVE_AMD3DNOW \
						  -DHAVE_SSSE -DHAVE_SSSE3 -DHAVE_AVX \
						  -DCONFIG_PIC=1

	export LOC_TAG := enc_asm
	LOC_CXX_enc_asm := asm
	LOC_BLD_enc_asm := asm
	ifeq ($(PLATFORM),windows)
		ifeq ($(PROC),x64)
			LOC_ASM_enc_asm := yasm -f win64 -DARCH_X86_64 $(ASMOPTS)
		else
			LOC_ASM_enc_asm := yasm -f win32 -a x86 -DPREFIX -DARCH_X86 -DARCH_X86_32 $(ASMOPTS)
		endif
	else
		ifeq ($(PROC),x64)
			LOC_ASM_enc_asm := yasm -f elf64 -DPIC -DARCH_X86_64 $(ASMOPTS)
		else
			LOC_ASM_enc_asm := yasm -f elf32 -a x86 -DPIC -DARCH_X86 -DARCH_X86_32 $(ASMOPTS)
		endif
	endif
	LOC_EXC_enc_asm := quantize_sse2 quantize_sse3 quantize_sse4 quantize_ssse3 sad_sse2
	ifneq ($(PROC),x64)
		LOC_EXC_enc_asm := $(LOC_EXC_enc_asm) ssim_opt
	endif
	LOC_SRC_enc_asm := $(CFG_LIBROOT)/vpx/vp8/encoder/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := enc_x86
	LOC_CXX_enc_x86 := c
	LOC_EXC_enc_x86 := x86_csystemdependent
	LOC_SRC_enc_x86 := $(CFG_LIBROOT)/vpx/vp8/encoder/x86
	include $(PRJ_LIBROOT)/build.mk

endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

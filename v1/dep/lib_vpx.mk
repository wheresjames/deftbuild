
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := vpx
PRJ_DEPS := vpx
PRJ_TYPE := lib
PRJ_INCS := vpx libyuv/include
PRJ_DEFS := 
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(VSVER)-$(PROC),msvs11-x64)
UNSUPPORTED := $(VSVER)-$(PROC) is invalid, there is a bug Visual Studio 11
include $(PRJ_LIBROOT)/unsupported.mk
else

# PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/nullconfig $(PRJ_INCS)
PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/vpx/inc/$(PLATFORM)/$(BUILD)/$(PROC) $(PRJ_INCS)

# ifeq ($(PLATFORM),windows)
	# ifeq ($(BUILD),vs)
		# PRJ_DEFS := WEBRTC_WIN COMPILER_MSVC
	# else
		# PRJ_DEFS := WEBRTC_WIN AI_ADDRCONFIG=0
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=c++0x 
		# CFG_CEXTRA := $(CFG_CEXTRA) -std=gnu++0x
		# CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11 
		# -fpermissive
	# endif
# else
	# PRJ_DEFS := 
# endif

ifeq ($(BUILD),gcc)
	ifeq ($(PLATFORM),windows)
#		CFG_CFLAGS := $(CFG_CFLAGS)-std=c++0x 
		CFG_CFLAGS := $(CFG_CFLAGS) -Wno-unused-function -Wno-attributes
		ifeq ($(PROC),x86)
#			CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11
			CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1
		else
#			CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11
			CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2
		endif
	else
	    ifneq ($(PROC),arm)
		CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11 
		CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2
		endif
	endif
else
#	CFG_CFLAGS := $(CFG_CFLAGS) -std=c++11 
#	CFG_CFLAGS := $(CFG_CFLAGS) /Zm2000
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := cfg
LOC_CXX_cfg := c
LOC_SRC_cfg := $(CFG_LIBROOT)/vpx
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vpx
LOC_CXX_vpx := c
LOC_SRC_vpx := $(CFG_LIBROOT)/vpx/vpx/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vpx_mem
LOC_CXX_vpx_mem := c
LOC_SRC_vpx_mem := $(CFG_LIBROOT)/vpx/vpx_mem
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vpx_scale_gen
LOC_CXX_vpx_scale_gen := c
LOC_SRC_vpx_scale_gen := $(CFG_LIBROOT)/vpx/vpx_scale/generic
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8
LOC_CXX_vp8 := c
LOC_SRC_vp8 := $(CFG_LIBROOT)/vpx/vp8
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8com
LOC_CXX_vp8com := c
ifeq ($(PROC),arm)
    LOC_EXC_vp8com := rtcd
endif
LOC_SRC_vp8com := $(CFG_LIBROOT)/vpx/vp8/common
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8comgen
LOC_CXX_vp8comgen := c
LOC_SRC_vp8comgen := $(CFG_LIBROOT)/vpx/vp8/common/generic
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8enc
LOC_CXX_vp8enc := c
LOC_SRC_vp8enc := $(CFG_LIBROOT)/vpx/vp8/encoder
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8dec
LOC_CXX_vp8dec := c
LOC_SRC_vp8dec := $(CFG_LIBROOT)/vpx/vp8/decoder
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9
LOC_CXX_vp9 := c
LOC_SRC_vp9 := $(CFG_LIBROOT)/vpx/vp9
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9com
LOC_CXX_vp9com := c
LOC_EXC_vp9com := vp9_mfqe
ifeq ($(PROC),arm)
    LOC_EXC_vp9com := $(LOC_EXC_vp9com) vp9_rtcd
endif
LOC_SRC_vp9com := $(CFG_LIBROOT)/vpx/vp9/common
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9enc
LOC_CXX_vp9enc := c
LOC_EXC_vp9enc := vp9_denoiser
LOC_SRC_vp9enc := $(CFG_LIBROOT)/vpx/vp9/encoder
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9dec
LOC_CXX_vp9dec := c
LOC_SRC_vp9dec := $(CFG_LIBROOT)/vpx/vp9/decoder
include $(PRJ_LIBROOT)/build.mk

ifneq ($(PROC),arm)
	
	export LOC_TAG := vpx_scale
	LOC_CXX_vpx_scale := c
	LOC_SRC_vpx_scale := $(CFG_LIBROOT)/vpx/vpx_scale
	include $(PRJ_LIBROOT)/build.mk
	
	export LOC_TAG := vp8comx86
	LOC_CXX_vp8comx86 := c
	LOC_SRC_vp8comx86 := $(CFG_LIBROOT)/vpx/vp8/common/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := vp8encx86
	LOC_CXX_vp8encx86 := c
	ifeq ($(PROC)-$(BUILD),x86-vs)
	#	LOC_EXC_vp8encx86 := denoising_sse2 quantize_ssse3 quantize_sse4
	endif
	LOC_SRC_vp8encx86 := $(CFG_LIBROOT)/vpx/vp8/encoder/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := vp9encx86
	LOC_CXX_vp9encx86 := c
	ifeq ($(PROC)-$(BUILD),x86-gcc)
		LOC_WEX_vp9encx86 := *_avx2
	endif
	LOC_SRC_vp9encx86 := $(CFG_LIBROOT)/vpx/vp9/encoder/x86
	include $(PRJ_LIBROOT)/build.mk

	export LOC_TAG := vp9comx86
	LOC_CXX_vp9comx86 := c
	# LOC_WEX_vp9comx86 := *_avx2
	ifeq ($(PROC)-$(BUILD),x86-gcc)
	#	LOC_WEX_vp9comx86 := *_avx2 *_sse2 *_ssse3
		LOC_WEX_vp9comx86 := *_avx2
	endif
	LOC_SRC_vp9comx86 := $(CFG_LIBROOT)/vpx/vp9/common/x86
	include $(PRJ_LIBROOT)/build.mk

endif


# --- ASM ---
ifneq ($(PROC),arm)

# ASMOPTS := -I$(CFG_LIBROOT)/vpx/vp8/common/x86
#		   -DHAVE_SSE -DHAVE_AVX -DHAVE_AMD3DNOW \
#		   -DHAVE_SSSE -DHAVE_SSSE3 -DHAVE_AVX \
#		   -DCONFIG_PIC=1

ifeq ($(PLATFORM),windows)
	ifeq ($(PROC),x64)
		ASMCMD := yasm -f win64 $(ASMOPTS)
	else
		ASMCMD := yasm -f win32 -a x86 -DPREFIX $(ASMOPTS)
	endif
else
	ifeq ($(PROC),x64)
		ASMCMD := yasm -f elf64 -DPIC $(ASMOPTS)
	else
		ASMCMD := yasm -f elf32 -a x86 -DPIC $(ASMOPTS)
	endif
endif

export LOC_TAG := vpx_ports
LOC_CXX_vpx_ports := asm
LOC_BLD_vpx_ports := asm
LOC_ASM_vpx_ports := $(ASMCMD)
LOC_EXC_vpx_ports := ssim_opt_x86_64
LOC_SRC_vpx_ports := $(CFG_LIBROOT)/vpx/vpx_ports
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8_x86_asm
LOC_CXX_vp8_x86_asm := asm
LOC_BLD_vp8_x86_asm := asm
LOC_ASM_vp8_x86_asm := $(ASMCMD)
ifeq ($(PROC),x86)
	LOC_EXC_vp8_x86_asm := loopfilter_block_sse2_x86_64
endif
LOC_SRC_vp8_x86_asm := $(CFG_LIBROOT)/vpx/vp8/common/x86
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp8_encx86_asm
LOC_CXX_vp8_encx86_asm := asm
LOC_BLD_vp8_encx86_asm := asm
LOC_ASM_vp8_encx86_asm := $(ASMCMD)
LOC_EXC_vp8_encx86_asm := ssim_opt_x86_64
LOC_SRC_vp8_encx86_asm := $(CFG_LIBROOT)/vpx/vp8/encoder/x86
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9_x86_asm
LOC_CXX_vp9_x86_asm := asm
LOC_BLD_vp9_x86_asm := asm
LOC_ASM_vp9_x86_asm := $(ASMCMD)
#ifeq ($(PROC)-$(PLATFORM),x64-windows)
#	LOC_WEX_vp9_x86_asm := $(LOC_WEX_vp9_x86_asm)*_sse2 *_ssse3
#	LOC_EXC_vp9_x86_asm := $(LOC_EXC_vp9_x86_asm) \
#						   vp9_copy_sse2 vp9_intrapred_sse2 vp9_intrapred_ssse3 vp9_high_intrapred_sse2
#endif
LOC_SRC_vp9_x86_asm := $(CFG_LIBROOT)/vpx/vp9/common/x86
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := vp9_encx86_asm
LOC_CXX_vp9_encx86_asm := asm
LOC_BLD_vp9_encx86_asm := asm
LOC_ASM_vp9_encx86_asm := $(ASMCMD)
ifneq ($(PROC),x64)
	LOC_EXC_vp9_encx86_asm := $(LOC_EXC_vp9_encx86_asm) vp9_ssim_opt_x86_64 vp9_quantize_ssse3_x86_64
endif
#ifeq ($(PROC)-$(PLATFORM)-$(BUILD),x64-windows-gcc)
#	LOC_WEX_vp9_encx86_asm := *_sse2 *_ssse3 *_mmx
#	LOC_EXC_vp9_encx86_asm := $(LOC_EXC_vp9_encx86_asm) vp9_variance_sse2 \
#							  vp9_subpel_variance vp9_highbd_subpel_variance vp9_quantize_ssse3_x86_64 
#							  vp9_dct_mmx
#endif
LOC_SRC_vp9_encx86_asm := $(CFG_LIBROOT)/vpx/vp9/encoder/x86
include $(PRJ_LIBROOT)/build.mk

# arm
endif

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

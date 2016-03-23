
#-------------------------------------------------------------------
# Common ffmpeg config
#-------------------------------------------------------------------

ifeq ($(BUILD),gcc)

	CFG_CFLAGS := $(CFG_CFLAGS) -mmmx -msse -msse2 -mssse3 -msse4.1 -mavx2

	CFG_CFLAGS := $(CFG_CFLAGS) -Wno-unused-function -Wno-attributes -Wno-unused-local-typedefs \
								-Wno-parentheses -Wno-switch -Wno-pointer-sign \
								-ffast-math -fomit-frame-pointer -std=gnu99

	ifdef DBG
		CFG_CFLAGS := $(CFG_CFLAGS) -fno-stack-check -O2
	endif

endif

ifeq ($(PLATFORM),windows)
	ifeq ($(BUILD),vs)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/vs $(PRJ_INCS)
	else
		ifeq ($(PROC),arm)
			PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/arm $(PRJ_INCS) zlib
		else
			PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/windows/gcc $(PRJ_INCS) zlib
		endif
	endif
	PRJ_DEFS := $(PRJ_DEFS) USEDXVA=1
else
	ifeq ($(PROC),arm)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/posix/arm $(PRJ_INCS) zlib
	else
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/ffmpeg/inc/posix $(PRJ_INCS) zlib
	endif
endif

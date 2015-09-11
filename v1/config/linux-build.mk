
ifneq ($(findstring x64,$(BLD)),)
	CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/posix-gcc-linux-x64-local
else
	CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/posix-gcc-linux-x86-local
endif

ifdef DBG
	CFG_BLD_POST := _d
	CFG_LOCAL_BUILD_TYPE := $(CFG_LOCAL_BUILD_TYPE)-debug
endif

ifeq ($(LIBLINK),static)
	CFG_LOCAL_BUILD_TYPE := $(CFG_LOCAL_BUILD_TYPE)-static
else
	CFG_LOCAL_BUILD_TYPE := $(CFG_LOCAL_BUILD_TYPE)-shared
endif

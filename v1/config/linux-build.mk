
ifneq ($(findstring x64,$(BLD)),)
	CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/posix-gcc-linux-x64-local-shared
else
	CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/posix-gcc-linux-x86-local-shared
endif

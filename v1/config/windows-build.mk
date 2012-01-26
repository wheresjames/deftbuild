
ifneq ($(findstring debug,$(BLD)),)
	CFG_BLD_TYPE := -debug
endif

ifneq ($(findstring shared,$(BLD)),)
	CFG_BLD_TYPE := $(CFG_BLD_TYPE)-shared
else
	CFG_BLD_TYPE := $(CFG_BLD_TYPE)-static
endif


ifneq ($(VSVER),)
	ifneq ($(findstring x64,$(BLD)),)
		CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(VSVER)-win64-x64-local$(CFG_BLD_TYPE)
	else
		CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(VSVER)-win32-x86-local$(CFG_BLD_TYPE)
	endif	
else
	ifneq ($(findstring msvs,$(BLD)),)
		BLDVSVER := $(strip $(foreach t,msvs6 msvs7 msvs8 msvs9 msvs10,$(findstring $(t),$(BLD))))
	endif
	ifneq ($(findstring vsexp,$(BLD)),)
		BLDVSVER := $(strip $(foreach t,vsexp8 vsexp9 vsexp10,$(findstring $(t),$(BLD))))
	endif

	ifneq ($(BLDVSVER),)
		ifneq ($(findstring x64,$(BLD)),)
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(BLDVSVER)-win64-x64-local$(CFG_BLD_TYPE)
		else
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(BLDVSVER)-win32-x86-local$(CFG_BLD_TYPE)
		endif
	else
		ifneq ($(findstring x64,$(BLD)),)
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-gcc-win64-x64-mingw64$(CFG_BLD_TYPE)
		else
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-gcc-win32-x86-mingw32$(CFG_BLD_TYPE)
		endif
	endif
endif

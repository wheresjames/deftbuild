
ifneq ($(VSVER),)
	ifneq ($(findstring x64,$(BLD)),)
		CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(VSVER)-win64-x64-local-static
	else
		CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(VSVER)-win32-x86-local-static
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
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(BLDVSVER)-win64-x64-local-static
		else
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-$(BLDVSVER)-win32-x86-local-static
		endif
	else
		ifneq ($(findstring x64,$(BLD)),)
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-gcc-win64-x64-mingw64-static
		else
			CFG_LOCAL_BUILD_TYPE 	:= $(CFG_OUT)/windows-gcc-win32-x86-mingw32-static
		endif
	endif
endif

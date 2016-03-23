
# Target processor
PROC := $(strip $(foreach t,x86 x64 amd64 ia64 arm powerpc,$(findstring $(t),$(TGT))))
ifeq ($(PROC),)
	PROC := x86
endif

ifneq ($(findstring debug,$(TGT)),)
	DBG := 1
endif

ifeq ($(findstring msvs,$(TGT)),)
	NOMFC := 1
else
	ifneq ($(findstring nomfc,$(TGT)),)
		NOMFC := 1
	else
		ifeq ($(findstring mfc,$(TGT)),)
			ifeq ($(findstring mfc,$(PRJ_FWRK)),)
				NOMFC := 1
			endif
		endif
	endif
endif

ifneq ($(findstring vs,$(TGT)),)
	BUILD := vs
	TOOLS := local
	LIBLINK := static
	WBLD := 1
	ifneq ($(findstring msvs,$(TGT)),)
		VSVER := $(strip $(foreach t,msvs6 msvs7 msvs8 msvs9 msvs10 msvs11 msvs12 msvs13 msvs14,$(findstring $(t),$(TGT))))
	endif		
	ifneq ($(findstring vsexp,$(TGT)),)
		VSVER := $(strip $(foreach t,vsexp8 vsexp9 vsexp10 vsexp11 vsexp12,$(findstring $(t),$(TGT))))
	endif		
else
	BUILD := gcc
	ifneq ($(findstring windows,$(TGT)),)
		LIBLINK := static
		ifeq ($(PROC),x86)
			TOOLS := mingw32
		else
			TOOLS := mingw64
		endif
	else
		TOOLS := local
		LIBLINK := shared
 	endif
endif

ifneq ($(findstring static,$(TGT)),)
	LIBLINK := static
endif
ifneq ($(findstring shared,$(TGT)),)
	LIBLINK := shared
endif

ifneq ($(findstring unicode,$(TGT)),)
	UNICODE := 1
endif

ifneq ($(findstring android,$(TGT)),)
	PROC := arm
	TOOLS := android
endif



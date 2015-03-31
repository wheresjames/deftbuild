
ifeq ($(BLD),)
	BLD := $(TGT)
endif

# Build Processor
BLDPROC := $(strip $(foreach t,x86 x64 amd64 ia64 arm powerpc,$(findstring $(t),$(BLD))))
ifeq ($(BLDPROC),)
	BLDPROC := $(PROC)
endif

ifneq ($(findstring posix,$(BLD)),)
	XBLD := 1
endif

ifneq ($(findstring windows,$(BLD)),)
	WBLD := 1
endif

ifneq ($(findstring cygwin,$(BLD)),)
	CYGBLD := 1
else
	ifeq ($(findstring nocyg,$(BLD)),)
		ifneq ($(findstring cygdrive,$(PATH)),)
			CYGBLD := 1
		endif
	endif
endif

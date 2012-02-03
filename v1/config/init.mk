
ifneq ($(CYGBLD),)
	CFG_CUR_ROOT := $(subst \,/,$(shell cmd /c cd))
else
	CFG_CUR_ROOT := $(shell pwd)
endif

CFG_NAME := $(PRJ_NAME)
ifndef PRJ_DESC
	CFG_DESC := $(PRJ_NAME)
else
	CFG_DESC := $(PRJ_DESC)
endif

ifndef PRJ_LNAME
	CFG_LNAME := $(CFG_DESC)
else
	CFG_LNAME := $(PRJ_LNAME)
endif

ifneq ($(VER),)
	CFG_VER := $(VER)
	ifndef FVER
		FVER := $(VER)
	endif
else
	ifneq ($(PRJ_VERSION),)
		CFG_VER := $(PRJ_VERSION)
		ifndef PRJ_FVERSION
			PRJ_FVERSION := $(PRJ_VERSION)
		endif
	endif
endif

ifneq ($(FVER),)
	CFG_FVER := $(subst .,_,$(FVER))
else
	ifneq ($(PRJ_FVERSION),)
		CFG_FVER := $(subst .,_,$(PRJ_FVERSION))
	endif
endif

.SILENT: cfg_set_path
.PHONY: cfg_set_path
ifeq ($(BUILD),vs)
cfg_set_path:
	export PATH="$(PATH)"
	$(shell set PATH="$(PATH)")
else
cfg_set_path:
	export PATH="$(PATH)"
endif

ifdef PRJ_NAME
ifdef PRJ_DESC

$(info .=======================================================)
$(info .= $(PRJ_NAME) - $(PRJ_DESC) )
$(info .=======================================================)

else

$(info .=======================================================)
$(info .= $(PRJ_NAME) )
$(info .=======================================================)

endif
else

$(info .=======================================================)
$(info .= PRJ_NAME NOT SPECIFIED )
$(info .=======================================================)

endif

ifdef PRJ_LOCAL
CFG_PROC	 := $(CFG_LOCAL_PROC)
CFG_TOOLS	 := $(CFG_LOCAL_TOOLS)
else
CFG_PROC	 := $(PROC)
CFG_TOOLS	 := $(TOOLS)
endif

ifndef PRJ_TYPE
PRJ_TYPE := exe
endif

ifeq ($(OUT),)
CFG_OUT:=$(CFG_ROOT)/bin$(CFG_IDX)
else
CFG_OUT:=$(strip $(OUT)/bin$(CFG_IDX))
endif


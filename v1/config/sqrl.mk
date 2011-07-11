
PRJ_INCS := $(PRJ_INCS) winglib/lib/oexlib winglib/lib/sqbind SqPlus/include SqPlus/sqplus
PRJ_LIBS := $(PRJ_LIBS) sqbind oexlib sqplus sqstdlib squirrel cximage jpeg png tiff zlib
PRJ_RESD := $(PRJ_RESD) sq
PRJ_SQEX := $(PRJ_SQEX);*.nut;*.squ

ifeq ($(PRJ_SQRL),service)
	PRJ_DEFS := $(PRJ_DEFS) OEX_SERVICE
endif

ifeq ($(PRJ_TYPE),dll)
	PRJ_EXPORTS := DllMain SRV_GetModuleInfo SRV_Start SRV_Idle SRV_Stop $(PRJ_EXPORTS)
endif

ifdef SQMOD_STATIC
	PRJ_DEFS := $(PRJ_DEFS) SQBIND_STATIC $(foreach mod,$(SQMOD_STATIC),SQBIND_STATIC_$(mod) )
endif


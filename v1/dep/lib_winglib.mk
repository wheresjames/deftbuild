
PRJ_LIBROOT := ..
include $(PRJ_LIBROOT)/config.mk

ifeq ($(WINGLIB),)
UNSUPPORTED := Set make option WINGLIB=1 to build
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# winglib is native
#-------------------------------------------------------------------
all:
	$(MAKE) -C $(CFG_LIBROOT)/winglib

endif


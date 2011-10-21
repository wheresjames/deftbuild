
default_target: all

PRJ_LIBROOT := ..
PRJ_DEPS := skwikin
include $(PRJ_LIBROOT)/config.mk

ifeq ($(strip $(EXISTS_LIBSRC)),) 
UNSUPPORTED := $(PRJ_DEPS) is not checked out
include $(PRJ_LIBROOT)/unsupported.mk
else

#-------------------------------------------------------------------
# skwikin is native
#-------------------------------------------------------------------
all:
	$(MAKE) -C $(CFG_LIBROOT)/skwikin

endif
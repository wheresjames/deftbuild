
default_target: all

PRJ_LIBROOT := ..
PRJ_DEPS := skwikin
include $(PRJ_LIBROOT)/config.mk

#-------------------------------------------------------------------
# skwikin is native
#-------------------------------------------------------------------
all:
	$(MAKE) -C $(CFG_LIBROOT)/skwikin


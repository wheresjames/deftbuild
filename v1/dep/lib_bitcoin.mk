
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := bitcoin
PRJ_DEPS := bitcoin
PRJ_TYPE := lib
PRJ_INCS := boost openssl/include dbd/build_windows \
			bitcoin/src/leveldb/include bitcoin/src/leveldb/helpers/memenv
PRJ_LIBS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(BUILD),vs)
UNSUPPORTED := BUILD=$(BUILD) is invalid
include $(PRJ_LIBROOT)/unsupported.mk
else

PRJ_DEFS := $(PRJ_DEFS) HAVE_WORKING_BOOST_SLEEP 

ifeq ($(OS),win)
	PRJ_DEFS := $(PRJ_DEFS) PRId64="\"I64d\"" PRIu64="\"I64u\"" PRIx64="\"I64x\""
else
	PRJ_DEFS := $(PRJ_DEFS) PRId64="\"lld\"" PRIu64="\"llu\"" PRIx64="\"llx\""
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/bitcoin/src
LOC_EXC_def :=
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

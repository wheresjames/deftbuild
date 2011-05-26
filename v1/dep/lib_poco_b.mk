
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := poco_b
PRJ_DEPS := poco
PRJ_TYPE := lib
PRJ_INCS := poco/Foundation/include poco/Net/include zlib \
			openssl/include poco/NetSSL_OpenSSL/include poco/Crypto/include \
			poco/WebWidgets/include poco/Util/include poco/XML/include poco/Zip/include
PRJ_LIBS := 
PRJ_DEFS := HAVE_MEMMOVE POCO_NO_AUTOMATIC_LIBS XML_STATIC POCO_STATIC \
			PCRE_STATIC OPENSSL_NO_ENGINE OPENSSL_NOWINSOCK2

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PROC),arm)
UNSUPPORTED := PROC=$(PROC) is not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(PLATFORM),windows)

	ifneq ($(UNICODE),)
		PRJ_DEFS := $(PRJ_DEFS) POCO_WIN32_UTF8
	endif

	ifeq ($(BUILD),gcc)
		PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/mingw/inc $(PRJ_INCS)
		PRJ_DEFS := $(PRJ_DEFS) WC_NO_BEST_FIT_CHARS=0x00000400
	endif
endif

ifeq ($(OS),android)
	PRJ_DEFS := $(PRJ_DEFS) POCO_OS_FAMILY_UNIX POCO_NO_FPENVIRONMENT \
							POCO_NO_NAMEDEVENTS POCO_NO_RWLOCKS \
							POCO_NO_SHAREDMEMORY
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := crypto
LOC_SRC_crypto := $(CFG_LIBROOT)/poco/Crypto/src
LOC_EXC_crypto := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := ssl
LOC_SRC_ssl := $(CFG_LIBROOT)/poco/NetSSL_OpenSSL/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := util
LOC_SRC_util := $(CFG_LIBROOT)/poco/Util/src
ifneq ($(PLATFORM),windows)
	LOC_EXC_util := WinRegistryConfiguration WinRegistryKey WinService
endif
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := web
#LOC_SRC_web := $(CFG_LIBROOT)/poco/WebWidgets/src
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := xml
LOC_SRC_xml := $(CFG_LIBROOT)/poco/XML/src
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := xml_c
LOC_CXX_xml_c := c
LOC_SRC_xml_c := $(CFG_LIBROOT)/poco/XML/src
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := zip
#LOC_SRC_zip := $(CFG_LIBROOT)/poco/Zip/src
#include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

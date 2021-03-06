
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := libxml2
PRJ_DEPS := libxml2
PRJ_TYPE := lib
PRJ_INCS := libxml2/include zlib
PRJ_LIBS := 
PRJ_DEFS := LIBXML_THREAD_ENABLED=1 LIBXML_TREE_ENABLED=1

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifneq ($(PROC),x86)
UNSUPPORTED := PROC=$(PROC) Not supported
include $(PRJ_LIBROOT)/unsupported.mk
else

ifeq ($(PLATFORM),windows)
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/libxml/inc/windows $(PRJ_INCS)
else
	PRJ_INCS := $(CFG_LIB2BLD)/dep/etc/libxml/inc/posix $(PRJ_INCS)
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_CXX_def := c
LOC_SRC_def := $(CFG_LIBROOT)/libxml2
LOC_EXC_def := rngparser schematron testapi testchar testdict \
			   testC14N testdso testHTML testModule testOOM testOOMlib testReader \
			   testrecurse testRegexp testRelax testSAX testSchemas \
			   testThreads testThreadsWin32 testURI testXPath trionan \
			   xmlcatalog xmllint
			   
ifeq ($(PLATFORM),posix)
	LOC_EXC_def := $(LOC_EXC_def) trio
endif
			   
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif


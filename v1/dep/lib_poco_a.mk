
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := poco_a
PRJ_DEPS := poco
PRJ_TYPE := lib
PRJ_INCS := poco/Foundation/include poco/Net/include zlib \
			openssl/include poco/Crypto/include poco/WebWidgets/include \
			poco/Util/include poco/XML/include poco/Zip/include
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
else
		PRJ_DEFS := $(PRJ_DEFS) TIMEVAL=timeval
endif

ifeq ($(OS),android)
	PRJ_DEFS := $(PRJ_DEFS) POCO_OS_FAMILY_UNIX POCO_NO_FPENVIRONMENT \
							POCO_NO_NAMEDEVENTS POCO_NO_RWLOCKS \
							POCO_NO_SHAREDMEMORY
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := def
LOC_SRC_def := $(CFG_LIBROOT)/poco/Foundation/src
LOC_EXC_def := DirectoryIterator_UNIX DirectoryIterator_VMS DirectoryIterator_WIN32 DirectoryIterator_WIN32U \
			   Environment_UNIX Environment_VMS Environment_WIN32 Environment_WIN32U Environment_WINCE \
			   Event_POSIX Event_WIN32 File_UNIX File_VMS File_WIN32 File_WIN32U File_WINCE \
			   FileStream_POSIX FileStream_WIN32 \
			   FPEnvironment_C99 FPEnvironment_DEC FPEnvironment_DUMMY FPEnvironment_SUN FPEnvironment_WIN32 \
			   LogFile_STD LogFile_VMS LogFile_WIN32 LogFile_WIN32U Mutex_POSIX Mutex_WIN32 Mutex_WINCE \
			   NamedEvent_UNIX NamedEvent_VMS NamedEvent_WIN32 NamedEvent_WIN32U \
			   NamedMutex_UNIX NamedMutex_VMS NamedMutex_WIN32 NamedMutex_WIN32U \
			   Path_UNIX Path_VMS Path_WIN32 Path_WIN32U Path_WINCE \
			   PipeImpl_DUMMY PipeImpl_POSIX PipeImpl_WIN32 \
			   Process_UNIX Process_VMS Process_WIN32 Process_WIN32U Process_WINCE \
			   RWLock_POSIX RWLock_WIN32 RWLock_WINCE Semaphore_POSIX Semaphore_WIN32 \
			   SharedLibrary_HPUX SharedLibrary_UNIX SharedLibrary_VMS \
			   SharedLibrary_WIN32 SharedLibrary_WIN32U \
			   SharedMemory_DUMMY SharedMemory_POSIX SharedMemory_WIN32 SharedMemory_WIN32U \
			   Thread_POSIX Thread_WIN32 Thread_WIN32U Thread_WINCE Timezone_UNIX Timezone_WIN32 Timezone_WINCE \
			   OpcomChannel	SyslogChannel
ifneq ($(PLATFORM),windows)
	LOC_EXC_def := $(LOC_EXC_def) EventLogChannel WindowsConsoleChannel
endif
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := def_c
LOC_CXX_def_c := c
LOC_SRC_def_c := $(CFG_LIBROOT)/poco/Foundation/src
LOC_EXC_def_c := adler32 compress crc32 deflate gzio \
			 	 infback inffast inffixed inflate inftrees \
			   	 trees ucp zutil
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := net
LOC_SRC_net := $(CFG_LIBROOT)/poco/Net/src
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk

endif

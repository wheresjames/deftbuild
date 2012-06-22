
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := vnc
PRJ_DEPS := vnc
PRJ_TYPE := lib
PRJ_INCS := vnc jpeg png zlib openssl/include vnc/common
PRJ_LIBS :=
PRJ_DEFS := LIBVNCSERVER_HAVE_LIBZ=1 LIBVNCSERVER_WITH_WEBSOCKETS=1 \
			LIBVNCSERVER_HAVE_LIBJPEG=1 LIBVNCSERVER_HAVE_LIBPNG=1
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(BUILD),vs)
	PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/vs/inc/c99
	
	# +++ Obviously, this should all be fixed
	PRJ_DEFS := $(PRJ_DEFS) in_addr_t=uint32_t \
							socklen_t=uint32_t \
							int32_t=int \
							ssize_t=int \
							SIGPIPE=13 \
							O_RDONLY=0 \
							O_WRONLY=1 \
							O_CREAT=0x0200 \
							O_TRUNC=0x0400
	CFG_DEFS := $(CFG_DEFS) /Duint32_t="unsigned int" \
							/Duint16_t="unsigned short" \
							/Duint8_t="unsigned char" \
							/DSHUT_RDWR=2 \
							/DLIBVNCSERVER_PACKAGE_STRING="\"\""
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := common
LOC_CXX_common := c
LOC_SRC_common := $(CFG_LIBROOT)/vnc/common
LOC_EXC_common := 

export LOC_TAG := def
LOC_CXX_def := c
#LOC_BLD_def := cpp
LOC_SRC_def := $(CFG_LIBROOT)/vnc/libvncserver
LOC_EXC_def := tableinitcmtemplate tabletrans24template tableinittctemplate \
			   tabletranstemplate tableinit24
ifeq ($(BUILD),vs)
	LOC_EXC_def := $(LOC_EXC_def) zrleencodetemplate websockets \
								  rfbcrypto_polarssl rfbcrypto_included \
								  rfbcrypto_gnutls rfbssl_gnutls ultra \
								  rfbcrypto_openssl rfbssl_openssl
endif  

include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk



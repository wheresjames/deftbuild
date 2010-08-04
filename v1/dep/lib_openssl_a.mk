
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := openssl_a
PRJ_DEPS := openssl
PRJ_TYPE := lib
PRJ_INCS := openssl openssl/include openssl/crypto \
			openssl/crypto/asn1 openssl/crypto/evp
PRJ_LIBS := 
PRJ_DEFS := 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) OPENSSL_NO_ASM OPENSSL_NO_ERR
endif
ifeq ($(BUILD),vs)
	PRJ_DEFS := $(PRJ_DEFS) ssize_t=long
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := ssl
LOC_CXX_ssl := c
LOC_SRC_ssl := $(CFG_LIBROOT)/openssl/ssl
LOC_EXC_ssl := ssl_task ssltest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto
LOC_CXX_crypto := c
LOC_SRC_crypto := $(CFG_LIBROOT)/openssl/crypto
LOC_EXC_crypto := cversion \
				  LPdir_nyi LPdir_unix LPdir_vms LPdir_wince LPdir_win32 LPdir_win
ifeq ($(PLATFORM),windows)
	LOC_EXC_crypto := $(LOC_EXC_crypto) ppccap s390xcap sparcv9cap
else
	LOC_EXC_crypto := $(LOC_EXC_crypto) 
endif
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_asm
LOC_CXX_crypto_asm := asm
LOC_BLD_crypto_asm := as
LOC_SRC_crypto_asm := $(CFG_LIBROOT)/openssl/crypto
LOC_EXC_crypto_asm := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_aes
LOC_CXX_crypto_aes := c
LOC_SRC_crypto_aes := $(CFG_LIBROOT)/openssl/crypto/aes
LOC_EXC_crypto_aes :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_asn1
LOC_CXX_crypto_asn1 := c
LOC_SRC_crypto_asn1 := $(CFG_LIBROOT)/openssl/crypto/asn1
LOC_EXC_crypto_asn1 :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_bio
LOC_CXX_crypto_bio := c
LOC_SRC_crypto_bio := $(CFG_LIBROOT)/openssl/crypto/bio
LOC_EXC_crypto_bio := bss_rtcp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_bn
LOC_CXX_crypto_bn := c
LOC_SRC_crypto_bn := $(CFG_LIBROOT)/openssl/crypto/bn
LOC_EXC_crypto_bn := exp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_buffer
LOC_CXX_crypto_buffer := c
LOC_SRC_crypto_buffer := $(CFG_LIBROOT)/openssl/crypto/buffer
LOC_EXC_crypto_buffer := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_camellia
LOC_CXX_crypto_camellia := c
LOC_SRC_crypto_camellia := $(CFG_LIBROOT)/openssl/crypto/camellia
LOC_EXC_crypto_camellia := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_comp
LOC_CXX_crypto_comp := c
LOC_SRC_crypto_comp := $(CFG_LIBROOT)/openssl/crypto/comp
LOC_EXC_crypto_comp := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_cmac
LOC_CXX_crypto_cmac := c
LOC_SRC_crypto_cmac := $(CFG_LIBROOT)/openssl/crypto/cmac
LOC_EXC_crypto_cmac := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_cms
LOC_CXX_crypto_cms := c
LOC_SRC_crypto_cms := $(CFG_LIBROOT)/openssl/crypto/cms
LOC_EXC_crypto_cms := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_conf
LOC_CXX_crypto_conf := c
LOC_SRC_crypto_conf := $(CFG_LIBROOT)/openssl/crypto/conf
LOC_EXC_crypto_conf := cnf_save test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_dh
LOC_CXX_crypto_dh := c
LOC_SRC_crypto_dh := $(CFG_LIBROOT)/openssl/crypto/dh
LOC_EXC_crypto_dh := dhtest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_dsa
LOC_CXX_crypto_dsa := c
LOC_SRC_crypto_dsa := $(CFG_LIBROOT)/openssl/crypto/dsa
LOC_EXC_crypto_dsa :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_dso
LOC_CXX_crypto_dso := c
LOC_SRC_crypto_dso := $(CFG_LIBROOT)/openssl/crypto/dso
LOC_EXC_crypto_dso :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ec
LOC_CXX_crypto_ec := c
LOC_SRC_crypto_ec := $(CFG_LIBROOT)/openssl/crypto/ec
LOC_EXC_crypto_ec :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ecdh
LOC_CXX_crypto_ecdh := c
LOC_SRC_crypto_ecdh := $(CFG_LIBROOT)/openssl/crypto/ecdh
LOC_EXC_crypto_ecdh :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ecdsa
LOC_CXX_crypto_ecdsa := c
LOC_SRC_crypto_ecdsa := $(CFG_LIBROOT)/openssl/crypto/ecdsa
LOC_EXC_crypto_ecdsa :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_engine
LOC_CXX_crypto_engine := c
LOC_SRC_crypto_engine := $(CFG_LIBROOT)/openssl/crypto/engine
LOC_EXC_crypto_engine :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_err
LOC_CXX_crypto_err := c
LOC_SRC_crypto_err := $(CFG_LIBROOT)/openssl/crypto/err
LOC_EXC_crypto_err :=
include $(PRJ_LIBROOT)/build.mk


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk




default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := openssl_b
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
	PRJ_DEFS := $(PRJ_DEFS) OPENSSL_NO_ASM
endif
ifeq ($(BUILD),vs)
	PRJ_DEFS := $(PRJ_DEFS) ssize_t=long
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := crypto_evp
LOC_CXX_crypto_evp := c
LOC_SRC_crypto_evp := $(CFG_LIBROOT)/openssl/crypto/evp
LOC_EXC_crypto_evp := e_dsa  
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_hmac
LOC_CXX_crypto_hmac := c
LOC_SRC_crypto_hmac := $(CFG_LIBROOT)/openssl/crypto/hmac
LOC_EXC_crypto_hmac := e_dsa  
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_lhash
LOC_CXX_crypto_lhash := c
LOC_SRC_crypto_lhash := $(CFG_LIBROOT)/openssl/crypto/lhash
LOC_EXC_crypto_lhash := lh_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_md5
LOC_CXX_crypto_md5 := c
LOC_SRC_crypto_md5 := $(CFG_LIBROOT)/openssl/crypto/md5
LOC_EXC_crypto_md5 := md5test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_objects
LOC_CXX_crypto_objects := c
LOC_SRC_crypto_objects := $(CFG_LIBROOT)/openssl/crypto/objects
LOC_EXC_crypto_objects :=   
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ocsp
LOC_CXX_crypto_ocsp := c
LOC_SRC_crypto_ocsp := $(CFG_LIBROOT)/openssl/crypto/ocsp
LOC_EXC_crypto_ocsp :=   
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_pem
LOC_CXX_crypto_pem := c
LOC_SRC_crypto_pem := $(CFG_LIBROOT)/openssl/crypto/pem
LOC_EXC_crypto_pem := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_pkcs7
LOC_CXX_crypto_pkcs7 := c
LOC_SRC_crypto_pkcs7 := $(CFG_LIBROOT)/openssl/crypto/pkcs7
LOC_EXC_crypto_pkcs7 := bio_ber pk7_enc
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_pkcs12
LOC_CXX_crypto_pkcs12 := c
LOC_SRC_crypto_pkcs12 := $(CFG_LIBROOT)/openssl/crypto/pkcs12
LOC_EXC_crypto_pkcs12 :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rand
LOC_CXX_crypto_rand := c
LOC_SRC_crypto_rand := $(CFG_LIBROOT)/openssl/crypto/rand
LOC_EXC_crypto_rand := randtest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rsa
LOC_CXX_crypto_rsa := c
LOC_SRC_crypto_rsa := $(CFG_LIBROOT)/openssl/crypto/rsa
LOC_EXC_crypto_rsa := rsa_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_sha
LOC_CXX_crypto_sha := c
LOC_SRC_crypto_sha := $(CFG_LIBROOT)/openssl/crypto/sha
LOC_EXC_crypto_sha :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_stack
LOC_CXX_crypto_stack := c
LOC_SRC_crypto_stack := $(CFG_LIBROOT)/openssl/crypto/stack
LOC_EXC_crypto_stack :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ui
LOC_CXX_crypto_ui := c
LOC_SRC_crypto_ui := $(CFG_LIBROOT)/openssl/crypto/ui
LOC_EXC_crypto_ui :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_x509
LOC_CXX_crypto_x509 := c
LOC_SRC_crypto_x509 := $(CFG_LIBROOT)/openssl/crypto/x509
LOC_EXC_crypto_x509 := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_x509v3
LOC_CXX_crypto_x509v3 := c
LOC_SRC_crypto_x509v3 := $(CFG_LIBROOT)/openssl/crypto/x509v3
LOC_EXC_crypto_x509v3 := v3conf
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk




default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := openssl
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

#ifeq ($(PLATFORM),windows)
#	PRJ_DEFS := $(PRJ_DEFS) HAVE_WINSOCK2
#endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := ssl
LOC_CXX_ssl := c
LOC_SRC_ssl := $(CFG_LIBROOT)/openssl/ssl
LOC_EXC_ssl := ssl_task
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto
LOC_CXX_crypto := c
LOC_SRC_crypto := $(CFG_LIBROOT)/openssl/crypto
LOC_EXC_crypto := cversion \
				  LPdir_nyi LPdir_unix LPdir_vms LPdir_win32 LPdir_win LPdir_wince
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

export LOC_TAG := crypto_cmac
LOC_CXX_crypto_cmac := c
LOC_SRC_crypto_cmac := $(CFG_LIBROOT)/openssl/crypto/cmac
LOC_EXC_crypto_cmac := 
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

export LOC_TAG := crypto_ec
LOC_CXX_crypto_ec := c
LOC_SRC_crypto_ec := $(CFG_LIBROOT)/openssl/crypto/ec
LOC_EXC_crypto_ec :=
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
LOC_EXC_crypto_rand :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rsa
LOC_CXX_crypto_rsa := c
LOC_SRC_crypto_rsa := $(CFG_LIBROOT)/openssl/crypto/rsa
LOC_EXC_crypto_rsa :=
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




default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := openssl_c
PRJ_DEPS := openssl
PRJ_TYPE := lib
PRJ_INCS := openssl openssl/include openssl/crypto \
			openssl/crypto/asn1 openssl/crypto/evp
PRJ_LIBS := 
PRJ_DEFS := NO_WINDOWS_BRAINDEATH I386_ONLY OPENSSL_NO_ASM 

PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) OPENSSL_NO_ERR
endif
ifeq ($(BUILD),vs)
	PRJ_DEFS := $(PRJ_DEFS) ssize_t=long
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := crypto_engine
LOC_CXX_crypto_engine := c
LOC_SRC_crypto_engine := $(CFG_LIBROOT)/openssl/crypto/engine
LOC_EXC_crypto_engine := enginetest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_err
LOC_CXX_crypto_err := c
LOC_SRC_crypto_err := $(CFG_LIBROOT)/openssl/crypto/err
LOC_EXC_crypto_err :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_evp
LOC_CXX_crypto_evp := c
LOC_SRC_crypto_evp := $(CFG_LIBROOT)/openssl/crypto/evp
LOC_EXC_crypto_evp := e_dsa openbsd_hw evp_test
LOC_EXI_crypto_evp := $(CFG_LIBROOT)/openssl/crypto/modes
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_hmac
LOC_CXX_crypto_hmac := c
LOC_SRC_crypto_hmac := $(CFG_LIBROOT)/openssl/crypto/hmac
LOC_EXC_crypto_hmac := e_dsa hmactest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_idea
LOC_CXX_crypto_idea := c
LOC_SRC_crypto_idea := $(CFG_LIBROOT)/openssl/crypto/idea
LOC_EXC_crypto_idea := idea_spd ideatest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_lhash
LOC_CXX_crypto_lhash := c
LOC_SRC_crypto_lhash := $(CFG_LIBROOT)/openssl/crypto/lhash
LOC_EXC_crypto_lhash := lh_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_md4
LOC_CXX_crypto_md4 := c
LOC_SRC_crypto_md4 := $(CFG_LIBROOT)/openssl/crypto/md4
LOC_EXC_crypto_md4 := md4 md4test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_md5
LOC_CXX_crypto_md5 := c
LOC_SRC_crypto_md5 := $(CFG_LIBROOT)/openssl/crypto/md5
LOC_EXC_crypto_md5 := md5 md5test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_mdc2
LOC_CXX_crypto_mdc2 := c
LOC_SRC_crypto_mdc2 := $(CFG_LIBROOT)/openssl/crypto/mdc2
LOC_EXC_crypto_mdc2 := mdc2test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_modes
LOC_CXX_crypto_modes := c
LOC_SRC_crypto_modes := $(CFG_LIBROOT)/openssl/crypto/modes
LOC_EXC_crypto_modes := 
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
LOC_EXC_crypto_pkcs7 := bio_ber dec enc pk7_enc sign verify
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_pkcs12
LOC_CXX_crypto_pkcs12 := c
LOC_SRC_crypto_pkcs12 := $(CFG_LIBROOT)/openssl/crypto/pkcs12
LOC_EXC_crypto_pkcs12 :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_pqueue
LOC_CXX_crypto_pqueue := c
LOC_SRC_crypto_pqueue := $(CFG_LIBROOT)/openssl/crypto/pqueue
LOC_EXC_crypto_pqueue := pq_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rand
LOC_CXX_crypto_rand := c
LOC_SRC_crypto_rand := $(CFG_LIBROOT)/openssl/crypto/rand
LOC_EXC_crypto_rand := randtest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rc2
LOC_CXX_crypto_rc2 := c
LOC_SRC_crypto_rc2 := $(CFG_LIBROOT)/openssl/crypto/rc2
LOC_EXC_crypto_rc2 := rc2 rc2test rc2speed tab
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rc4
LOC_CXX_crypto_rc4 := c
LOC_SRC_crypto_rc4 := $(CFG_LIBROOT)/openssl/crypto/rc4
LOC_EXC_crypto_rc4 := rc4 rc4test rc4speed
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ripemd
LOC_CXX_crypto_ripemd := c
LOC_SRC_crypto_ripemd := $(CFG_LIBROOT)/openssl/crypto/ripemd
LOC_EXC_crypto_ripemd := rmdtest rmd160 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_rsa
LOC_CXX_crypto_rsa := c
LOC_SRC_crypto_rsa := $(CFG_LIBROOT)/openssl/crypto/rsa
LOC_EXC_crypto_rsa := rsa_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_seed
LOC_CXX_crypto_seed := c
LOC_SRC_crypto_seed := $(CFG_LIBROOT)/openssl/crypto/seed
LOC_EXC_crypto_seed :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_sha
LOC_CXX_crypto_sha := c
LOC_SRC_crypto_sha := $(CFG_LIBROOT)/openssl/crypto/sha
LOC_EXC_crypto_sha := sha sha1 shatest sha1test sha256t sha512t
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_srp
LOC_CXX_crypto_srp := c
LOC_SRC_crypto_srp := $(CFG_LIBROOT)/openssl/crypto/srp
LOC_EXC_crypto_srp := srptest
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_stack
LOC_CXX_crypto_stack := c
LOC_SRC_crypto_stack := $(CFG_LIBROOT)/openssl/crypto/stack
LOC_EXC_crypto_stack :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ts
LOC_CXX_crypto_ts := c
LOC_SRC_crypto_ts := $(CFG_LIBROOT)/openssl/crypto/ts
LOC_EXC_crypto_ts :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_txtdb
LOC_CXX_crypto_txtdb := c
LOC_SRC_crypto_txtdb := $(CFG_LIBROOT)/openssl/crypto/txt_db
LOC_EXC_crypto_txtdb :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_ui
LOC_CXX_crypto_ui := c
LOC_SRC_crypto_ui := $(CFG_LIBROOT)/openssl/crypto/ui
LOC_EXC_crypto_ui :=
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_whrlpool
LOC_CXX_crypto_whrlpool := c
LOC_SRC_crypto_whrlpool := $(CFG_LIBROOT)/openssl/crypto/whrlpool
LOC_EXC_crypto_whrlpool := wp_test
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_x509
LOC_CXX_crypto_x509 := c
LOC_SRC_crypto_x509 := $(CFG_LIBROOT)/openssl/crypto/x509
LOC_EXC_crypto_x509 := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := crypto_x509v3
LOC_CXX_crypto_x509v3 := c
LOC_SRC_crypto_x509v3 := $(CFG_LIBROOT)/openssl/crypto/x509v3
LOC_EXC_crypto_x509v3 := tabtest v3conf v3prin v3nametest
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk



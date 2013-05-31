
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := crtmp
PRJ_DEPS := crtmp
PRJ_TYPE := lib
PRJ_INCS := openssl/include lua/src tinyxml \
			crtmp/sources/common/include crtmp/sources/thelib/include
PRJ_LIBS := 
PRJ_DEFS := NET_SELECT HAS_LUA LITTLE_ENDIAN_BYTE_ALIGNED \
			HAS_PROTOCOL_TS HAS_PROTOCOL_RTMP
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := app
LOC_SRC_app := $(CFG_LIBROOT)/crtmp/sources/thelib/src/application
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cfg
LOC_SRC_cfg := $(CFG_LIBROOT)/crtmp/sources/thelib/src/configuration
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := mf
LOC_SRC_mf := $(CFG_LIBROOT)/crtmp/sources/thelib/src/mediaformats
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := mf_flv
LOC_SRC_mf_flv := $(CFG_LIBROOT)/crtmp/sources/thelib/src/mediaformats/flv
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := nio_select
LOC_SRC_nio_select := $(CFG_LIBROOT)/crtmp/sources/thelib/src/netio/select
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto
LOC_SRC_proto := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := proto_cli
#LOC_SRC_proto_cli := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/cli
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_dns
LOC_SRC_proto_dns := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/dns
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_http
LOC_SRC_proto_http := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/http
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_liveflv
LOC_SRC_proto_liveflv := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/liveflv
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_mms
LOC_SRC_proto_mms := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/mms
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rawhttpstream
LOC_SRC_proto_rawhttpstream := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rawhttpstream
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtmp
LOC_SRC_proto_rtmp := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtmp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtmp_mf
LOC_SRC_proto_rtmp_mf := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtmp/messagefactories
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtmp_so
LOC_SRC_proto_rtmp_so := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtmp/sharedobjects
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtmp_streaming
LOC_SRC_proto_rtmp_streaming := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtmp/streaming
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtp
LOC_SRC_proto_rtp := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtp
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtp_conn
LOC_SRC_proto_rtp_conn := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtp/connectivity
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_rtp_streaming
LOC_SRC_proto_rtp_streaming := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/rtp/streaming
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_ssl
LOC_SRC_proto_ssl := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/ssl
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_timer
LOC_SRC_proto_timer := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/timer
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_ts
LOC_SRC_proto_ts := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/ts
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := proto_variant
LOC_SRC_proto_variant := $(CFG_LIBROOT)/crtmp/sources/thelib/src/protocols/variant
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := streaming
LOC_SRC_streaming := $(CFG_LIBROOT)/crtmp/sources/thelib/src/streaming
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn
LOC_SRC_cmn := $(CFG_LIBROOT)/crtmp/sources/common/src/platform
include $(PRJ_LIBROOT)/build.mk

ifeq ($(PLATFORM),windows)
	export LOC_TAG := cmn_plat
	LOC_SRC_cmn_plat := $(CFG_LIBROOT)/crtmp/sources/common/src/platform/windows
	include $(PRJ_LIBROOT)/build.mk
else
	export LOC_TAG := cmn_plat
	LOC_SRC_cmn_plat := $(CFG_LIBROOT)/crtmp/sources/common/src/platform/linux
	include $(PRJ_LIBROOT)/build.mk
endif

export LOC_TAG := cmn_util_buf
LOC_SRC_cmn_util_buf := $(CFG_LIBROOT)/crtmp/sources/common/src/utils/buffering
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn_util_log
LOC_SRC_cmn_util_log := $(CFG_LIBROOT)/crtmp/sources/common/src/utils/logging
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn_util_lua
LOC_SRC_cmn_util_lua := $(CFG_LIBROOT)/crtmp/sources/common/src/utils/lua
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn_util_mp
LOC_SRC_cmn_util_mp := $(CFG_LIBROOT)/crtmp/sources/common/src/utils/mempool
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := cmn_util_misc
LOC_SRC_cmn_util_misc := $(CFG_LIBROOT)/crtmp/sources/common/src/utils/misc
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


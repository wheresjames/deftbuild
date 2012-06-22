
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := nginx
PRJ_DEPS := nginx
PRJ_TYPE := lib
PRJ_INCS := pcre openssl/include xml2/include xslt geoip/libGeoIP \
			gdchart/gd1.3 zlib \
			nginx/src/core nginx/src/mail \
			nginx/src/event nginx/src/event/modules \
			nginx/src/http nginx/src/http/modules
PRJ_LIBS := 
PRJ_DEFS := NGX_PCRE NGX_SSL NGX_OPENSSL NGX_HAVE_AIO NGX_HAVE_IOCP \
			NGX_HTTP_CACHE NGX_STAT_STUB NGX_HTTP_PROXY NGX_HTTP_SSI \
			NGX_HTTP_GZIP NGX_HTTP_SSL NGX_HTTP_REALIP NGX_HTTP_DAV \
			NGX_HTTP_GEO NGX_HTTP_HEADERS NGX_MAIL_SSL \
			NGX_CPU_CACHE_LINE=64 \
			NGX_ERROR_LOG_PATH="\"\"" \
			NGX_HTTP_LOG_PATH="\"\"" \
			NGX_HTTP_CLIENT_TEMP_PATH="\"\"" \
			NGX_HTTP_UWSGI_TEMP_PATH="\"\"" \
			NGX_HTTP_PROXY_TEMP_PATH="\"\"" \
			NGX_HTTP_FASTCGI_TEMP_PATH="\"\"" \
			NGX_HTTP_SCGI_TEMP_PATH="\"\""
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

PRJ_INCS := $(PRJ_INCS) $(CFG_LIB2BLD)/dep/etc/nginx/inc

ifeq ($(PLATFORM),windows)
	PRJ_DEFS := $(PRJ_DEFS) NGX_WIN32 _off_t=unsigned
	PRJ_INCS := $(PRJ_INCS) nginx/src/os/win32
else
	PRJ_DEFS := NGX_LINUX
	PRJ_INCS := $(PRJ_INCS) nginx/src/os/unix
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
export LOC_TAG := core
LOC_CXX_core := c
LOC_SRC_core := $(CFG_LIBROOT)/nginx/src/core
LOC_EXC_core := nginx
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := event
LOC_CXX_event := c
LOC_SRC_event := $(CFG_LIBROOT)/nginx/src/event
LOC_EXC_event := ngx_event_connectex
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := event_modules
LOC_CXX_event_modules := c
LOC_SRC_event_modules := $(CFG_LIBROOT)/nginx/src/event/modules
LOC_LST_event_modules := ngx_win32_select_module
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := http
LOC_CXX_http := c
LOC_SRC_http := $(CFG_LIBROOT)/nginx/src/http
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := http_modules
LOC_CXX_http_modules := c
LOC_SRC_http_modules := $(CFG_LIBROOT)/nginx/src/http/modules
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := mail
LOC_CXX_mail := c
LOC_SRC_mail := $(CFG_LIBROOT)/nginx/src/mail
LOC_EXC_mail :=
include $(PRJ_LIBROOT)/build.mk

ifeq ($(PLATFORM),windows)
	NGX_OS := win32
	LOC_EXC_$(NGX_OS) := ngx_service
else
	NGX_OS := unix
endif

export LOC_TAG := $(NGX_OS)
LOC_CXX_$(NGX_OS) := c
LOC_SRC_$(NGX_OS) := $(CFG_LIBROOT)/nginx/src/os/$(NGX_OS)
include $(PRJ_LIBROOT)/build.mk


#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk



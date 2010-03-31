
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := gstreamer
PRJ_DEPS := gstreamer
PRJ_TYPE := lib
PRJ_INCS := gstreamer/gstreamer gstreamer/gstreamer/gst \
			glib glib/glib glib/gmodule glib/gobject \
			libxml/include
PRJ_LIBS := 
PRJ_DEFS := HAVE_CONFIG_H=1 
PRJ_LIBROOT := ..
PRJ_OBJROOT := _0_dep

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/config.mk

PRJ_INCS := $(PRJ_INCS) \
			$(CFG_LIB2BLD)/dep/etc/gstreamer/inc/posix \
			$(CFG_LIB2BLD)/dep/etc/gstreamer/inc/posix/gst \
			$(CFG_LIB2BLD)/dep/etc/libxml/inc/posix

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := gst_custom
LOC_CXX_gst_custom := c
LOC_SRC_gst_custom := $(CFG_LIBROOT)/$(CFG_LIB2BLD)/dep/etc/gstreamer/src/posix
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := gst
LOC_CXX_gst := c
LOC_SRC_gst := $(CFG_LIBROOT)/gstreamer/gstreamer/gst
LOC_EXC_gst := gstregistryxml
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := gst_parse
LOC_CXX_gst_parse := c
LOC_SRC_gst_parse := $(CFG_LIBROOT)/gstreamer/gstreamer/gst/parse
#LOC_EXC_gst_parse := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := gst_libs_base
LOC_CXX_gst_libs_base := c
LOC_INC_gst_libs_base := $(CFG_LIBROOT)/gstreamer/gstreamer/libs
LOC_SRC_gst_libs_base := $(CFG_LIBROOT)/gstreamer/gstreamer/libs/gst/base
LOC_EXC_gst_libs_base := 
include $(PRJ_LIBROOT)/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(PRJ_LIBROOT)/go.mk


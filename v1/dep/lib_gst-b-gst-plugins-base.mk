
default_target: all

#-------------------------------------------------------------------
# Project
#-------------------------------------------------------------------
PRJ_NAME := gst-plugins-base
PRJ_DEPS := gstreamer
PRJ_TYPE := lib
PRJ_INCS := gstreamer/gstreamer gstreamer/gstreamer/libs \
			gstreamer/gst-plugins-base/gst-libs \
			gstreamer/gst-plugins-base/gst-libs/gst/interfaces \
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
			$(CFG_LIB2BLD)/dep/etc/gstreamer/inc/posix/gst/interfaces \
			$(CFG_LIB2BLD)/dep/etc/libxml/inc/posix

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------

export LOC_TAG := gpb_custom
LOC_CXX_gpb_custom := c
#LOC_INC_gpb_custom := $(CFG_LIBROOT)/gstreamer/gst-plugins-base/gst-libs/gst/interfaces
LOC_SRC_gpb_custom := $(CFG_LIBROOT)/$(CFG_LIB2BLD)/dep/etc/gstreamer/src/posix/plugins
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := gpb_interfaces
LOC_CXX_gpb_interfaces := c
LOC_SRC_gpb_interfaces := $(CFG_LIBROOT)/gstreamer/gst-plugins-base/gst-libs/gst/interfaces
LOC_EXC_gpb_interfaces := 
include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := gpb_video
LOC_CXX_gpb_video := c
LOC_SRC_gpb_video := $(CFG_LIBROOT)/gstreamer/gst-plugins-base/gst-libs/gst/video
LOC_EXC_gpb_video := 
include $(PRJ_LIBROOT)/build.mk

#export LOC_TAG := gst_libs_base
#LOC_CXX_gst_libs_base := c
#LOC_INC_gst_libs_base := $(CFG_LIBROOT)/gstreamer/gstreamer/libs
#LOC_SRC_gst_libs_base := $(CFG_LIBROOT)/gstreamer/gstreamer/libs/gst/base
#LOC_LST_gst_libs_base := gstbasetransform gstbasesink gstbasesrc gstpushsrc \
#						 gstdataqueue gsttypefindhelper
#include $(PRJ_LIBROOT)/build.mk

export LOC_TAG := gst
LOC_CXX_gst := c
LOC_SRC_gst := $(CFG_LIBROOT)/gstreamer/gstreamer/gst
LOC_EXC_gst := gstregistryxml
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


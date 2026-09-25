# libmtk_agpsd_shim: what the stock mtk_agpsd needs from Android 6 (ICU 55,
# SSL_ctrl). Injected by the linker (LINKER_FORCED_SHIM_LIBS).
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libmtk_agpsd_shim
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := ctyon
LOCAL_32_BIT_ONLY := true

LOCAL_SRC_FILES := mtk_agpsd_shim.cpp

LOCAL_C_INCLUDES := \
    external/icu/icu4c/source/common \
    external/boringssl/src/include

LOCAL_SHARED_LIBRARIES := \
    libicuuc \
    libssl \
    liblog

LOCAL_CFLAGS := -Wall -Wno-unused-parameter

include $(BUILD_SHARED_LIBRARY)

LOCAL_PATH := $(call my-dir)

# Symbols the stock blobs need, wired per consumer in board/shims.mk.
include $(CLEAR_VARS)
LOCAL_MODULE := libshim_ct07
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := ct07_shim.c
LOCAL_SHARED_LIBRARIES := libc liblog
LOCAL_MULTILIB := 32
include $(BUILD_SHARED_LIBRARY)

# Everything the stock mtk_agpsd imports that Pie lacks: ICU 55 ucnv_*
# forwarders and SSL_ctrl.
include $(CLEAR_VARS)
LOCAL_MODULE := libshim_ct07_icu
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := icu55.cpp ssl_ctrl.cpp
LOCAL_SHARED_LIBRARIES := libicuuc libssl liblog
LOCAL_C_INCLUDES := external/icu/icu4c/source/common
LOCAL_MULTILIB := 32
include $(BUILD_SHARED_LIBRARY)

# SensorManager of the Pie size for the stock camera sensor listener, which
# allocates it with the M size (sensormanager.cpp).
include $(CLEAR_VARS)
LOCAL_MODULE := libshim_ct07_sensor
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := sensormanager.cpp
LOCAL_SHARED_LIBRARIES := libdl liblog libsensor libutils
LOCAL_MULTILIB := 32
include $(BUILD_SHARED_LIBRARY)

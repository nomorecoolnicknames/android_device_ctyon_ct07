LOCAL_PATH := $(call my-dir)

# btaddr_mtk: exports the factory Bluetooth address from MTK NVRAM to
# ro.bt.bdaddr_path for the Bluetooth HAL.
include $(CLEAR_VARS)
LOCAL_SRC_FILES := btaddr_mtk.c
LOCAL_MODULE := btaddr_mtk
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_INIT_RC := ct07-bluetooth.rc
LOCAL_SHARED_LIBRARIES := libcutils liblog
LOCAL_CFLAGS := -Wall -Werror
include $(BUILD_EXECUTABLE)

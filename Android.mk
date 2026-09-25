LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),ct07)

include $(call all-makefiles-under,$(LOCAL_PATH))

# vendor/mediatek/Android.mk builds only for its own devices; pull in the
# parts this device uses. MTK_SYMBOLS_GUI_ONLY skips the camera and audio
# shims, which link modules this device does not have.
MTK_SYMBOLS_GUI_ONLY := true
include vendor/mediatek/symbols/Android.mk
MTK_SYMBOLS_GUI_ONLY :=
include vendor/mediatek/wlan/wifi_hal/Android.mk
include vendor/mediatek/wlan/wpa_supplicant_8_lib/Android.mk
include vendor/mediatek/ril/rild/Android.mk

endif

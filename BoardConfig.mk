# Ctyon CT07 (Bird bd6737t_35g_a_m0): MT6737T, 512 MB RAM, 4 GB eMMC,
# 240x320 SPI panel, no touchscreen. Non-Treble: the stock Android 6.0 blobs
# stay in /system, /vendor is /system/vendor.

DEVICE_PATH := device/bird/ct07

# Architecture: 32-bit userspace and a 32-bit kernel on Cortex-A53.
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53

# The 32-bit kernel speaks the 32-bit binder ABI.
TARGET_USES_64_BIT_BINDER := false

# Platform
TARGET_BOARD_PLATFORM := mt6737t
TARGET_BOOTLOADER_BOARD_NAME := mt6735
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
BOARD_HAS_MTK_HARDWARE := true
BOARD_USES_MTK_HARDWARE := true
MTK_HARDWARE := true

# Boot image: load addresses of the stock boot image.
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x04000000
BOARD_KERNEL_TAGS_OFFSET := 0x0e000000
BOARD_MKBOOTIMG_ARGS := \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) \
    --board 6121SO_P3
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,32N2 androidboot.selinux=permissive androidboot.hardware=mt6735 log_buf_len=1M
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
TARGET_KERNEL_ARCH := arm
TARGET_KERNEL_HEADER_ARCH := arm

# Kernel: zImage with the appended CT07 DTB, built from
# https://github.com/nomorecoolnicknames/android_kernel_ctyon_ct07
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel

# Partitions (stock GPT)
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1291845632
BOARD_CACHEIMAGE_PARTITION_SIZE := 419430400
BOARD_FLASH_BLOCK_SIZE := 131072
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
AB_OTA_UPDATER := false

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGB_565
TARGET_SCREEN_WIDTH := 240
TARGET_SCREEN_HEIGHT := 320

# TWRP for this board reports bd6737t_35g_a_m0.
TARGET_OTA_ASSERT_DEVICE := ct07,bd6737t_35g_a_m0

TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# SELinux: the M-era MTK rules violate Pie neverallows; runtime is permissive.
SELINUX_IGNORE_NEVERALLOWS := true

# Wi-Fi: MT6735 CONSYS, driver state through /dev/wmtWifi.
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_MTK := true
BOARD_BLUETOOTH_DOES_NOT_USE_RFKILL := true

# Graphics: Mali-T720 blobs, HWC 1.x through composer@2.1 (hwc2on1adapter).
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := false
USE_OPENGL_RENDERER := true

# RIL: rild from vendor/mediatek, libril from ril/.
BOARD_PROVIDES_LIBRIL := true
TARGET_SPECIFIC_HEADER_PATH := vendor/mediatek/include

# VINTF
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml

# Shims for symbols the stock Android 6.0 blobs import (shims/,
# vendor/mediatek/symbols; libsensor: SensorManager moved out of libgui).
TARGET_LD_SHIM_LIBS := \
    /system/lib/libvcodecdrv.so|/system/lib/libshim_ct07.so \
    /system/lib/libMtkOmxVdecEx.so|/system/lib/libshim_ct07.so \
    /system/lib/libmtkjpeg.so|/system/lib/libshim_ct07.so \
    /system/lib/hw/audio.primary.mt6737t.so|/system/lib/libshim_ct07.so \
    /system/bin/mtk_agpsd|/system/lib/libshim_ct07_icu.so \
    /system/lib/libgui_ext.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libMtkOmxVdecEx.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libMtkOmxVenc.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libmtk_mmutils.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libcam_utils.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libcam.camnode.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libcam.client.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libmmsdkservice.feature.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/lib/libmmsdkservice.feature.so|/system/vendor/lib/libmtkshim_ui.so \
    /system/lib/libcam.utils.sensorlistener.so|/system/lib/libshim_ct07_sensor.so \
    /system/lib/libcam.utils.sensorlistener.so|/system/lib/libsensor.so

-include vendor/ctyon/ct07/BoardConfigVendor.mk

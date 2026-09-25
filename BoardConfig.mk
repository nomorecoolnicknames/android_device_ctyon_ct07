# Ctyon CT07 (Bird bd6737t_35g_a_m0): MT6737T, 512 MB RAM, 4 GB eMMC,
# 240x320 SPI panel, no touchscreen.

DEVICE_PATH := device/bird/ct07

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53

# Platform
TARGET_BOARD_PLATFORM := mt6737t
TARGET_BOOTLOADER_BOARD_NAME := mt6735
TARGET_NO_BOOTLOADER := true
BOARD_HAS_MTK_HARDWARE := true
MTK_HARDWARE := true
TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include

# Boot image: load addresses of the stock boot image.
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x04000000
BOARD_KERNEL_TAGS_OFFSET := 0x0e000000
BOARD_MKBOOTIMG_ARGS := \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) \
    --board 6121SO_P3
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,32N2 androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
TARGET_KERNEL_ARCH := arm

# Kernel: zImage with the appended CT07 DTB, built from
# https://github.com/nomorecoolnicknames/android_kernel_ctyon_ct07
TARGET_PREBUILT_KERNEL ?= $(DEVICE_PATH)/prebuilt/kernel

# Vendor modules install into /system, as on the stock firmware.
TARGET_COPY_OUT_VENDOR := system

# Partitions (stock GPT)
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1291845632
BOARD_CACHEIMAGE_PARTITION_SIZE := 419430400
BOARD_FLASH_BLOCK_SIZE := 131072
TARGET_USERIMAGES_USE_EXT4 := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/fstab.mt6735

# TWRP for this board reports bd6737t_35g_a_m0.
TARGET_OTA_ASSERT_DEVICE := ct07,bd6737t_35g_a_m0
BOARD_NAME := ct07

TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# SELinux (permissive at runtime)
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

# Wi-Fi: MT6735 CONSYS. /dev/wmtWifi switches the driver on ("1"), off ("0")
# and between station, P2P and access point mode.
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_DRIVER_OPERSTATE_PATH := /sys/class/net/wlan0/operstate
WIFI_DRIVER_STATE_CTRL_RETRIES := 8
WIFI_DRIVER_STATE_CTRL_RETRY_DELAY_US := 1000000
WIFI_DRIVER_FW_PATH_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_FW_PATH_STA := STA
WIFI_DRIVER_FW_PATH_AP := AP
WIFI_DRIVER_FW_PATH_P2P := P2P

# Bluetooth
BOARD_HAVE_BLUETOOTH := true

# Media: syscalls the stock MTK OMX components need in mediacodec.
BOARD_SECCOMP_POLICY := $(DEVICE_PATH)/seccomp

# Shims: symbols stock blobs import and Android 7.1 does not export.
#   mtk_agpsd: ICU 55 and SSL_ctrl (shims/agpsd).
#   audio HAL: MediaTek voice-unlock AudioSystem statics (shims/audio).
LINKER_FORCED_SHIM_LIBS := \
    /system/bin/mtk_agpsd|libmtk_agpsd_shim.so:/system/lib/hw/audio.primary.mt6737t.so|libshim_ct07_audio.so

# RIL: MediaTek RIL class (ril/)
BOARD_RIL_CLASS := ../../../$(DEVICE_PATH)/ril

-include $(DEVICE_PATH)/board/packages.mk

-include vendor/ctyon/ct07/BoardConfigVendor.mk

# LineageOS 16.0 (Android 9 Go, 512 MB profile) for the Ctyon CT07.

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# lmkd at medium pressure kills from oom_adj 800 (the lmkd default) instead
# of 700 (go_defaults_512): the previous app (700) is spared, cached (900+)
# and B services (800) go first anyway. Before the inherit: first one wins.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.medium=800

$(call inherit-product, $(SRC_TARGET_DIR)/product/go_defaults_512.mk)
$(call inherit-product, vendor/lineage/config/common_mini_phone.mk)
$(call inherit-product, device/bird/ct07/device.mk)

PRODUCT_NAME := lineage_ct07
PRODUCT_DEVICE := ct07
PRODUCT_BRAND := Ctyon
PRODUCT_MANUFACTURER := Ctyon
PRODUCT_MODEL := CT07
PRODUCT_RELEASE_NAME := ct07

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=lineage_ct07 \
    PRODUCT_DEVICE=ct07 \
    TARGET_DEVICE=ct07

# Launched with Android 6.0; no Treble.
PRODUCT_SHIPPING_API_LEVEL := 23
PRODUCT_FULL_TREBLE_OVERRIDE := false
PRODUCT_GMS_CLIENTID_BASE := android-ctyon

# Dalvik heap: go_defaults_512 sets 128m/256m; the rest follows the
# phone-hdpi-512 profile, except the target utilization, which stays at the
# ART default (0.5) as on Android Go. Set here, in the top product makefile,
# to win.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=5m \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=2m

# Compiled in full: the status bar, the launcher and the input method run all
# the time. The other apps get the quicken filter.
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    MonoLaunch \
    TraditionalT9

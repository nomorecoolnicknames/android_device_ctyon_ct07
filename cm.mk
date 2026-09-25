# LineageOS 14.1 for the Ctyon CT07.

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, vendor/cm/config/common_full_phone.mk)
$(call inherit-product, device/bird/ct07/device.mk)

# 512 MB of RAM
$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)

TARGET_SCREEN_WIDTH := 240
TARGET_SCREEN_HEIGHT := 320

PRODUCT_CHARACTERISTICS := phone

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.low_ram=true \
    ro.sf.lcd_density=120

PRODUCT_NAME := cm_ct07
PRODUCT_DEVICE := ct07
PRODUCT_BRAND := Ctyon
PRODUCT_MANUFACTURER := Ctyon
PRODUCT_MODEL := CT07
PRODUCT_RELEASE_NAME := ct07

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=cm_ct07 \
    PRODUCT_DEVICE=ct07 \
    TARGET_DEVICE=ct07

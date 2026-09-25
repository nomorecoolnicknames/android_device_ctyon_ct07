LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),ct07)

# Modules such as libtinyalsa depend on the kernel headers directory, which
# only an inline kernel build creates.
$(shell mkdir -p $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr)

include $(call first-makefiles-under,$(LOCAL_PATH))

endif

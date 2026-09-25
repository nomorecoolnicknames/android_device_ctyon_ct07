# libshim_ct07_audio: MediaTek voice-unlock statics on android::AudioSystem
# that the stock audio HAL imports. Injected by the linker
# (LINKER_FORCED_SHIM_LIBS in BoardConfig.mk).
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libshim_ct07_audio
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := ctyon
LOCAL_32_BIT_ONLY := true

LOCAL_SRC_FILES := voice_unlock.c

LOCAL_CFLAGS := -Wall -Werror

include $(BUILD_SHARED_LIBRARY)

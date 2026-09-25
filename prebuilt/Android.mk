LOCAL_PATH := $(call my-dir)

# Traditional T9 v64.0 (https://github.com/sspanak/tt9), full flavour with
# the English, Russian and Ukrainian dictionaries, all three enabled until
# the user saves a choice (app/TraditionalT9-enable-bundled-languages.patch),
# and # switching straight to the next language
# (app/TraditionalT9-quick-switch-language-by-default.patch).
include $(CLEAR_VARS)
LOCAL_MODULE := TraditionalT9
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := app/TraditionalT9.apk
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/app/NOTICE
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := testkey
LOCAL_DEX_PREOPT := false
LOCAL_OVERRIDES_PACKAGES := LatinIME
include $(BUILD_PREBUILT)

# Base apps that need a touchscreen, or keep background services running on
# a 512 MB phone.
include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := \
    AudioFX \
    Backgrounds \
    BasicDreams \
    Development \
    EasterEgg \
    Email \
    Exchange2 \
    LineageBlackAccent \
    LineageBlackTheme \
    LineageBlueAccent \
    LineageBrownAccent \
    LineageCyanAccent \
    LineageDarkTheme \
    LineageGreenAccent \
    LineageOrangeAccent \
    LineagePinkAccent \
    LineagePurpleAccent \
    LineageRedAccent \
    LineageSetupWizard \
    LineageYellowAccent \
    LiveWallpapersPicker \
    LockClock \
    PhotoTable \
    Profiles \
    Terminal \
    Updater \
    WeatherProvider
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)

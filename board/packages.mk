# Packages the base products add that this device does not ship. Filtered
# here, in board config, where the full product package list is visible.
#   LatinIME, LineageSetupWizard: touch only (Traditional T9 is the input
#     method; the first-boot defaults skip the wizard).
#   rild: the stock MediaTek mtkrild runs the radio (init.modem.rc); the AOSP
#     ril-daemon would take over its rild socket.
#   The rest: background processes or touch-only features on a 512 MB phone.
CT07_REMOVED_PACKAGES := \
    LatinIME \
    LineageSetupWizard \
    rild \
    Email \
    Exchange2 \
    WeatherProvider \
    WeatherManagerService \
    LockClock \
    LiveWallpapersPicker \
    PhotoTable \
    BasicDreams \
    EasterEgg \
    Updater

PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGES := \
    $(filter-out $(CT07_REMOVED_PACKAGES),$(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGES))

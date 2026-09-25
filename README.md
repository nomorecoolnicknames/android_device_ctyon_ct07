# Device tree for Ctyon CT07

Specs
================================
Basic   | Spec Sheet
-------:|:--------------------------------------------------
CPU     | MediaTek MT6737T (Cortex-A53 1.5GHz)
GPU     | Mali-T720 MP2
Memory  | 512 MB
Screen  | 240x320
Storage | 4 GB
Android | 6.0
Kernel  | 3.18.19
Input   | Hardware keypad (no touchscreen)

# Build instructions
```
repo init -u https://github.com/LineageOS/android.git -b lineage-16.0
mkdir -p .repo/local_manifests
curl -o .repo/local_manifests/ct07.xml https://raw.githubusercontent.com/nomorecoolnicknames/android_device_ctyon_ct07/lineage-16.0/local_manifests/ct07.xml
repo sync -c
bash device/bird/ct07/patches/apply-patches.sh
. build/envsetup.sh
lunch lineage_ct07-userdebug && mka bacon
```

# Acknowledgements

* olexandr1712 (kernel source)
* Dawn-Blossoms (binder backport)
* daniel_hk (MediaTek RIL)
* SahilSonar (vendor/mediatek)
* monobogdan (MonoLaunch)
* sspanak (Traditional T9)
* The Android Open Source Project, LineageOS

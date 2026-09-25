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
repo init -u https://github.com/LineageOS/android.git -b cm-14.1
mkdir -p .repo/local_manifests
curl -o .repo/local_manifests/ct07.xml https://raw.githubusercontent.com/nomorecoolnicknames/android_device_ctyon_ct07/lineage-14.1/local_manifests/ct07.xml
repo sync -c
sed '/^cd packages\/apps\/Settings/,$d' device/meizu/m5c/patches_mtk/apply-patches.sh | bash
bash device/bird/ct07/patches/apply-patches.sh
export LC_ALL=C
. build/envsetup.sh
lunch cm_ct07-userdebug && mka bacon
```

The kernel in prebuilt/kernel is built from
https://github.com/nomorecoolnicknames/android_kernel_ctyon_ct07 (android-3.18).

# Acknowledgements

* olexandr1712 (kernel source)
* Dawn-Blossoms (binder backport)
* mdeejay (MediaTek patches)
* Dekompilyator (Meizu M5c tree)
* monobogdan (MonoLaunch)
* sspanak (Traditional T9)
* The Android Open Source Project, LineageOS

"""OTA script extensions for the Ctyon CT07."""


def FullOTA_InstallEnd(info):
  WipeDalvikCache(info)


def WipeDalvikCache(info):
  # The apps are preopted. When an update leaves an APK and the boot image
  # as they were, ART goes on using the old code in /data/dalvik-cache and
  # ignores the new odex file in /system. Delete the cache as "Wipe
  # Dalvik/ART cache" does; init creates the directory again.
  # /data stays as the recovery left it: mount and unmount it only if it
  # was not mounted. An encrypted /data does not mount and is left alone.
  data = info.info_dict["fstab"]["/data"]
  info.script.Print("Wiping the Dalvik/ART cache...")
  info.script.AppendExtra(
      'ifelse(is_mounted("/data"),\n'
      '  delete_recursive("/data/dalvik-cache"),\n'
      '  (mount("%s", "EMMC", "%s", "/data", "");\n'
      '   ifelse(is_mounted("/data"),\n'
      '     (delete_recursive("/data/dalvik-cache"); unmount("/data")))));'
      % (data.fs_type, data.device))

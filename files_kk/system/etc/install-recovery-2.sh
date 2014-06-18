#!/system/bin/sh

toolbox mount -o rw,remount /system
/system/etc/busybox_fline mount -o rw,remount /system
/system/etc/busybox_fline mount -o ro,remount /system


/system/etc/install-rooting.sh&

# Some apps like to run stuff from this script as well, that will 
# obviously break root - in your code, just search this file
# for "install-recovery-2.sh", and if present, write there instead.

/system/etc/install-recovery-3.sh


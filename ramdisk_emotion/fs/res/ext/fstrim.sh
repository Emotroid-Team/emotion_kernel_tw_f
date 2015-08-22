#!/system/bin/sh

exec 2>&1 > /dev/kmsg

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

fstrim -v /system
fstrim -v /cache
fstrim -v /data

sync

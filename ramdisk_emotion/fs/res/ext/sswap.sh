#!/system/bin/sh


PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH


# Inicio
mount -o remount,rw -t auto /system
mount -t rootfs -o remount,rw rootfs


ZSWAPSIZE=1424




if [ $ZSWAPSIZE -gt 0 ]; then
echo `expr $ZSWAPSIZE \* 1024 \* 1024` > /sys/devices/virtual/block/vnswap0/disksize
/sbin/busybox swapoff /dev/block/vnswap0 > /dev/null 2>&1
/sbin/busybox mkswap /dev/block/vnswap0 > /dev/null 2>&1
/sbin/busybox swapon /dev/block/vnswap0 > /dev/null 2>&1
fi
sync


mount -t rootfs -o remount,ro rootfs
mount -o remount,ro -t auto /system
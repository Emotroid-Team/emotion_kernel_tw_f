#!/system/bin/sh


PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH


# Inicio
mount -o remount,rw -t auto /system
mount -t rootfs -o remount,rw rootfs

SWAPSIZE=1536
PRIORITY=10

if cat /proc/swaps | grep -q vnswap0 ; then
	echo "vnswap is already enabled!"
	exit 1
fi
echo $(($SWAPSIZE * 1048576)) > /sys/block/vnswap0/disksize
mkswap /dev/block/vnswap0
swapon -p $PRIORITY /dev/block/vnswap0
sync

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro -t auto /system
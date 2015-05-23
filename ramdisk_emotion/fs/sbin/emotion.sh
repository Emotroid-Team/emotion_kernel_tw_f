#!/system/bin/sh

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

# Inicio
mount -o remount,rw -t auto /system
mount -t rootfs -o remount,rw rootfs

if [ ! -f /system/xbin/busybox ]; then
rm -rf /system/xbin/busybox
fi

if [ ! -f /system/bin/busybox ]; then
rm -rf /system/bin/busybox
fi

cp -f /sbin/busybox /system/xbin/busybox

/system/xbin/busybox --install -s /system/xbin

ln -s /system/xbin/busybox /system/bin/busybox

sync

#Supersu
/system/xbin/daemonsu --auto-daemon &

sync

#SSWAP to 1.4gb
/res/ext/sswap.sh

# Make internal storage directory
if [ ! -d /data/.emotionkernel ]; then
	mkdir /data/.emotionkernel
fi

# Disable knox
	pm disable com.sec.enterprise.knox.cloudmdm.smdms
	pm disable com.sec.knox.bridge
	pm disable com.sec.enterprise.knox.attestation
	pm disable com.sec.knox.knoxsetupwizardclient
	pm disable com.samsung.knox.rcp.components	
	pm disable com.samsung.android.securitylogagent

# Init.d
if [ ! -d "/system/etc/init.d" ] ; then
mount -o remount,rw -t auto /system
mkdir /system/etc/init.d
chmod 0755 /system/etc/init.d/*
mount -o remount,ro -t auto /system
fi

# frandom permissions
chmod 444 /dev/erandom
chmod 444 /dev/frandom

sync

# kernel custom test
if [ -e /data/emotiontest.log ]; then
	rm /data/emotiontest.log
fi

echo  Kernel script is working !!! >> /data/emotiontest.log
echo "excecuted on $(date +"%d-%m-%Y %r" )" >> /data/emotiontest.log
echo  Done ! >> /data/emotiontest.log


#Set default values on boot
echo "2649600" > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active
echo "883200" > /sys/kernel/cpufreq_hardlimit/touchboost_lo_freq
echo "200000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo "600000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk

sync

#Faux Sound Headphones
if [ ! -f /data/.emotionkernel/gpl_headphone_gain ]; then
	echo "0" > /data/.emotionkernel/gpl_headphone_gain
	echo "1" > /data/.emotionkernel/check
	echo "244" > /data/.emotionkernel/gpl_headphone_pa_gain
fi

#Voltage Control
if [ ! -f /data/.emotionkernel/volt_prof ]; then
	echo "0" > /data/.emotionkernel/volt_prof
fi

#KCal control
if [ ! -f /data/.emotionkernel/kcal_sat ]; then
	echo "32" > /data/.emotionkernel/kcal_sat
	echo "128" > /data/.emotionkernel/kcal_cont
	echo "128" > /data/.emotionkernel/kcal_val
	echo "0" > /data/.emotionkernel/kcal_graychk
fi

#Synapse profile
if [ ! -f /data/.emotionkernel/bck_prof ]; then
	cp -f /res/synapse/files/bck_prof /data/.emotionkernel/bck_prof
	cp -f /res/synapse/files/gammaplaciano_prof /data/.emotionkernel/gammaplaciano_prof
	cp -f /res/synapse/files/gamma_prof /data/.emotionkernel/gamma_prof
	cp -f /res/synapse/files/lmk_prof /data/.emotionkernel/lmk_prof
fi

stop thermal-engine
/system/xbin/busybox run-parts /system/etc/init.d
start thermal-engine

# Synapse
mount -t rootfs -o remount,rw rootfs
ln -fs /res/synapse/uci /sbin/uci
/sbin/uci
mount -t rootfs -o remount,ro rootfs

sync

#Fin
mount -t rootfs -o remount,ro rootfs
mount -o remount,ro -t auto /system
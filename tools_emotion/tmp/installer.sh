#!/sbin/sh
if [ ! -f /data/app/com.af.synapse-*.apk ]
then
    cp /tmp/synapse.apk /data/app/com.af.synapse-1.apk
    chmod 644 /data/app/com.af.synapse-1.apk
fi
rm -f /tmp/synapse.apk

exit 0

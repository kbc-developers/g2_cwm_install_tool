#!/system/bin/sh

echo rooting.sh was called > /data/local/tmp/log.txt
echo id: `id` >> /data/local/tmp/log.txt
chmod 755 /data/local/tmp/log.txt

bb=/data/local/tmp/busybox_file
chmod 755 $bb

echo 1 >> /data/local/tmp/log.txt
#chmod 755 /data/local/tmp/su_server
#chmod 755 /data/local/tmp/su_client

echo start su_server >> /data/local/tmp/log.txt
/data/local/tmp/su_server&

echo end rooting.sh >> /data/local/tmp/log.txt

setenforce 0

@echo off
for /f "tokens=3 delims= " %%a in ('chcp') do set lang=%%a
if "%lang%" == "932" (set doc="%~dp0doc\kk_jp") else (set doc="%~dp0doc\kk_en")
SET adb="%~dp0bin\adb.exe"

mode con:cols=80 lines=40
type %doc%\"01_Thanks.txt"
pause

%adb% shell id
IF %ERRORLEVEL% neq 0 goto device_not_found
echo ---------------------------------------------------------
echo push files
echo ---------------------------------------------------------
%adb% push "%~dp0files_kk" /data/local/tmp
%adb% push "%~dp0files\SuperSu\eu.chainfire.supersu-193.apk" /data/local/tmp/

%adb% shell chmod 755 /data/local/tmp/busybox_file
%adb% shell chmod 755 /data/local/tmp/rooting.sh
%adb% shell chmod 755 /data/local/tmp/su_client
%adb% shell chmod 755 /data/local/tmp/su_server


type %doc%\"05_reboot.txt"
%adb% reboot
echo wait device bootup
%adb% wait-for-device
%adb% shell sleep 10

echo ---------------------------------------------------------
echo remove scan
echo ---------------------------------------------------------
%adb% shell /data/local/tmp/su_client -c "toolbox mount -o remount,rw /system"
%adb% shell /data/local/tmp/su_client -c "/data/local/tmp/busybox_file mount -o rw,remount /system"

%adb% shell /data/local/tmp/su_client -c "rm /system/app/LGDMSClient.odex"
%adb% shell /data/local/tmp/su_client -c "rm /system/app/LGDMSClient.apk"
%adb% shell /data/local/tmp/su_client -c "rm /system/bin/subsystem_ramdump"
%adb% shell /data/local/tmp/su_client -c "rm /system/bin/dumpstate"

%adb% shell /data/local/tmp/su_client -c "rm /system/bin/fssamond"
%adb% shell /data/local/tmp/su_client -c "/data/local/tmp/busybox_file mount -o ro,remount /system"

type %doc%\"05_reboot.txt"
%adb% reboot
echo ---------------------------------------------------------
echo wait rebooot
echo ---------------------------------------------------------
%adb% wait-for-device
%adb% shell sleep 10

:install_supersu
echo ---------------------------------------------------------
echo install supersu
echo ---------------------------------------------------------
%adb% shell /data/local/tmp/su_client -c "toolbox mount -o remount,rw /system"
%adb% shell /data/local/tmp/su_client -c "/data/local/tmp/busybox_file mount -o rw,remount /system"
%adb% shell /data/local/tmp/su_client -c "cp -r /data/local/tmp/system/* /system/"
:: workaround for copy "mount"
%adb% shell /data/local/tmp/su_client -c "cp -f /data/local/tmp/system/bin/mount /system/bin/mount"

%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/bin/mount"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/etc/busybox_file"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/etc/install-recovery.sh"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/etc/install-recovery-2.sh"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/etc/install-rooting.sh"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/etc/init.d/99SuperSUDaemon"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/xbin/daemonsu"
%adb% shell /data/local/tmp/su_client -c "chmod 755 /system/addon.d/99-supersu.sh"

%adb% shell /data/local/tmp/su_client -c "/data/local/tmp/busybox_file mount -o ro,remount /system"
%adb% shell /data/local/tmp/su_client -c "pm install /data/local/tmp/eu.chainfire.supersu-193.apk"

type %doc%\"05_reboot.txt"
%adb% reboot
echo ---------------------------------------------------------
echo wait rebooot
echo ---------------------------------------------------------
%adb% wait-for-device
%adb% shell sleep 10

echo ---------------------------------------------------------
echo wait cleanup
%adb% shell /data/local/tmp/su_client -c "rm -rf /data/local/tmp/system"
%adb% shell /data/local/tmp/su_client -c "rm /data/local/tmp/eu.chainfire.supersu-193.apk"

::==============================================================
:finish
COLOR 07
call :clean
type %doc%\"02_End.txt"
pause
exit /b

::==============================================================
:device_not_found
COLOR 0C
type %doc%\"09_Error_device_not_found.txt"
pause
exit /b

::==============================================================
:adb_push
%adb% push "%~dp0files_kk" /data/local/tmp/
%adb% push "%~dp0files\SuperSu\eu.chainfire.supersu-193.apk" /data/local/tmp/

::IF %ERRORLEVEL% neq 0 exit /b 1
%adb% shell chmod 755 /data/local/tmp/busybox_file
%adb% shell chmod 755 /data/local/tmp/rooting.sh
exit /b

::==============================================================
:clean
exit /b

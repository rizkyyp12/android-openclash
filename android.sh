#!/bin/sh

ADB="/usr/bin/adb"
DELAY=5

echo "[INFO] Waiting for device..."
$ADB wait-for-device

echo "[INFO] Airplane mode ON"
$ADB shell su -c "
settings put global airplane_mode_on 1
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
"

sleep $DELAY

echo "[INFO] Airplane mode OFF"
$ADB shell su -c "
settings put global airplane_mode_on 0
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false
"

echo "[OK] Done"

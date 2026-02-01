#!/bin/sh
# Android Airplane Mode Toggle via ADB (FINAL)

ADB="/usr/bin/adb"
DELAY=5
LOG="/tmp/android_airplane.log"

# ---------- logging ----------
exec >>"$LOG" 2>&1
echo "===== $(date) START ====="

# ---------- ensure adb ----------
if [ ! -x "$ADB" ]; then
    echo "[ERROR] adb not found at $ADB"
    exit 1
fi

# ---------- wait device ----------
echo "[INFO] Waiting for device..."
$ADB wait-for-device || {
    echo "[ERROR] Device not detected"
    exit 1
}

# ---------- ensure adb root ----------
echo "[INFO] Ensuring ADB root..."
$ADB root >/dev/null 2>&1
sleep 2

# verify root
UID="$($ADB shell id 2>/dev/null | grep -o 'uid=0(root)')"
if [ -z "$UID" ]; then
    echo "[ERROR] ADB is not root"
    exit 1
fi
echo "[OK] ADB is root"

# ---------- airplane ON ----------
echo "[INFO] Airplane mode ON"
$ADB shell "/system/bin/settings put global airplane_mode_on 1"
$ADB shell "/system/bin/am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"

sleep "$DELAY"

# ---------- airplane OFF ----------
echo "[INFO] Airplane mode OFF"
$ADB shell "/system/bin/settings put global airplane_mode_on 0"
$ADB shell "/system/bin/am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"

echo "[OK] Done"
echo "===== $(date) END ====="

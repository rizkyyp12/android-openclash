
#!/bin/sh

echo "======================================="
echo " OpenClash + Android Airplane Uninstall"
echo "======================================="

BIN_DIR="/usr/bin"
INIT_DIR="/etc/init.d"

rm -f \
    "$BIN_DIR/oc-direct.sh" \
    "$BIN_DIR/android.sh" \
    "$INIT_DIR/oc-direct" \
    /tmp/oc.log \
    /tmp/oc_state \
    /tmp/android_airplane_active

/etc/init.d/oc-direct disable 2>/dev/null
pkill -f oc-direct.sh 2>/dev/null

echo "UNINSTALLED"

#!/bin/sh

echo "======================================="
echo " OpenClash + Android Airplane Installer"
echo "======================================="

REPO_RAW="https://raw.githubusercontent.com/rizkyyp12/android-openclash/main.py"

BIN_DIR="/usr/bin"
INIT_DIR="/etc/init.d"

OC_SCRIPT="$BIN_DIR/oc-direct.sh"
ANDROID_SCRIPT="$BIN_DIR/android.py"
INIT_SCRIPT="$INIT_DIR/oc-direct"

# --- ROOT CHECK ---
[ "$(id -u)" -ne 0 ] && {
    echo "ERROR: run as root"
    exit 1
}

echo "[+] Downloading scripts..."

wget -qO "$OC_SCRIPT"      "$REPO_RAW/oc-direct.sh"   || exit 1
wget -qO "$ANDROID_SCRIPT" "$REPO_RAW/android.py"     || exit 1

chmod +x "$OC_SCRIPT" "$ANDROID_SCRIPT"

echo "[+] Creating init.d service..."

cat << 'EOF' > "$INIT_SCRIPT"
#!/bin/sh /etc/rc.common
START=99
STOP=10

start() {
    /usr/bin/oc-direct.sh &
}

stop() {
    pkill -f oc-direct.sh
}
EOF

chmod +x "$INIT_SCRIPT"

/etc/init.d/oc-direct enable
/etc/init.d/oc-direct start

echo "======================================="
echo " INSTALLATION COMPLETE"
echo "======================================="

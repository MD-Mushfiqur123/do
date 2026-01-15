#!/bin/bash
# =========================================
# Mushfiqur OS – Full System Rebrand Script
# antiX / Debian based
# =========================================

set -e

NEW_NAME="Mushfiqur OS"
SHORT="MushOS"
VERSION="1.0"
ID="mushfiquros"
HOST="mushfiqur-os"

echo "[+] Starting FULL rebrand to $NEW_NAME"

# -------------------------
# Core OS identity
# -------------------------
cat > /etc/os-release <<EOF
NAME="$NEW_NAME"
PRETTY_NAME="$NEW_NAME $VERSION"
VERSION="$VERSION"
VERSION_ID="$VERSION"
ID=$ID
ID_LIKE=debian
EOF

cat > /etc/lsb-release <<EOF
DISTRIB_ID=$SHORT
DISTRIB_RELEASE=$VERSION
DISTRIB_DESCRIPTION="$NEW_NAME $VERSION"
EOF

echo "$NEW_NAME \\n \\l" > /etc/issue
echo "$NEW_NAME" > /etc/issue.net

# -------------------------
# Hostname
# -------------------------
echo "$HOST" > /etc/hostname
hostname "$HOST"

sed -i "s/antix/$HOST/gI" /etc/hosts || true
sed -i "s/debian/$HOST/gI" /etc/hosts || true

# -------------------------
# GRUB branding
# -------------------------
if [ -f /etc/default/grub ]; then
    sed -i 's/antiX/Mushfiqur OS/gI' /etc/default/grub
    sed -i 's/Debian/Mushfiqur OS/gI' /etc/default/grub
    update-grub || true
fi

# -------------------------
# LOGIN / MOTD
# -------------------------
echo "Welcome to $NEW_NAME" > /etc/motd

# -------------------------
# MASS TEXT REPLACE (safe paths)
# -------------------------
for dir in /etc /usr/share; do
  grep -rl "antiX" $dir 2>/dev/null | xargs sed -i 's/antiX/Mushfiqur OS/gI' || true
  grep -rl "Debian" $dir 2>/dev/null | xargs sed -i 's/Debian/Mushfiqur OS/gI' || true
done

# -------------------------
# WALLPAPER + BACKGROUND WIPE
# -------------------------
echo "[+] Deleting wallpapers and backgrounds"

rm -rf /usr/share/backgrounds/*
rm -rf /usr/share/wallpapers/*
rm -rf /usr/share/images/desktop-base/*
rm -rf /usr/share/antiX-wallpapers* 2>/dev/null || true
rm -rf /usr/share/pixmaps/*wall* 2>/dev/null || true

# -------------------------
# THEMES (optional but clean)
# -------------------------
rm -rf /usr/share/themes/antiX* 2>/dev/null || true
rm -rf /usr/share/icons/antiX* 2>/dev/null || true

# -------------------------
# Neofetch / screenfetch
# -------------------------
if [ -d /etc/neofetch ]; then
  sed -i 's/antiX/Mushfiqur OS/gI' /etc/neofetch/* || true
fi

# -------------------------
# Cleanup
# -------------------------
apt clean || true

echo "[✓] FULL SYSTEM REBRAND COMPLETE"
echo "[✓] All wallpapers deleted"
echo "[!] REBOOT REQUIRED"

#!/bin/bash
# Mushfiqur OS – Direct Boot Mode (Safe)

set -e

if [[ $EUID -ne 0 ]]; then
  echo "Run as root"
  exit 1
fi

echo "[+] Configuring instant direct boot..."

GRUB_FILE="/etc/default/grub"

cp $GRUB_FILE $GRUB_FILE.bak

sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' $GRUB_FILE
sed -i 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' $GRUB_FILE
sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Mushfiqur OS"/' $GRUB_FILE

grep -q "GRUB_DISABLE_OS_PROBER" $GRUB_FILE || \
echo 'GRUB_DISABLE_OS_PROBER=true' >> $GRUB_FILE

update-grub

echo "[✓] Direct boot enabled"
echo "Reboot to test"

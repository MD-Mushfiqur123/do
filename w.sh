#!/bin/bash
# =====================================================
# Mushfiqur OS Full System Transformation Script
# Base: antiX / Debian
# Author: Mushfiqur
# =====================================================

set -e

OS_NAME="Mushfiqur OS"
OS_VERSION="1.0"
AUTHOR="Mushfiqur"

GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

echo -e "${CYAN}"
echo "=========================================="
echo "     Welcome to Mushfiqur OS Builder"
echo "=========================================="
echo -e "${RESET}"

sleep 2

# -----------------------------------------------------
# Root Check
# -----------------------------------------------------
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Please run as root${RESET}"
   exit 1
fi

# -----------------------------------------------------
# Update System
# -----------------------------------------------------
echo -e "${GREEN}[+] Updating system...${RESET}"
apt update -y && apt upgrade -y

# -----------------------------------------------------
# Remove antiX branding
# -----------------------------------------------------
echo -e "${GREEN}[+] Removing antiX branding...${RESET}"
rm -rf /usr/share/antiX 2>/dev/null
rm -rf /etc/antix 2>/dev/null

# -----------------------------------------------------
# OS Release Change
# -----------------------------------------------------
echo -e "${GREEN}[+] Changing OS release info...${RESET}"

cat > /etc/os-release <<EOF
NAME="$OS_NAME"
VERSION="$OS_VERSION"
ID=mushfiqur
PRETTY_NAME="$OS_NAME $OS_VERSION"
HOME_URL="https://mushfiqur-os.local"
SUPPORT_URL="https://mushfiqur-os.local/support"
BUG_REPORT_URL="https://mushfiqur-os.local/bugs"
EOF

# -----------------------------------------------------
# Login Banner
# -----------------------------------------------------
echo -e "${GREEN}[+] Setting login banner...${RESET}"

cat > /etc/issue <<EOF
███████╗██╗   ██╗███████╗██╗  ██╗███████╗██╗ ██████╗ ██╗   ██╗██████╗ 
██╔════╝██║   ██║██╔════╝██║  ██║██╔════╝██║██╔═══██╗██║   ██║██╔══██╗
█████╗  ██║   ██║███████╗███████║█████╗  ██║██║   ██║██║   ██║██████╔╝
██╔══╝  ██║   ██║╚════██║██╔══██║██╔══╝  ██║██║   ██║██║   ██║██╔══██╗
██║     ╚██████╔╝███████║██║  ██║███████╗██║╚██████╔╝╚██████╔╝██║  ██║
╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝

Welcome to Mushfiqur OS
EOF

# -----------------------------------------------------
# MOTD
# -----------------------------------------------------
echo -e "${GREEN}[+] Setting MOTD...${RESET}"

cat > /etc/motd <<EOF
====================================
   Welcome to Mushfiqur OS
   Build by: $AUTHOR
====================================
EOF

# -----------------------------------------------------
# Wallpapers
# -----------------------------------------------------
echo -e "${GREEN}[+] Cleaning old wallpapers...${RESET}"
rm -rf /usr/share/backgrounds/*

mkdir -p /usr/share/backgrounds/mushfiqur

# Placeholder wallpaper
convert -size 1920x1080 xc:black /usr/share/backgrounds/mushfiqur/default.png

# -----------------------------------------------------
# Install UI packages
# -----------------------------------------------------
echo -e "${GREEN}[+] Installing UI packages...${RESET}"
apt install -y picom neofetch feh plymouth plymouth-themes \
lxappearance papirus-icon-theme fonts-firacode

# -----------------------------------------------------
# Picom config (smooth animation)
# -----------------------------------------------------
echo -e "${GREEN}[+] Configuring animations...${RESET}"

mkdir -p /etc/xdg/picom

cat > /etc/xdg/picom/picom.conf <<EOF
backend = "glx";
vsync = true;
corner-radius = 10;
rounded-corners-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'"
];
shadow = true;
shadow-radius = 12;
shadow-opacity = 0.4;
animations = true;
animation-stiffness = 300;
animation-dampening = 35;
animation-clamping = true;
EOF

# -----------------------------------------------------
# Plymouth Boot Theme
# -----------------------------------------------------
echo -e "${GREEN}[+] Setting boot animation...${RESET}"

mkdir -p /usr/share/plymouth/themes/mushfiqur

cat > /usr/share/plymouth/themes/mushfiqur/mushfiqur.plymouth <<EOF
[Plymouth Theme]
Name=Mushfiqur OS
Description=Custom Boot Theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/mushfiqur
ScriptFile=/usr/share/plymouth/themes/mushfiqur/mushfiqur.script
EOF

update-alternatives --set default.plymouth /usr/share/plymouth/themes/mushfiqur/mushfiqur.plymouth || true
update-initramfs -u

# -----------------------------------------------------
# Neofetch Custom
# -----------------------------------------------------
echo -e "${GREEN}[+] Configuring neofetch...${RESET}"

mkdir -p /etc/neofetch

cat > /etc/neofetch/config.conf <<EOF
ascii_distro="Mushfiqur"
distro_shorthand="on"
colors=(6 6 6 6 6 6)
EOF

# -----------------------------------------------------
# Terminal Animation
# -----------------------------------------------------
echo -e "${GREEN}[+] Adding terminal animation...${RESET}"

cat >> /etc/bash.bashrc <<'EOF'

echo -e "\e[36mLoading Mushfiqur OS...\e[0m"
sleep 0.3
echo -e "\e[32mSystem Ready ✔\e[0m"

EOF

# -----------------------------------------------------
# Cleanup
# -----------------------------------------------------
echo -e "${GREEN}[+] Cleaning system...${RESET}"
apt autoremove -y
apt clean

# -----------------------------------------------------
# Finish
# -----------------------------------------------------
echo -e "${BLUE}"
echo "======================================"
echo " Mushfiqur OS Installed Successfully "
echo " Please Reboot Your System "
echo "======================================"
echo -e "${RESET}"

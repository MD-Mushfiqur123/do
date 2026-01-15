#!/bin/bash

# =====================================================================
# NAME: Mushfiqur OS Build Script
# VERSION: 1.0
# AUTHOR: Mushfiqur (Professional Developer)
# DESCRIPTION: Converts a standard Linux base into Mushfiqur OS
# =====================================================================

# --- ১. প্রাথমিক সুরক্ষা ও রুট চেক ---
if [[ $EUID -ne 0 ]]; then
   echo "Error: এই স্ক্রিপ্টটি অবশ্যই sudo দিয়ে রান করতে হবে!"
   exit 1
fi

clear
echo "-------------------------------------------------------"
echo "        WELCOME TO MUSHFIQUR OS BUILDER v1.0           "
echo "-------------------------------------------------------"
echo "Starting the transformation in 3 seconds..."
sleep 3

# --- ২. সিস্টেম ভেরিয়েবল সেট করা ---
OS_NAME="Mushfiqur OS"
OS_ID="mushfiqur-os"
VERSION="2026.01"
DEVELOPER="Mushfiqur"

# --- ৩. হোস্টনেম এবং নেটওয়ার্ক কাস্টমাইজেশন ---
echo "[1/10] Setting System Identity..."
echo "$OS_ID" > /etc/hostname
sed -i "s/antix/$OS_ID/gI" /etc/hosts
sed -i "s/debian/$OS_ID/gI" /etc/hosts
hostnamectl set-hostname $OS_ID

# --- ৪. সিস্টেম ইনফরমেশন এবং রিলিজ ফাইল ---
echo "[2/10] Branding System Release Files..."
cat << EOF > /etc/os-release
NAME="$OS_NAME"
VERSION="$VERSION"
ID=$OS_ID
ID_LIKE=debian
PRETTY_NAME="$OS_NAME $VERSION"
VERSION_ID="$VERSION"
HOME_URL="https://github.com/Mushfiqur"
SUPPORT_URL="https://github.com/Mushfiqur"
BUG_REPORT_URL="https://github.com/Mushfiqur"
EOF

cp /etc/os-release /usr/lib/os-release
echo "$OS_NAME $VERSION \n \l" > /etc/issue
echo "$OS_NAME $VERSION \n \l" > /etc/issue.net

# --- ৫. বুটলোডার (GRUB) আলটিমেট কাস্টমাইজেশন ---
echo "[3/10] Configuring Direct Boot (Hard Disk Priority)..."
# GRUB মেনু পুরোপুরি হাইড করা এবং টাইমআউট ০ করা
sed -i 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' /etc/default/grub
sed -i 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Mushfiqur OS"/' /etc/default/grub
echo 'GRUB_DISABLE_OS_PROBER=true' >> /etc/default/grub
echo 'GRUB_RECORDFAIL_TIMEOUT=0' >> /etc/default/grub
update-grub

# --- ৬. গ্রাফিক্স এবং ওয়ালপেপার ক্লিনআপ ---
echo "[4/10] Wiping Default Aesthetics..."
# সব পুরনো ওয়ালপেপার ডিলিট করা
DIRS=("/usr/share/wallpaper" "/usr/share/backgrounds" "/usr/share/antix/wallpaper")
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        rm -rf "$dir"/*
    fi
done

# নিজের জন্য একটি ওয়ালপেপার ফোল্ডার তৈরি
mkdir -p /usr/share/wallpaper/mushfiqur-os/
touch /usr/share/wallpaper/mushfiqur-os/PLACE_YOUR_WALLPAPER_HERE

# --- ৭. টার্মিনাল আর্ট (The Famous ASCII Banner) ---
echo "[5/10] Creating Terminal Masterpiece..."
cat << "EOF" > /etc/motd
   __  __           _     __ _                         ____   _____ 
  |  \/  |_   _ ___| |__ / _(_) __ _ _   _ _ __       / __ \ / ____|
  | |\/| | | | / __| '_ \ |_| |/ _` | | | | '__|     | |  | | (___  
  | |  | | |_| \__ \ | | |  _| | (_| | |_| | |        | |__| |\___ \ 
  |_|  |_|\__,_|___/_| |_|_| |_|\__, |\__,_|_|         \____/|_____/ 
                                 |_|                                
=====================================================================
  SYSTEM: Mushfiqur OS (Professional Dev Edition)
  KERNEL: $(uname -r)
  OWNER:  Mushfiqur
=====================================================================
EOF

# --- ৮. সিস্টেম শাটডাউন এবং রিবুট স্ক্রিপ্ট ব্র্যান্ডিং ---
echo "[6/10] Customizing Core Commands..."
cat << EOF > /usr/local/bin/mush-info
#!/bin/bash
echo "Operating System: $OS_NAME"
echo "Version: $VERSION"
echo "Developer: $DEVELOPER"
echo "Status: Active & Optimized"
EOF
chmod +x /usr/local/bin/mush-info

# --- ৯. ব্লোটওয়্যার এবং ক্যাশ রিমুভাল ---
echo "[7/10] Optimizing System Performance..."
apt-get autoremove -y
apt-get clean
find /var/log -type f -delete
rm -rf /root/.cache/*
rm -rf /home/*/.cache/*

# --- ১০. ডেস্কটপ এনভায়রনমেন্ট রি-ব্র্যান্ডিং (IceWM/Fluxbox) ---
echo "[8/10] Tweaking Window Manager Labels..."
# মেনুতে থাকা antiX নাম সরিয়ে Mushfiqur OS করা
find /usr/share/applications/ -name "*.desktop" -exec sed -i "s/antiX/$OS_NAME/g" {} +
find /etc/skel/ -type f -exec sed -i "s/antiX/$OS_NAME/g" {} +

# --- ১১. হার্ডডিস্ক বুট এনফোর্সমেন্ট ---
echo "[9/10] Enforcing Hard Disk Priority..."
if [ -d "/sys/firmware/efi" ]; then
    # EFI বুট অর্ডার ফিক্স করা (যদি efibootmgr থাকে)
    if command -v efibootmgr >/dev/null; then
        efibootmgr -t 0
    fi
fi

# --- ১২. ফাইনাল পলিশিং এবং সমাপ্তি ---
echo "[10/10] Finalizing Mushfiqur OS..."
sync
echo "-------------------------------------------------------"
echo "   CONGRATULATIONS! MUSHFIQUR OS IS NOW INSTALLED      "
echo "-------------------------------------------------------"
echo "System will reboot to apply all changes in 10 seconds."
echo "Press Ctrl+C to cancel reboot."

sleep 10
echo "Rebooting..."
reboot

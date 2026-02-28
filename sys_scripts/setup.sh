#!/bin/bash

set -e  # Stop script in case of error

echo "===================================================="
echo "      ObscuraHomeStack - Ubuntu Server OS Based"
echo "===================================================="

# -------------------------
# System Update && Upgrade
# -------------------------
echo -e "\n🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# -------------------------
# Dpkg install + Docker-compose
# -------------------------
echo -e "\n📦 Installing essential packages..."
sudo apt install -y \
  nmap python3 python3-pip python3-venv curl tcpdump lynx \
  openssh-server fail2ban gnome-terminal rclone rsync arp-scan \
  speedtest-cli gparted zram-tools tlp tlp-rdw ca-certificates \
  gnupg lsb-release clamav clamav-daemon docker.io docker-compose git

docker-compose --version

# -------------------------
# Containers folder config
# -------------------------
echo -e "\n📁 Creating container folders..."
mkdir -p /home/$USER/ObscuraHomeStack/containers/nextcloud/{config,data,db} \
         /home/$USER/ObscuraHomeStack/containers/qbittorrent/{config,downloads} \
         /home/$USER/ObscuraHomeStack/containers/homeassistant/config \
         /home/$USER/ObscuraHomeStack/containers/minecraft-bedrock \
         /home/$USER/ObscuraHomeStack/containers/kavita/{config,books} \
         /home/$USER/ObscuraHomeStack/containers/kavita/books/all_books \
         /home/$USER/ObscuraHomeStack/containers/mosquitto/{config,data,log} \
         /home/$USER/ObscuraHomeStack/containers/zigbee2mqtt \
         /home/$USER/ObscuraHomeStack/containers/adguardhome/{conf,work} \
         /home/$USER/ObscuraHomeStack/containers/navidrome/{data,music} \

# -------------------------
# Creazione Python virtual env
# -------------------------
echo -e "\n🐍 Setting up Python virtual environment..."

cd /home/$USER/ObscuraHomeStack

if [ ! -d "pyvenv" ]; then
  python3 -m venv pyvenv
fi

source pyvenv/bin/activate

if [ -f "/home/$USER/ObscuraHomeStack/py_scripts/requirements.txt" ]; then
  pip install -r py_scripts/requirements.txt
else
  echo "Warning: requirements.txt not found, moving to the next step."
fi

# -------------------------
# Firewall Configuration
# -------------------------
echo -e "\n Configuring UFW firewall..."
chmod +x py_scripts/firewall.py
sudo python3 py_scripts/firewall.py

deactivate  # py virtual env deactivation
cd ~

# -------------------------
# Activating SSH
# -------------------------
echo -e "\n Activating SSH..."
sudo systemctl enable --now ssh

# -------------------------
# Activating Fail2Ban
# -------------------------
echo -e "\n Enabling Fail2Ban for SSH..."
sudo systemctl enable --now fail2ban

# -------------------------
# Activating ZRAM
# -------------------------
echo -e "\n Activating ZRAM..."
sudo systemctl enable --now zramswap.service

# -------------------------
# Activating TLP (Energy saving)
# -------------------------
echo -e "\n Activating TLP..."
sudo systemctl enable --now tlp.service

# -------------------------
# Activating & database update ClamAV -- Antivirus
# -------------------------
echo -e "\n Activating ClamAV Antivirus..."
sudo systemctl enable --now clamav-daemon
sudo freshclam

# -------------------------
echo -e "\n Setup completed! Let's go!"
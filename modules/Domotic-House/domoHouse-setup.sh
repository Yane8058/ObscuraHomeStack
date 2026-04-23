#!/bin/bash

set -e

echo "================================================================================"
echo "      ObscuraHomeStack - Ubuntu Server OS Based - Domotic House Module"
echo "================================================================================"

# -------------------------
# System Update && Upgrade
# -------------------------

echo -e "\n🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo -e "\n📁 Creating container folders..."

BASE_PATH="/home/$USER/ObscuraHomeStack/containers"

mkdir -p "$BASE_PATH/homeassistant/config"
mkdir -p "$BASE_PATH/mosquitto/{config,data,log}"
mkdir -p "$BASE_PATH/zigbee2mqtt"

chown -R 1000:1000 $BASE_PATH/{homeassistant,mosquitto,zigbee2mqtt}
chmod -R 755 $BASE_PATH/{homeassistant,mosquitto,zigbee2mqtt}
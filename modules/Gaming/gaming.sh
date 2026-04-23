#!/bin/bash

set -e

echo "================================================================================"
echo "      ObscuraHomeStack - Ubuntu Server OS Based - Gaming Module"
echo "================================================================================"

# -------------------------
# System Update && Upgrade
# -------------------------

echo -e "\n🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo -e "\n📁 Creating container folders..."

BASE_PATH="/home/$USER/ObscuraHomeStack/containers"

mkdir -p "$BASE_PATH/minecraft-bedrock"

chown -R 1000:1000 $BASE_PATH//minecraft-bedrock
chmod -R 755 $BASE_PATH//minecraft-bedrock
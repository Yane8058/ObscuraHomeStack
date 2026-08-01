#!/bin/bash

set -euo pipefail

echo "================================================================================"
echo "      ObscuraHomeStack - Ubuntu Server OS Based - ChangeDetection.io Module"
echo "================================================================================"

# -------------------------
# System Update && Upgrade
# -------------------------

echo -e "\n🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo -e "\n📁 Creating container folders..."

BASE_PATH="$HOME/ObscuraHomeStack/containers"
CH_DET_PATH="$BASE_PATH/changedetection"

mkdir -p "$CH_DET_PATH/config"

sudo chown -R 1000:1000 "$CH_DET_PATH"
sudo chmod -R 755 "$CH_DET_PATH"

echo -e "\n✅ Done. Folders ready at: $CH_DET_PATH"
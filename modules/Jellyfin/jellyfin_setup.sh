#!/bin/bash
set -e

echo "====================================================================="
echo "      ObscuraHomeStack - Ubuntu Server OS Based - Jellyfin Module"
echo "====================================================================="

# -------------------------
# System Update && Upgrade
# -------------------------
echo -e "\n🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# -------------------------
# Containers folder config
# -------------------------
echo -e "\n📁 Creating Jellyfin directories..."

BASE_PATH="/home/$USER/ObscuraHomeStack/containers"

mkdir -p "$BASE_PATH/jellyfin/library"
mkdir -p "$BASE_PATH/jellyfin/tvshows"
mkdir -p "$BASE_PATH/jellyfin/movies"

chown -R 1000:1000 $BASE_PATH/jellyfin
chmod -R 755 $BASE_PATH/jellyfin

echo -e "\n✅ Jellyfin environment ready!"
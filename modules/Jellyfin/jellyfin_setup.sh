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

echo "✅ Directories created:"
echo "   - $BASE_PATH/jellyfin/library"
echo "   - $BASE_PATH/jellyfin/tvshows"
echo "   - $BASE_PATH/jellyfin/movies"

echo -e "\n✅ Jellyfin environment ready!"
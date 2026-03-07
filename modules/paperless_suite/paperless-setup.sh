#!/bin/bash

set -e  # Stop script in case of error

echo "============================================================================="
echo "      ObscuraHomeStack - Ubuntu Server OS Based - Paperless Module Setup     "
echo "============================================================================="

# ======= MODULE: Paperless Suite ======= #
BASE_PATH="/home/$USER/ObscuraHomeStack/containers"

mkdir -p \
  $BASE_PATH/paperless/data \
  $BASE_PATH/paperless/media \
  $BASE_PATH/paperless/consume \
  $BASE_PATH/paperless/export \
  $BASE_PATH/paperless/redis \
  $BASE_PATH/paperless/ollama \
  $BASE_PATH/paperless/paperless-ai \
  $BASE_PATH/paperless/paperless-gpt/prompts

chown -R 1000:1000 $BASE_PATH/paperless
chmod -R 755 $BASE_PATH/paperless

echo "     Setup Done    "
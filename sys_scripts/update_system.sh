#!/bin/bash

# Ubuntu Update e logs

LOG_FILE="logs/system_updates.log"

echo "🔁 $(date): Updating system..." | tee -a $LOG_FILE

sudo apt update && sudo apt upgrade -y | tee -a $LOG_FILE

echo "✅ $(date): system updated !" | tee -a $LOG_FILE

#!/data/data/com.termux/files/usr/bin/bash

LOG_DIR="$HOME/.solukos/logs"

mkdir -p "$LOG_DIR"

log()
{
    DATE=$(date +"%Y-%m-%d %H:%M:%S")

    echo "[$DATE] $1" >> "$LOG_DIR/system.log"
}

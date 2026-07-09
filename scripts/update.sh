#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

LOG_FILE="$HOME/.solukos/logs/update.log"
VERSION_FILE="$BASE_DIR/VERSION"

mkdir -p "$(dirname "$LOG_FILE")"

if [ -z "$BASE_DIR" ]; then
    echo "[!] SolukOS path not found."
    exit 1
fi

if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE")
else
    VERSION="unknown"
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update started (v$VERSION)" >> "$LOG_FILE"

clear

echo "=============================="
echo "      Updating SolukOS"
echo "=============================="
echo ""

echo "Current version: v$VERSION"
echo ""

cd "$BASE_DIR" || exit 1

echo "[*] Checking updates..."

git pull

if [ $? -eq 0 ]; then
    echo ""
    echo "[+] Update completed."

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update completed successfully (v$VERSION)" >> "$LOG_FILE"
else
    echo ""
    echo "[!] Update failed."

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update failed" >> "$LOG_FILE"
fi

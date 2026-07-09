#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

LOG_FILE="$HOME/.solukos/logs/update.log"
VERSION_FILE="$BASE_DIR/VERSION"

mkdir -p "$(dirname "$LOG_FILE")"

if [ -z "$BASE_DIR" ]; then
    echo "[!] SolukOS path not found."
    exit 1
fi

clear

echo "=============================="
echo "      SolukOS Update"
echo "=============================="
echo ""

if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE")
else
    VERSION="unknown"
fi

echo "Current version: v$VERSION"
echo ""

echo "[1/3] Updating Termux packages..."
pkg update -y
pkg upgrade -y

echo ""
echo "[2/3] Updating SolukOS..."

cd "$BASE_DIR" || exit 1

git pull

echo ""
echo "[3/3] Checking SolukOS packages..."

if [ -f "$BASE_DIR/packages/database.txt" ]; then
    echo "[✓] Package database OK"
else
    echo "[!] Package database missing"
fi

echo ""

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update completed" >> "$LOG_FILE"

echo "=============================="
echo " Update completed."
echo "=============================="

#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$1"

LOG_FILE="$HOME/.solukos/logs/update.log"
VERSION_FILE="$BASE_DIR/VERSION"

mkdir -p "$(dirname "$LOG_FILE")"

if [ -z "$BASE_DIR" ]; then
    echo "[!] SolukOS path not found."
    exit 1
fi

source "$BASE_DIR/scripts/lib/ui.sh"

if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE")
else
    VERSION="unknown"
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update started (v$VERSION)" >> "$LOG_FILE"

clear
soluk_header "Updating SolukOS"

echo "Current version: v$VERSION"
echo ""

cd "$BASE_DIR" || exit 1

echo "[*] Checking updates..."

git pull

if [ $? -eq 0 ]; then
    echo ""
    echo "[*] Refreshing soluk command..."

    if [ -f "$BASE_DIR/bin/soluk" ]; then
        cp "$BASE_DIR/bin/soluk" /data/data/com.termux/files/usr/bin/soluk
        chmod +x /data/data/com.termux/files/usr/bin/soluk
    fi

    chmod +x "$BASE_DIR"/scripts/*.sh 2>/dev/null
    chmod +x "$BASE_DIR"/scripts/lib/*.sh 2>/dev/null
    chmod +x "$BASE_DIR"/scripts/settings/*.sh 2>/dev/null
    chmod +x "$BASE_DIR"/scripts/package/*.sh 2>/dev/null
    chmod +x "$BASE_DIR"/plugins/*/plugin.sh 2>/dev/null
    chmod +x "$BASE_DIR"/plugins/installed/*/plugin.sh 2>/dev/null

    soluk_ok "soluk command refreshed."

    NEW_VERSION=$(cat "$VERSION_FILE" 2>/dev/null)

    echo ""
    soluk_ok "Update completed (v$NEW_VERSION)."

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update completed successfully (v$NEW_VERSION)" >> "$LOG_FILE"
else
    echo ""
    soluk_warn "Update failed."

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update failed" >> "$LOG_FILE"
fi

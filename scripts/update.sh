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
[ -f "$BASE_DIR/scripts/lib/update_check.sh" ] && source "$BASE_DIR/scripts/lib/update_check.sh"

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

if command -v soluk_fetch_remote_version >/dev/null 2>&1; then
    soluk_info "Checking for a newer version..."
    NEW_VERSION=$(soluk_fetch_remote_version "$BASE_DIR")

    if [ -n "$NEW_VERSION" ] && [ "$NEW_VERSION" != "$VERSION" ]; then
        soluk_ok "Update available: v$NEW_VERSION"
    else
        soluk_info "Already on the latest version (or the check couldn't reach GitHub)."
    fi
    echo ""
fi

cd "$BASE_DIR" || exit 1

echo "[*] Pulling latest changes..."

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
    chmod +x "$BASE_DIR"/plugins/disabled/*/plugin.sh 2>/dev/null

    soluk_ok "soluk command refreshed."

    if [ -f "$BASE_DIR/config/zshrc" ] && ! diff -q "$BASE_DIR/config/zshrc" "$HOME/.zshrc" >/dev/null 2>&1; then
        mkdir -p "$HOME/.solukos/backups"
        cp "$HOME/.zshrc" "$HOME/.solukos/backups/zshrc-pre-update-$(date +%Y-%m-%d_%H-%M-%S)" 2>/dev/null
        cp "$BASE_DIR/config/zshrc" "$HOME/.zshrc"
        soluk_ok "Zsh config refreshed (old one backed up)."
    fi

    FINAL_VERSION=$(cat "$VERSION_FILE" 2>/dev/null)

    echo ""
    soluk_ok "Update completed (v$FINAL_VERSION)."

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update completed successfully (v$FINAL_VERSION)" >> "$LOG_FILE"
else
    echo ""
    soluk_warn "Update failed."

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Update failed" >> "$LOG_FILE"
fi

#!/usr/bin/env bash

BASE_DIR="$1"
SOLUK_DIR="$HOME/.solukos"

source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "Reset Config"

echo "This will reset SolukOS settings."
echo ""

read -p "Create backup first? (y/n): " BACKUP

if [ "$BACKUP" = "y" ]; then
    if [ -f "$BASE_DIR/scripts/backup.sh" ]; then
        bash "$BASE_DIR/scripts/backup.sh" "$BASE_DIR"
    else
        soluk_warn "Backup script not found."
    fi
fi

echo ""

read -p "Continue reset? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

# Reset theme (write + actually re-apply the colors, not just the file)
mkdir -p "$SOLUK_DIR"
echo "soluk" > "$SOLUK_DIR/theme"
bash "$BASE_DIR/scripts/theme.sh"
soluk_ok "Theme reset to Soluk (default)"

# Reset banner
if [ -f "$BASE_DIR/assets/banner.txt" ]; then
    cp "$BASE_DIR/assets/banner.txt" "$SOLUK_DIR/banner.txt"
    soluk_ok "Banner restored"
else
    soluk_warn "Original banner not found"
fi

echo ""
soluk_ok "Config reset completed."

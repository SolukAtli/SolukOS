#!/data/data/com.termux/files/usr/bin/bash

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

# Reset theme
mkdir -p "$SOLUK_DIR"
echo "default" > "$SOLUK_DIR/theme"

# Reset banner
if [ -f "$BASE_DIR/assets/banner.txt" ]; then
    cp "$BASE_DIR/assets/banner.txt" "$SOLUK_DIR/banner.txt"
    soluk_ok "Banner restored"
else
    soluk_warn "Original banner not found"
fi

echo ""
soluk_ok "Config reset completed."

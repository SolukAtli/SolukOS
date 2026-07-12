#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
LOG_FILE="$HOME/.solukos/logs/backup.log"

mkdir -p "$(dirname "$LOG_FILE")"

source "$BASE_DIR/scripts/lib/ui.sh"

BACKUP_DIR="$HOME/.solukos/backups"

clear
soluk_header "SolukOS Restore"

if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    soluk_warn "No backups found."
    exit 1
fi

echo "Available backups:"
echo ""

select BACKUP in "$BACKUP_DIR"/*; do
    if [ -n "$BACKUP" ]; then
        break
    fi
done

if [ ! -d "$BACKUP" ]; then
    soluk_warn "Invalid backup."
    exit 1
fi

BACKUP_NAME=$(basename "$BACKUP")

echo ""
soluk_row "Selected" "$BACKUP_NAME"
echo ""

read -p "Continue restore? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""

if [ -f "$BACKUP/zshrc" ]; then
    cp "$BACKUP/zshrc" "$HOME/.zshrc"
    soluk_ok "Zsh restored"
fi

if [ -f "$BACKUP/banner.txt" ]; then
    cp "$BACKUP/banner.txt" "$HOME/.solukos/banner.txt"
    soluk_ok "Banner restored"
fi

if [ -f "$BACKUP/version" ]; then
    cp "$BACKUP/version" "$HOME/.solukos/version"
    soluk_ok "Version restored"
fi

echo ""
soluk_ok "Restore completed."

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Restore completed: $BACKUP_NAME" >> "$LOG_FILE"

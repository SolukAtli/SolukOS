#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
BACKUP_DIR="$HOME/.solukos/backups"
LOG_FILE="$HOME/.solukos/logs/backup.log"

source "$BASE_DIR/scripts/lib/ui.sh"

mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH="$BACKUP_DIR/backup-$DATE"

mkdir -p "$BACKUP_PATH"

cp "$HOME/.zshrc" "$BACKUP_PATH/zshrc" 2>/dev/null
cp "$HOME/.solukos/banner.txt" "$BACKUP_PATH/banner.txt" 2>/dev/null
cp "$HOME/.solukos/theme" "$BACKUP_PATH/theme" 2>/dev/null
cp "$HOME/.solukos/version" "$BACKUP_PATH/version" 2>/dev/null

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup created: $BACKUP_PATH" >> "$LOG_FILE"

clear
soluk_header "Backup Complete"

soluk_ok "Backup created"
soluk_row "Location" "$BACKUP_PATH"
echo ""

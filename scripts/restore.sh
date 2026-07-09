#!/data/data/com.termux/files/usr/bin/bash

LOG_FILE="$HOME/.solukos/logs/backup.log"

mkdir -p "$(dirname "$LOG_FILE")"

BACKUP_DIR="$HOME/.solukos/backups"

clear

echo "=============================="
echo "      SolukOS Restore"
echo "=============================="
echo ""

if [ ! -d "$BACKUP_DIR" ]; then
    echo "[!] No backups found."
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
    echo "[!] Invalid backup."
    exit 1
fi

BACKUP_NAME=$(basename "$BACKUP")

echo ""
echo "Selected:"
echo "$BACKUP_NAME"
echo ""

read -p "Continue restore? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""

if [ -f "$BACKUP/zshrc" ]; then
    cp "$BACKUP/zshrc" "$HOME/.zshrc"
    echo "[✓] Zsh restored"
fi

if [ -f "$BACKUP/banner.txt" ]; then
    cp "$BACKUP/banner.txt" "$HOME/.solukos/banner.txt"
    echo "[✓] Banner restored"
fi

if [ -f "$BACKUP/version" ]; then
    cp "$BACKUP/version" "$HOME/.solukos/version"
    echo "[✓] Version restored"
fi

echo ""

echo "[+] Restore completed."

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Restore completed: $BACKUP_NAME" >> "$LOG_FILE"

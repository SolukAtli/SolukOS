#!/data/data/com.termux/files/usr/bin/bash

BACKUP_DIR="$HOME/.solukos/backups"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
TARGET="$BACKUP_DIR/backup-$DATE"

mkdir -p "$TARGET"

echo "=============================="
echo "       SolukOS Backup"
echo "=============================="
echo ""

echo "[*] Creating backup..."

# Zsh config
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$TARGET/zshrc"
    echo "[✓] Zsh configuration"
fi

# SolukOS banner
if [ -f "$HOME/.solukos/banner.txt" ]; then
    cp "$HOME/.solukos/banner.txt" "$TARGET/banner.txt"
    echo "[✓] Banner"
fi

# Version
if [ -f "$HOME/.solukos/version" ]; then
    cp "$HOME/.solukos/version" "$TARGET/version"
    echo "[✓] Version"
fi

echo ""
echo "[+] Backup completed."
echo ""
echo "Location:"
echo "$TARGET"

#!/data/data/com.termux/files/usr/bin/bash

SOLUK_DIR="$HOME/.solukos"

clear

echo "=============================="
echo "       Reset Config"
echo "=============================="
echo ""

echo "This will reset SolukOS settings."
echo ""

read -p "Create backup first? (y/n): " BACKUP

if [ "$BACKUP" = "y" ]; then
    if [ -f "$HOME/SolukOS/scripts/backup.sh" ]; then
        bash "$HOME/SolukOS/scripts/backup.sh"
    else
        echo "[!] Backup script not found."
    fi
fi

echo ""

read -p "Continue reset? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi


# Reset theme
echo "default" > "$SOLUK_DIR/theme"


# Reset banner
if [ -f "$HOME/SolukOS/assets/banner.txt" ]; then
    cp "$HOME/SolukOS/assets/banner.txt" "$SOLUK_DIR/banner.txt"
    echo "[✓] Banner restored"
else
    echo "[!] Original banner not found"
fi


echo ""
echo "[+] Config reset completed."

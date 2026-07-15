#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

LOG_FILE="$HOME/.solukos/logs/install.log"
VERSION_FILE="$BASE_DIR/VERSION"

mkdir -p "$(dirname "$LOG_FILE")"

if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE")
else
    VERSION="unknown"
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Installation started" >> "$LOG_FILE"

while true
do

clear

echo "=============================="
echo "        SolukOS v$VERSION"
echo "=============================="
echo ""
echo "[1] Full Install"
echo "[2] Backup Config"
echo "[3] Remove SolukOS"
echo "[4] Exit"
echo ""

read -p "Choice: " choice

case $choice in

1)
    echo ""
    echo "[*] Checking system..."

    command -v git >/dev/null && echo "✓ Git" || echo "✗ Git missing"
    command -v zsh >/dev/null && echo "✓ Zsh" || echo "• Zsh will be installed"
    command -v nano >/dev/null && echo "✓ Nano" || echo "• Nano will be installed"

    echo ""

    echo "[*] Creating backup..."
    bash "$BASE_DIR/scripts/backup.sh" "$BASE_DIR"

    echo ""

    echo "[*] Installing packages..."
    bash "$BASE_DIR/scripts/packages.sh"

    echo ""

    echo "[*] Applying theme..."
    bash "$BASE_DIR/scripts/theme.sh"

    echo ""

    echo "[*] Configuring Zsh..."
    bash "$BASE_DIR/scripts/zsh.sh" "$BASE_DIR"

    mkdir -p ~/.solukos
    cp "$BASE_DIR/assets/banner.txt" ~/.solukos/banner.txt
    echo "$VERSION" > ~/.solukos/version
    echo "$BASE_DIR" > ~/.solukos/install_path

# Installing Soluk command

if [ -f "$BASE_DIR/bin/soluk" ]; then

    cp "$BASE_DIR/bin/soluk" /data/data/com.termux/files/usr/bin/soluk
    chmod +x /data/data/com.termux/files/usr/bin/soluk

    echo "Soluk command installed."

else

    echo "Soluk command file not found."

fi

echo ""
echo "=============================="
echo " SolukOS Installation Complete"
echo "=============================="
echo ""
echo " Version : v$VERSION"
echo " Backup  : Created"
echo " Theme   : Applied"
echo " Zsh     : Configured"
echo ""
echo " Enjoy SolukOS."
echo "=============================="

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Installation completed" >> "$LOG_FILE"

sleep 3
exec zsh
    ;;

2)
    bash "$BASE_DIR/scripts/backup.sh" "$BASE_DIR"
    ;;

3)
    bash "$BASE_DIR/scripts/uninstall.sh" "$BASE_DIR"
    ;;

4)
    echo "Goodbye."
    exit 0
    ;;

*)
    echo "Invalid option."
    ;;
esac
echo ""
read -p "Press Enter to continue..."
clear

done


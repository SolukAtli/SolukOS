#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=============================="
echo "        SolukOS v0.3"
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
    bash "$BASE_DIR/scripts/backup.sh"

    echo ""

    echo "[*] Installing packages..."
    bash "$BASE_DIR/scripts/packages.sh"

    echo ""

    echo "[*] Applying theme..."
    bash "$BASE_DIR/scripts/theme.sh"

    echo ""

    echo "[*] Configuring Zsh..."
    bash "$BASE_DIR/scripts/zsh.sh"

    mkdir -p ~/.solukos
    cp "$BASE_DIR/assets/banner.txt" ~/.solukos/banner.txt

echo ""
echo "=============================="
echo " SolukOS Installation Complete"
echo "=============================="
echo ""
echo " Version : v0.3"
echo " Backup  : Created"
echo " Theme   : Applied"
echo " Zsh     : Configured"
echo ""
echo " Enjoy SolukOS."
echo "=============================="

sleep 3
exec zsh
    ;;

2)
    bash "$BASE_DIR/scripts/backup.sh"
    ;;

3)
    bash "$BASE_DIR/scripts/uninstall.sh"
    ;;

4)
    echo "Goodbye."
    exit 0
    ;;

*)
    echo "Invalid option."
    ;;
esac

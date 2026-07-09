#!/data/data/com.termux/files/usr/bin/bash

clear

VERSION="0.2"

echo "=============================="
echo "        SolukOS v$VERSION"
echo "=============================="
echo ""

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[*] Checking system..."

command -v git >/dev/null && echo "✓ Git" || echo "✗ Git missing"
command -v zsh >/dev/null && echo "✓ Zsh" || echo "• Zsh will be installed"
command -v nano >/dev/null && echo "✓ Nano" || echo "• Nano will be installed"

echo ""

echo "[*] Installing packages..."
bash "$BASE_DIR/scripts/packages.sh"

echo ""

echo "[*] Applying theme..."
bash "$BASE_DIR/scripts/theme.sh"

echo ""

echo "[*] Configuring Zsh..."
bash "$BASE_DIR/scripts/zsh.sh"

echo ""

mkdir -p ~/.solukos
cp "$BASE_DIR/assets/banner.txt" ~/.solukos/banner.txt

echo "=============================="
echo " SolukOS v0.2 installed!"
echo " Starting SolukOS..."
echo "=============================="

sleep 2

exec zsh

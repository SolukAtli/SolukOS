#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)}"

echo "[+] Setting up Zsh..."

if command -v zsh >/dev/null 2>&1
then
    echo "[+] Zsh already installed."
else
    echo "[+] Installing Zsh..."
    pkg install -y zsh
fi

echo "[+] Copying SolukOS Zsh configuration..."

cp "$BASE_DIR/config/zshrc" ~/.zshrc

echo "[+] Zsh configuration applied."

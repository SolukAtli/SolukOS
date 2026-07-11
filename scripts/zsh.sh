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

mkdir -p ~/.zsh

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    echo "[+] Installing zsh-autosuggestions..."
    git clone --quiet https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
else
    echo "[+] zsh-autosuggestions already installed."
fi

if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    echo "[+] Installing zsh-syntax-highlighting..."
    git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
else
    echo "[+] zsh-syntax-highlighting already installed."
fi

echo "[+] Copying SolukOS Zsh configuration..."

cp "$BASE_DIR/config/zshrc" ~/.zshrc

echo "[+] Zsh configuration applied."

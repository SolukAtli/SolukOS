#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Checking existing Zsh configuration..."

if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.solukos.backup
    echo "[+] Backup created: ~/.zshrc.solukos.backup"
else
    echo "[+] No existing .zshrc found."
fi

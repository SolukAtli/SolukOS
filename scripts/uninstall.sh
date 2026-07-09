#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Removing SolukOS..."

if [ -f ~/.zshrc.solukos.backup ]; then
    cp ~/.zshrc.solukos.backup ~/.zshrc
    echo "[+] Original Zsh configuration restored."
else
    echo "[!] Backup not found."
fi

rm -rf ~/.solukos

echo "[+] SolukOS files removed."
echo "[+] Uninstall completed."

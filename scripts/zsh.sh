#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Setting up Zsh..."

if command -v zsh >/dev/null 2>&1
then
    echo "[+] Zsh already installed."
else
    echo "[+] Installing Zsh..."
    pkg install -y zsh
fi

echo "[+] Copying SolukOS Zsh configuration..."

cp config/zshrc ~/.zshrc

echo "[+] Zsh configuration applied."

grep -qxF 'exec zsh' ~/.bashrc || echo 'exec zsh' >> ~/.bashrc

echo "[+] Zsh will start automatically."

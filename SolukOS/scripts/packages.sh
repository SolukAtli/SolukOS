#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Installing required packages..."

pkg update -y
pkg upgrade -y

pkg install -y zsh git nano fzf zoxide bat eza

echo "[+] Packages installed."

#!/usr/bin/env bash

echo "[+] Installing required packages..."

sudo pacman -Syu --noconfirm

sudo pacman -S --noconfirm zsh git nano fzf zoxide bat eza curl

echo "[+] Packages installed."

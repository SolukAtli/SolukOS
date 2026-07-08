#!/data/data/com.termux/files/usr/bin/bash

# ==========================
# SolukOS v0.1 Installer
# ==========================

clear

echo "Installing SolukOS..."

# Update packages
pkg update -y

# Install required packages
pkg install -y zsh

# Create Termux config folder
mkdir -p ~/.termux

# SolukOS color theme
cat > ~/.termux/colors.properties << 'EOF'
background=#232323
foreground=#bdbdbd
cursor=#d0d0d0
EOF

# SolukOS ZSH configuration
cat > ~/.zshrc << 'EOF'
clear

echo ""
echo "███████╗ ██████╗ ██╗     ██╗   ██╗██╗  ██╗"
echo "██╔════╝██╔═══██╗██║     ██║   ██║██║ ██╔╝"
echo "███████╗██║   ██║██║     ██║   ██║█████╔╝ "
echo "╚════██║██║   ██║██║     ██║   ██║██╔═██╗ "
echo "███████║╚██████╔╝███████╗╚██████╔╝██║  ██╗"
echo "╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝"
echo ""
echo "[ SolukOS ] Terminal initialized."
echo ""

PROMPT='%F{250}┌──(Soluk㉿Termux)-[%~]
└─$ %f'

alias ll='ls -la'
alias update='pkg update && pkg upgrade'
EOF

# Set zsh as default shell
chsh -s zsh

# Reload settings
termux-reload-settings 2>/dev/null || true

echo ""
echo "=========================="
echo " SolukOS installed!"
echo " Restart Termux."
echo "=========================="

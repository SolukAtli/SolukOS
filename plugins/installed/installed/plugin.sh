#!/data/data/com.termux/files/usr/bin/bash

echo "=============================="
echo "    SolukOS System Plugin"
echo "=============================="
echo ""

echo "User: $(whoami)"
echo "Shell: $SHELL"
echo "Home: $HOME"

echo ""

echo "Storage:"
df -h "$HOME"

#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
SOLUK_BIN="/data/data/com.termux/files/usr/bin/soluk"

[ -f "$BASE_DIR/scripts/lib/ui.sh" ] && source "$BASE_DIR/scripts/lib/ui.sh"

clear
soluk_header "Remove SolukOS"

echo "This will:"
echo "  - Restore your original .zshrc (if a backup exists)"
echo "  - Remove ~/.solukos (settings, theme, logs, backups, installed external tools)"
echo "  - Remove the 'soluk' command"
echo ""
echo "It will NOT delete the project folder itself:"
soluk_row "Folder" "$BASE_DIR"
echo ""

read -p "Are you sure you want to continue? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
soluk_info "Removing SolukOS..."

if [ -f ~/.zshrc.solukos.backup ]; then
    cp ~/.zshrc.solukos.backup ~/.zshrc
    soluk_ok "Original Zsh configuration restored."
else
    soluk_warn "No original .zshrc backup found - .zshrc left as-is."
fi

rm -rf ~/.solukos
soluk_ok "~/.solukos removed (settings, backups, installed tools)."

if [ -f "$SOLUK_BIN" ]; then
    rm -f "$SOLUK_BIN"
    soluk_ok "'soluk' command removed."
fi

echo ""
soluk_ok "Uninstall completed."
echo ""
echo "The project folder itself was kept. Delete it manually if you no longer need it:"
echo "  rm -rf $BASE_DIR"

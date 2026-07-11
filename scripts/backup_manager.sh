#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
BACKUP_DIR="$HOME/.solukos/backups"

source "$BASE_DIR/scripts/lib/ui.sh"

while true
do
    clear
    soluk_header "Backup Manager"

    choice=$(soluk_menu "Backup Manager" \
        "Create Backup" \
        "Restore Backup" \
        "List Backups" \
        "Delete Backup" \
        "Back")

    case "$choice" in

    "Create Backup")
        bash "$BASE_DIR/scripts/backup.sh"
        ;;

    "Restore Backup")
        bash "$BASE_DIR/scripts/restore.sh"
        ;;

    "List Backups")
        clear
        soluk_header "Available Backups"

        if [ -d "$BACKUP_DIR" ]; then
            ls -1 "$BACKUP_DIR"
        else
            echo "No backups found."
        fi
        ;;

    "Delete Backup")
        clear
        soluk_header "Delete Backup"

        ls -1 "$BACKUP_DIR" 2>/dev/null

        echo ""
        read -p "Backup name: " NAME

        if [ -d "$BACKUP_DIR/$NAME" ]; then
            rm -rf "$BACKUP_DIR/$NAME"
            soluk_ok "Backup deleted."
        else
            soluk_warn "Backup not found."
        fi
        ;;

    "Back"|"")
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter to continue..."

done

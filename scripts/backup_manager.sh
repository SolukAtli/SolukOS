#!/usr/bin/env bash

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
        bash "$BASE_DIR/scripts/backup.sh" "$BASE_DIR"
        ;;

    "Restore Backup")
        bash "$BASE_DIR/scripts/restore.sh" "$BASE_DIR"
        ;;

    "List Backups")
        clear
        soluk_header "Available Backups"

        if [ -d "$BACKUP_DIR" ] && [ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
            for B in "$BACKUP_DIR"/*; do
                echo -e "  ${SOLUK_BCYAN}$(basename "$B")${SOLUK_RESET}"
            done
        else
            soluk_warn "No backups found."
        fi
        ;;

    "Delete Backup")
        clear
        soluk_header "Delete Backup"

        if [ -d "$BACKUP_DIR" ] && [ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
            for B in "$BACKUP_DIR"/*; do
                echo -e "  ${SOLUK_BCYAN}$(basename "$B")${SOLUK_RESET}"
            done
        else
            soluk_warn "No backups found."
        fi

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

#!/data/data/com.termux/files/usr/bin/bash

BACKUP_DIR="$HOME/.solukos/backups"

while true
do
    clear

    echo "=============================="
    echo "       Backup Manager"
    echo "=============================="
    echo ""
    echo "[1] Create Backup"
    echo "[2] Restore Backup"
    echo "[3] List Backups"
    echo "[4] Delete Backup"
    echo "[5] Back"
    echo ""

    read -p "Choice: " choice

    case $choice in

    1)
        bash "$HOME/SolukOS/scripts/backup.sh"
        ;;

    2)
        bash "$HOME/SolukOS/scripts/restore.sh"
        ;;

    3)
        clear
        echo "=============================="
        echo "        Available Backups"
        echo "=============================="
        echo ""

        if [ -d "$BACKUP_DIR" ]; then
            ls -1 "$BACKUP_DIR"
        else
            echo "No backups found."
        fi
        ;;

    4)
        clear
        echo "=============================="
        echo "        Delete Backup"
        echo "=============================="
        echo ""

        ls -1 "$BACKUP_DIR"

        echo ""
        read -p "Backup name: " NAME

        if [ -d "$BACKUP_DIR/$NAME" ]; then
            rm -rf "$BACKUP_DIR/$NAME"
            echo "[+] Backup deleted."
        else
            echo "[!] Backup not found."
        fi
        ;;

    5)
        break
        ;;

    *)
        echo "Invalid option."
        ;;

    esac

    echo ""
    read -p "Press Enter to continue..."

done

#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
DB_FILE="$BASE_DIR/packages/database.txt"

source "$BASE_DIR/scripts/lib/ui.sh"

if [ ! -f "$DB_FILE" ]; then
    echo "[!] Package database not found: $DB_FILE"
    exit 1
fi

while true
do
    clear
    soluk_header "Package Manager"

    choice=$(soluk_menu "Package Manager" \
        "List Packages" \
        "Search Package" \
        "Package Info" \
        "Install Package" \
        "Remove Package" \
        "Check Installed Status" \
        "Back")

    case "$choice" in

    "List Packages")
        clear
        echo "Available Packages:"
        echo ""
        cat "$DB_FILE"
        ;;

    "Search Package")
        read -p "Search term: " term
        clear
        echo "Results for '$term':"
        echo ""
        grep -i "$term" "$DB_FILE"
        ;;

    "Package Info")
        read -p "Package name: " pkgname
        clear
        INFO=$(grep "^$pkgname|" "$DB_FILE")

        if [ -z "$INFO" ]; then
            soluk_warn "Package not found."
        else
            IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"
            echo "Name: $NAME"
            echo "Category: $CATEGORY"
            echo "Type: $TYPE"
            echo "Status: $STATUS"
        fi
        ;;

    "Install Package")
        read -p "Package name: " pkgname
        clear
        INFO=$(grep "^$pkgname|" "$DB_FILE")

        if [ -z "$INFO" ]; then
            soluk_warn "Package not found."
        else
            IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"

            if [ "$TYPE" = "native" ]; then
                pkg install "$NAME" -y
            elif [ "$TYPE" = "plugin" ]; then
                echo "[i] '$NAME' is a plugin. Use Plugin Manager to install it."
            else
                soluk_warn "'$NAME' is an external tool. Manual installation required."
            fi
        fi
        ;;

    "Remove Package")
        read -p "Package name: " pkgname
        clear
        INFO=$(grep "^$pkgname|" "$DB_FILE")

        if [ -z "$INFO" ]; then
            soluk_warn "Package not found."
        else
            IFS="|" read -r NAME CATEGORY TYPE STATUS <<< "$INFO"

            if [ "$TYPE" = "native" ]; then
                pkg uninstall "$NAME" -y
            elif [ "$TYPE" = "plugin" ]; then
                echo "[i] '$NAME' is a plugin. Use Plugin Manager to remove it."
            else
                soluk_warn "Manual removal required for '$NAME'."
            fi
        fi
        ;;

    "Check Installed Status")
        clear
        echo "Checking installed status..."
        echo ""

        while IFS="|" read -r NAME CATEGORY TYPE STATUS
        do
            [ -z "$NAME" ] && continue

            if command -v "$NAME" >/dev/null 2>&1; then
                soluk_ok "$NAME"
            else
                soluk_fail "$NAME"
            fi
        done < "$DB_FILE"
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

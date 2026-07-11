#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
PLUGIN_DIR="$BASE_DIR/plugins"
INSTALLED_DIR="$PLUGIN_DIR/installed"

source "$BASE_DIR/scripts/lib/ui.sh"

mkdir -p "$INSTALLED_DIR"

while true
do
    clear
    soluk_header "Plugin Manager"

    choice=$(soluk_menu "Plugin Manager" \
        "List Plugins" \
        "Plugin Info" \
        "Run Plugin" \
        "Install Plugin" \
        "Remove Plugin" \
        "Back")

    case "$choice" in

    "List Plugins")
        clear
        echo "Installed Plugins:"
        echo ""

        for PLUGIN in "$INSTALLED_DIR"/*
        do
            if [ -d "$PLUGIN" ]; then
                NAME=$(basename "$PLUGIN")
                echo "$NAME"

                if [ -f "$PLUGIN/info" ]; then
                    grep "Description=" "$PLUGIN/info"
                fi

                echo ""
            fi
        done
        ;;

    "Plugin Info")
        read -p "Plugin name: " plugin

        if [ -f "$INSTALLED_DIR/$plugin/info" ]; then
            echo ""
            cat "$INSTALLED_DIR/$plugin/info"
        else
            soluk_warn "Plugin info not found."
        fi
        ;;

    "Run Plugin")
        read -p "Plugin name: " plugin

        if [ -f "$INSTALLED_DIR/$plugin/plugin.sh" ]; then
            echo ""
            echo "Plugin information:"
            echo ""

            if [ -f "$INSTALLED_DIR/$plugin/info" ]; then
                cat "$INSTALLED_DIR/$plugin/info"
            fi

            echo ""
            read -p "Run plugin? (y/n): " confirm

            if [ "$confirm" = "y" ]; then
                bash "$INSTALLED_DIR/$plugin/plugin.sh" "$BASE_DIR"
            else
                echo "Cancelled."
            fi
        else
            soluk_warn "Plugin not found."
        fi
        ;;

    "Install Plugin")
        echo "Available plugins:"
        echo ""
        ls "$PLUGIN_DIR" | grep -v '^installed$'
        echo ""

        read -p "Plugin name: " plugin

        if [ -d "$PLUGIN_DIR/$plugin" ]; then
            cp -r "$PLUGIN_DIR/$plugin" "$INSTALLED_DIR/"
            soluk_ok "Plugin installed."
        else
            soluk_warn "Plugin not found."
        fi
        ;;

    "Remove Plugin")
        read -p "Plugin name: " plugin

        if [ -d "$INSTALLED_DIR/$plugin" ]; then
            rm -rf "$INSTALLED_DIR/$plugin"
            soluk_ok "Plugin removed."
        else
            soluk_warn "Plugin not found."
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

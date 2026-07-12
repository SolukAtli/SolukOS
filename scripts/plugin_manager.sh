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
        soluk_header "Installed Plugins"

        FOUND=0
        for PLUGIN in "$INSTALLED_DIR"/*
        do
            if [ -d "$PLUGIN" ]; then
                FOUND=1
                NAME=$(basename "$PLUGIN")
                echo -e "${SOLUK_BOLD}${SOLUK_BCYAN}${NAME}${SOLUK_RESET}"

                if [ -f "$PLUGIN/info" ]; then
                    DESC=$(grep "Description=" "$PLUGIN/info" | cut -d= -f2-)
                    echo -e "  ${SOLUK_GRAY}${DESC}${SOLUK_RESET}"
                fi

                echo ""
            fi
        done

        [ "$FOUND" = "0" ] && soluk_warn "No plugins installed."
        ;;

    "Plugin Info")
        read -p "Plugin name: " plugin
        clear
        soluk_header "Plugin Info"

        if [ -f "$INSTALLED_DIR/$plugin/info" ]; then
            while IFS="=" read -r KEY VALUE
            do
                [ -z "$KEY" ] && continue
                soluk_row "$KEY" "$VALUE"
            done < "$INSTALLED_DIR/$plugin/info"
        else
            soluk_warn "Plugin info not found."
        fi
        ;;

    "Run Plugin")
        read -p "Plugin name: " plugin

        if [ -f "$INSTALLED_DIR/$plugin/plugin.sh" ]; then
            clear
            soluk_header "$plugin"

            if [ -f "$INSTALLED_DIR/$plugin/info" ]; then
                while IFS="=" read -r KEY VALUE
                do
                    [ -z "$KEY" ] && continue
                    soluk_row "$KEY" "$VALUE"
                done < "$INSTALLED_DIR/$plugin/info"
                echo ""
            fi

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
        clear
        soluk_header "Install Plugin"

        echo -e "${SOLUK_BOLD}${SOLUK_CYAN}Available plugins${SOLUK_RESET}"
        for P in "$PLUGIN_DIR"/*
        do
            NAME=$(basename "$P")
            [ "$NAME" = "installed" ] && continue
            [ -d "$P" ] && echo -e "  ${SOLUK_BCYAN}${NAME}${SOLUK_RESET}"
        done
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

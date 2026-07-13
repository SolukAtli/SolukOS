#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
PLUGIN_DIR="$BASE_DIR/plugins"
INSTALLED_DIR="$PLUGIN_DIR/installed"

source "$BASE_DIR/scripts/lib/ui.sh"
[ -f "$BASE_DIR/scripts/logger.sh" ] && source "$BASE_DIR/scripts/logger.sh"

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
        "Install from Git" \
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
            command -v log >/dev/null 2>&1 && log "Plugin installed: $plugin"
        else
            soluk_warn "Plugin not found."
        fi
        ;;

    "Install from Git")
        clear
        soluk_header "Install from Git"

        if ! command -v git >/dev/null 2>&1; then
            soluk_warn "git bulunamadi. 'pkg install git' ile kurup tekrar dene."
        else
            soluk_warn "Sadece guvendigin kaynaklardan eklenti kur - plugin.sh dogrudan calisir."
            echo ""
            read -p "Git URL: " GIT_URL

            if [ -z "$GIT_URL" ]; then
                soluk_warn "URL girilmedi."
            else
                NAME=$(basename "$GIT_URL" .git)

                if [ -z "$NAME" ] || [ "$NAME" = "/" ]; then
                    soluk_warn "Gecersiz URL."
                elif [ -d "$INSTALLED_DIR/$NAME" ]; then
                    soluk_warn "'$NAME' zaten kurulu. Once kaldirip tekrar dene."
                else
                    TMP_DIR="$HOME/.solukos/tmp/plugin_$$"
                    rm -rf "$TMP_DIR"
                    mkdir -p "$TMP_DIR"

                    soluk_info "Cloning $GIT_URL ..."

                    if git clone --depth 1 "$GIT_URL" "$TMP_DIR" >/dev/null 2>&1; then
                        if [ -f "$TMP_DIR/plugin.sh" ]; then
                            rm -rf "$TMP_DIR/.git"
                            mv "$TMP_DIR" "$INSTALLED_DIR/$NAME"
                            chmod +x "$INSTALLED_DIR/$NAME/plugin.sh"
                            soluk_ok "Plugin installed: $NAME"
                            command -v log >/dev/null 2>&1 && log "Plugin installed from git: $NAME ($GIT_URL)"
                        else
                            soluk_warn "Repo icinde plugin.sh bulunamadi, kurulum iptal edildi."
                            rm -rf "$TMP_DIR"
                        fi
                    else
                        soluk_warn "Klonlama basarisiz. URL'yi ve internet baglantisini kontrol et."
                        rm -rf "$TMP_DIR"
                    fi
                fi
            fi
        fi
        ;;

    "Remove Plugin")
        read -p "Plugin name: " plugin

        if [ -d "$INSTALLED_DIR/$plugin" ]; then
            rm -rf "$INSTALLED_DIR/$plugin"
            soluk_ok "Plugin removed."
            command -v log >/dev/null 2>&1 && log "Plugin removed: $plugin"
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

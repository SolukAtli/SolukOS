#!/usr/bin/env bash

BASE_DIR="${1:-$(cat ~/.solukos/install_path 2>/dev/null)}"
DB_FILE="$BASE_DIR/packages/database.txt"
SOURCES_FILE="$BASE_DIR/packages/sources.txt"

source "$BASE_DIR/scripts/lib/ui.sh"
[ -f "$BASE_DIR/scripts/logger.sh" ] && source "$BASE_DIR/scripts/logger.sh"

touch "$SOURCES_FILE"

while true
do
    clear
    soluk_header "Repository Manager"

    choice=$(soluk_menu "Repository Manager" \
        "Update Repositories" \
        "List Repositories" \
        "Add Repository" \
        "Remove Repository" \
        "Back")

    case "$choice" in

    "Update Repositories")
        clear
        soluk_header "Update Repositories"

        if ! command -v curl >/dev/null 2>&1; then
            soluk_warn "curl bulunamadi. 'sudo pacman -S curl' ile kurup tekrar dene."
        elif [ -z "$(grep -v '^#' "$SOURCES_FILE" | grep -v '^[[:space:]]*$')" ]; then
            soluk_warn "Hic repository tanimli degil. Once 'Add Repository' ile bir URL ekle."
        else
            TOTAL_NEW=0

            while IFS= read -r URL; do
                case "$URL" in ""|\#*) continue ;; esac

                soluk_info "Fetching: $URL"
                REMOTE_CONTENT=$(curl -sL --max-time 15 "$URL" 2>/dev/null)

                if [ -z "$REMOTE_CONTENT" ]; then
                    soluk_warn "Alinamadi (bos yanit ya da baglanti hatasi): $URL"
                    continue
                fi

                NEW_COUNT=0

                while IFS= read -r LINE; do
                    case "$LINE" in ""|\#*) continue ;; esac

                    PKG_NAME="${LINE%%|*}"
                    [ -z "$PKG_NAME" ] && continue

                    if ! grep -q "^$PKG_NAME|" "$DB_FILE" 2>/dev/null; then
                        echo "$LINE" >> "$DB_FILE"
                        NEW_COUNT=$((NEW_COUNT + 1))
                    fi
                done <<< "$REMOTE_CONTENT"

                soluk_ok "$URL -> $NEW_COUNT new package(s)"
                TOTAL_NEW=$((TOTAL_NEW + NEW_COUNT))
            done < "$SOURCES_FILE"

            echo ""
            soluk_ok "Total new packages added: $TOTAL_NEW"
            command -v log >/dev/null 2>&1 && log "Repositories updated: $TOTAL_NEW new package(s)"
        fi
        ;;

    "List Repositories")
        clear
        soluk_header "Repositories"

        if [ -n "$(grep -v '^#' "$SOURCES_FILE" | grep -v '^[[:space:]]*$')" ]; then
            NUM=1
            while IFS= read -r URL; do
                case "$URL" in ""|\#*) continue ;; esac
                echo -e "  ${SOLUK_BCYAN}${NUM}.${SOLUK_RESET} $URL"
                NUM=$((NUM + 1))
            done < "$SOURCES_FILE"
        else
            soluk_warn "Hic repository tanimli degil."
        fi
        ;;

    "Add Repository")
        read -p "Repository URL: " URL
        clear
        soluk_header "Add Repository"

        if [ -z "$URL" ]; then
            soluk_warn "URL girilmedi."
        elif grep -qF "$URL" "$SOURCES_FILE" 2>/dev/null; then
            soluk_warn "Bu repository zaten ekli."
        else
            echo "$URL" >> "$SOURCES_FILE"
            soluk_ok "Repository eklendi."
            command -v log >/dev/null 2>&1 && log "Repository added: $URL"
        fi
        ;;

    "Remove Repository")
        clear
        soluk_header "Remove Repository"

        if [ -z "$(grep -v '^#' "$SOURCES_FILE" | grep -v '^[[:space:]]*$')" ]; then
            soluk_warn "Hic repository tanimli degil."
        else
            NUM=1
            while IFS= read -r URL; do
                case "$URL" in ""|\#*) continue ;; esac
                echo "$NUM. $URL"
                NUM=$((NUM + 1))
            done < "$SOURCES_FILE"
            echo ""

            read -p "Remove which URL (paste it exactly): " TARGET

            if [ -n "$TARGET" ] && grep -qF "$TARGET" "$SOURCES_FILE" 2>/dev/null; then
                grep -vF "$TARGET" "$SOURCES_FILE" > "$SOURCES_FILE.tmp" && mv "$SOURCES_FILE.tmp" "$SOURCES_FILE"
                soluk_ok "Repository kaldirildi."
                command -v log >/dev/null 2>&1 && log "Repository removed: $TARGET"
            else
                soluk_warn "Bulunamadi."
            fi
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

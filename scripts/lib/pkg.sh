#!/usr/bin/env bash
# SolukOS - shared package-database helpers.
#
# Database format (packages/database.txt), pipe-delimited:
#   name|category|type|status|deps
# deps is a comma-separated list of package or command names required
# before installing this package (empty if none).
#
# Usage:
#   source "$BASE_DIR/scripts/lib/pkg.sh"
#   soluk_resolve_deps "$DEPS" "$DB_FILE"

# Installs any deps that aren't already satisfied. Deps found in the
# database are installed according to their own type; anything else is
# treated as a plain pacman package name.
soluk_resolve_deps()
{
    local deps="$1" db_file="$2"
    local dep dep_info dep_name dep_cat dep_type dep_status dep_deps

    [ -z "$deps" ] && return 0

    local IFS=","
    for dep in $deps; do
        IFS=" "
        dep="$(echo "$dep" | xargs)"

        [ -z "$dep" ] && continue

        if command -v "$dep" >/dev/null 2>&1; then
            continue
        fi

        soluk_info "Resolving dependency: $dep"

        dep_info=$(grep "^$dep|" "$db_file" 2>/dev/null)

        if [ -n "$dep_info" ]; then
            IFS="|" read -r dep_name dep_cat dep_type dep_status dep_deps <<< "$dep_info"

            if [ "$dep_type" = "native" ]; then
                sudo pacman -S --noconfirm "$dep_name"
            else
                sudo pacman -S --noconfirm "$dep" 2>/dev/null
            fi
        else
            sudo pacman -S --noconfirm "$dep" 2>/dev/null
        fi
    done
}

# Prints the package database as an aligned table instead of raw
# pipe-delimited lines. Status is checked live (command -v) rather than
# read from the file, since the stored status field is just a static
# label and can be stale.
soluk_print_pkg_list()
{
    local db_file="$1"
    local name category type status deps status_txt status_color

    printf "  ${SOLUK_BOLD}${SOLUK_CYAN}%-16s %-11s %-10s %-14s %s${SOLUK_RESET}\n" \
        "NAME" "CATEGORY" "TYPE" "STATUS" "DEPENDS"

    while IFS="|" read -r name category type status deps; do
        [ -z "$name" ] && continue

        if command -v "$name" >/dev/null 2>&1; then
            status_txt="installed"
            status_color="$SOLUK_GREEN"
        else
            status_txt="not installed"
            status_color="$SOLUK_RED"
        fi

        printf "  %-16s %-11s %-10s ${status_color}%-14s${SOLUK_RESET} %s\n" \
            "$name" "$category" "$type" "$status_txt" "${deps:-none}"
    done < "$db_file"
}

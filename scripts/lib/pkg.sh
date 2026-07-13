#!/data/data/com.termux/files/usr/bin/bash
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
# treated as a plain Termux package name.
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
                pkg install "$dep_name" -y
            else
                pkg install "$dep" -y 2>/dev/null
            fi
        else
            pkg install "$dep" -y 2>/dev/null
        fi
    done
}

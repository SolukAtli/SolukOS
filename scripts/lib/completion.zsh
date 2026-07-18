# SolukOS - zsh tab-completion for the `soluk` command.
# Sourced from config/zshrc, after `compinit` has already run there.

_soluk_pkg_names()
{
    local db_file="${1}/packages/database.txt"
    [ -f "$db_file" ] || return
    grep -v '^[[:space:]]*$' "$db_file" | cut -d'|' -f1
}

_soluk()
{
    local base_dir
    base_dir="$(cat ~/.solukos/install_path 2>/dev/null)"
    [ -z "$base_dir" ] && base_dir="$HOME/SolukOS"

    local -a top_level pkg_actions

    top_level=(version help doctor fetch update reload pkg)
    pkg_actions=(list search info install remove check update)

    if (( CURRENT == 2 )); then
        compadd -a top_level
        return
    fi

    if [[ "${words[2]}" == "pkg" ]]; then
        if (( CURRENT == 3 )); then
            compadd -a pkg_actions
            return
        fi

        if (( CURRENT == 4 )); then
            case "${words[3]}" in
                search|info|install|remove|update)
                    compadd $(_soluk_pkg_names "$base_dir")
                    ;;
            esac
        fi
    fi
}

compdef _soluk soluk

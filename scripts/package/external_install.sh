#!/usr/bin/env bash
# Installs/removes external security tools that aren't installed via pacman
# (either not packaged for Arch at all, or intentionally kept as a
# from-source clone - see Faz 4 notes for which tools this still applies to).
# Clones the upstream repo and drops a wrapper command in ~/.local/bin so
# the tool works like any other installed command afterwards.
#
# Usage: external_install.sh <install|remove> <tool-name>

BASE_DIR="$(cat ~/.solukos/install_path 2>/dev/null)"
source "$BASE_DIR/scripts/lib/ui.sh"
[ -f "$BASE_DIR/scripts/logger.sh" ] && source "$BASE_DIR/scripts/logger.sh"

ACTION="$1"
NAME="$2"

TOOLS_DIR="$HOME/.solukos/tools"
BIN_DIR="$HOME/.local/bin"

install_git_tool()
{
    local name="$1" url="$2" runtime="$3" entry="$4" modules="$5"

    if ! command -v git >/dev/null 2>&1; then
        soluk_warn "git bulunamadi. 'sudo pacman -S git' ile kurup tekrar dene."
        return 1
    fi

    if ! command -v "$runtime" >/dev/null 2>&1; then
        soluk_info "$runtime kuruluyor..."
        sudo pacman -S --noconfirm "$runtime"
    fi

    mkdir -p "$TOOLS_DIR"

    if [ -d "$TOOLS_DIR/$name" ]; then
        soluk_warn "$name zaten kurulu ($TOOLS_DIR/$name)."
        write_wrapper "$name" "$runtime" "$entry"
        if [ "$runtime" = "perl" ] && [ -n "$modules" ]; then
            install_perl_modules "$modules"
        fi
        return 0
    fi

    soluk_info "Cloning $name..."

    if git clone --depth 1 "$url" "$TOOLS_DIR/$name" >/dev/null 2>&1; then
        write_wrapper "$name" "$runtime" "$entry"
        soluk_ok "$name installed."

        if [ "$runtime" = "perl" ] && [ -n "$modules" ]; then
            install_perl_modules "$modules"
        fi

        soluk_ok "Type '$name' to run it."
        command -v log >/dev/null 2>&1 && log "External tool installed: $name"
    else
        soluk_warn "Clone failed. Check the URL and your internet connection."
        rm -rf "$TOOLS_DIR/$name"
    fi
}

# Writes/refreshes the ~/.local/bin wrapper for a tool. Called both on a
# fresh install and when re-running install on an already-cloned tool, so
# older wrappers (e.g. missing PERL5LIB) get upgraded automatically too.
write_wrapper()
{
    local name="$1" runtime="$2" entry="$3"
    local entry_dir entry_file
    entry_dir="$(dirname "$entry")"
    entry_file="$(basename "$entry")"

    mkdir -p "$BIN_DIR"

    if [ "$runtime" = "perl" ]; then
        cat > "$BIN_DIR/$name" << WRAPPER
#!/usr/bin/env bash
export PERL5LIB="\$HOME/perl5/lib/perl5:\$PERL5LIB"
cd "$TOOLS_DIR/$name/$entry_dir" && $runtime "$entry_file" "\$@"
WRAPPER
    else
        cat > "$BIN_DIR/$name" << WRAPPER
#!/usr/bin/env bash
$runtime "$TOOLS_DIR/$name/$entry" "\$@"
WRAPPER
    fi

    chmod +x "$BIN_DIR/$name"
}

# Installs any CPAN modules a tool needs that aren't pulled in automatically
# (e.g. nikto needs JSON and XML::Writer). This fetches pure-Perl modules
# (no XS/C to compile) straight from MetaCPAN and drops their lib/ files
# into PERL5LIB directly, skipping cpanm's build step entirely.
# TODO (Faz 4): re-check whether plain cpanm works fine on Arch's perl and
# this whole workaround can be simplified/removed.
install_perl_modules()
{
    local modules="$1" mod missing=""
    local perl_log="$HOME/.solukos/logs/perl_modules.log"
    local perl_lib="$HOME/perl5/lib/perl5"

    for mod in $modules; do
        PERL5LIB="$perl_lib:$PERL5LIB" perl -M"$mod" -e1 >/dev/null 2>&1 || missing="$missing $mod"
    done

    [ -z "$missing" ] && return 0

    soluk_info "Installing Perl modules:$missing"

    command -v curl >/dev/null 2>&1 || sudo pacman -S --noconfirm curl >/dev/null 2>&1

    mkdir -p "$perl_lib"
    mkdir -p "$(dirname "$perl_log")"

    for mod in $missing; do
        local dl_url tmp_dir dist_dir rel_path
        {
            echo "=== $(date +"%Y-%m-%d %H:%M:%S") - $mod ==="

            local api_resp curl_rc
            api_resp=$(curl -sS -L --max-time 15 -A "SolukOS-installer/1.0" -w '\n__HTTP_STATUS__:%{http_code}' "https://fastapi.metacpan.org/v1/download_url/$mod" 2>&1)
            curl_rc=$?
            echo "curl exit code: $curl_rc"
            echo "response: $api_resp"
            dl_url=$(echo "$api_resp" | sed -n 's/.*"download_url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
            echo "download_url: $dl_url"

            if [ -z "$dl_url" ]; then
                echo "MetaCPAN'dan indirme linki alinamadi."
            else
                tmp_dir="$HOME/.solukos/tmp/perlmod_$$_$RANDOM"
                rm -rf "$tmp_dir"
                mkdir -p "$tmp_dir"

                curl -sS -L --max-time 60 -A "SolukOS-installer/1.0" "$dl_url" -o "$tmp_dir/dist.tar.gz"
                echo "tarball size: $(wc -c < "$tmp_dir/dist.tar.gz" 2>/dev/null) bytes"

                if tar xzf "$tmp_dir/dist.tar.gz" -C "$tmp_dir"; then
                    dist_dir=$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d | head -1)

                    if [ -n "$dist_dir" ] && [ -d "$dist_dir/lib" ]; then
                        # Pure-Perl module (no XS/C parts to compile), so we
                        # skip cpanm's Configure/build step entirely and just
                        # drop its lib/ files into PERL5LIB. This sidesteps a
                        # cpanm bug seen on the old Termux perl build where running
                        # Makefile.PL misfires and tries to re-"fetch" it as
                        # if it were its own tarball (gzip/tar error), even
                        # though the real distribution downloads fine.
                        cp -r "$dist_dir/lib/." "$perl_lib/"
                        echo "Copied $dist_dir/lib/ -> $perl_lib/"
                    elif [ -n "$dist_dir" ] && [ -f "$dist_dir/$(basename "$(echo "$mod" | sed 's#::#/#g')").pm" ]; then
                        # Older/flat-style distributions (e.g. XML::Writer)
                        # ship the .pm file straight in the dist root instead
                        # of under lib/ - normally MakeMaker works out the
                        # right nested install path (XML/Writer.pm) during
                        # `make install`, but since we skip that step we
                        # compute it ourselves from the module name we
                        # already know we're installing.
                        rel_path="$(echo "$mod" | sed 's#::#/#g').pm"
                        mkdir -p "$perl_lib/$(dirname "$rel_path")"
                        cp "$dist_dir/$(basename "$rel_path")" "$perl_lib/$rel_path"
                        echo "Copied $dist_dir/$(basename "$rel_path") -> $perl_lib/$rel_path"
                    else
                        echo "lib/ dizini bulunamadi - bu modul muhtemelen derleme gerektiriyor. Manuel dene: cpanm $mod"
                    fi
                else
                    echo "tar extraction failed for $dl_url"
                fi

                rm -rf "$tmp_dir"
            fi
        } >> "$perl_log" 2>&1

        if PERL5LIB="$perl_lib:$PERL5LIB" perl -M"$mod" -e1 >/dev/null 2>&1; then
            soluk_ok "$mod installed."
        else
            soluk_warn "$mod otomatik kurulamadi. Detay icin: cat ~/.solukos/logs/perl_modules.log"
        fi
    done
}

remove_git_tool()
{
    local name="$1"
    rm -rf "$TOOLS_DIR/$name"
    rm -f "$BIN_DIR/$name"
    soluk_ok "$name removed."
    command -v log >/dev/null 2>&1 && log "External tool removed: $name"
}

update_git_tool()
{
    local name="$1" runtime="$2" entry="$3" modules="$4"
    local before after

    if [ ! -d "$TOOLS_DIR/$name" ]; then
        soluk_warn "$name kurulu degil. Once 'soluk pkg install $name' calistir."
        return 1
    fi

    soluk_info "Updating $name..."

    before="$(git -C "$TOOLS_DIR/$name" rev-parse HEAD 2>/dev/null)"

    if git -C "$TOOLS_DIR/$name" pull --ff-only >/dev/null 2>&1; then
        after="$(git -C "$TOOLS_DIR/$name" rev-parse HEAD 2>/dev/null)"

        write_wrapper "$name" "$runtime" "$entry"
        if [ "$runtime" = "perl" ] && [ -n "$modules" ]; then
            install_perl_modules "$modules"
        fi

        if [ "$before" = "$after" ]; then
            soluk_ok "$name already up to date."
        else
            soluk_ok "$name updated."
        fi
        command -v log >/dev/null 2>&1 && log "External tool updated: $name"
    else
        soluk_warn "Update failed (git pull). Check your internet connection."
    fi
}

case "$NAME" in

sqlmap)
    URL="https://github.com/sqlmapproject/sqlmap.git"
    RUNTIME="python3"
    ENTRY="sqlmap.py"
    MODULES=""
    ;;

nikto)
    URL="https://github.com/sullo/nikto.git"
    RUNTIME="perl"
    ENTRY="program/nikto.pl"
    MODULES="JSON XML::Writer"
    ;;

*)
    soluk_warn "'$NAME' icin otomatik kurulum tanimli degil. Manuel kurulum gerekli."
    exit 1
    ;;

esac

case "$ACTION" in
install) install_git_tool "$NAME" "$URL" "$RUNTIME" "$ENTRY" "$MODULES" ;;
remove)  remove_git_tool "$NAME" ;;
update)  update_git_tool "$NAME" "$RUNTIME" "$ENTRY" "$MODULES" ;;
*)       soluk_warn "Bilinmeyen islem: $ACTION" ;;
esac

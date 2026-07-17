#!/data/data/com.termux/files/usr/bin/bash
# Installs/removes external security tools that aren't real Termux packages
# (they're not in the Termux repos, so `pkg install` can't get them).
# Clones the upstream repo and drops a wrapper command in $PREFIX/bin so
# the tool works like any other installed command afterwards.
#
# Usage: external_install.sh <install|remove> <tool-name>

BASE_DIR="$(cat ~/.solukos/install_path 2>/dev/null)"
source "$BASE_DIR/scripts/lib/ui.sh"
[ -f "$BASE_DIR/scripts/logger.sh" ] && source "$BASE_DIR/scripts/logger.sh"

ACTION="$1"
NAME="$2"

TOOLS_DIR="$HOME/.solukos/tools"
BIN_DIR="/data/data/com.termux/files/usr/bin"

install_git_tool()
{
    local name="$1" url="$2" runtime="$3" entry="$4" modules="$5"

    if ! command -v git >/dev/null 2>&1; then
        soluk_warn "git bulunamadi. 'pkg install git' ile kurup tekrar dene."
        return 1
    fi

    if ! command -v "$runtime" >/dev/null 2>&1; then
        soluk_info "$runtime kuruluyor..."
        pkg install "$runtime" -y
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

# Writes/refreshes the $PREFIX/bin wrapper for a tool. Called both on a
# fresh install and when re-running install on an already-cloned tool, so
# older wrappers (e.g. missing PERL5LIB) get upgraded automatically too.
write_wrapper()
{
    local name="$1" runtime="$2" entry="$3"

    if [ "$runtime" = "perl" ]; then
        cat > "$BIN_DIR/$name" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
export PERL5LIB="\$HOME/perl5/lib/perl5:\$PERL5LIB"
$runtime "$TOOLS_DIR/$name/$entry" "\$@"
WRAPPER
    else
        cat > "$BIN_DIR/$name" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
$runtime "$TOOLS_DIR/$name/$entry" "\$@"
WRAPPER
    fi

    chmod +x "$BIN_DIR/$name"
}

# Installs any CPAN modules a tool needs that Termux doesn't package natively
# (e.g. nikto needs JSON and XML::Writer). Both cpan and cpanm hit real
# problems on this Termux perl build, so for pure-Perl modules (no XS/C to
# compile) this fetches the tarball straight from MetaCPAN and drops its
# lib/ files into PERL5LIB directly, skipping cpanm's build step entirely.
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

    command -v curl >/dev/null 2>&1 || pkg install curl -y >/dev/null 2>&1

    mkdir -p "$perl_lib"
    mkdir -p "$(dirname "$perl_log")"

    for mod in $missing; do
        local dl_url tmp_dir dist_dir
        {
            echo "=== $(date +"%Y-%m-%d %H:%M:%S") - $mod ==="

            dl_url=$(curl -sL --max-time 15 "https://fastapi.metacpan.org/v1/download_url/$mod" | sed -n 's/.*"download_url":"\([^"]*\)".*/\1/p')
            echo "download_url: $dl_url"

            if [ -z "$dl_url" ]; then
                echo "MetaCPAN'dan indirme linki alinamadi."
            else
                tmp_dir="$HOME/.solukos/tmp/perlmod_$$_$RANDOM"
                rm -rf "$tmp_dir"
                mkdir -p "$tmp_dir"

                curl -sL --max-time 60 "$dl_url" -o "$tmp_dir/dist.tar.gz"

                if tar xzf "$tmp_dir/dist.tar.gz" -C "$tmp_dir"; then
                    dist_dir=$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d | head -1)

                    if [ -n "$dist_dir" ] && [ -d "$dist_dir/lib" ]; then
                        # Pure-Perl module (no XS/C parts to compile), so we
                        # skip cpanm's Configure/build step entirely and just
                        # drop its lib/ files into PERL5LIB. This sidesteps a
                        # cpanm bug on this Termux perl build where running
                        # Makefile.PL misfires and tries to re-"fetch" it as
                        # if it were its own tarball (gzip/tar error), even
                        # though the real distribution downloads fine.
                        cp -r "$dist_dir/lib/." "$perl_lib/"
                        echo "Copied $dist_dir/lib/ -> $perl_lib/"
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
*)       soluk_warn "Bilinmeyen islem: $ACTION" ;;
esac

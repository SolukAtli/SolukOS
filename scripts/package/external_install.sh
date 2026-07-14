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
# (e.g. nikto needs JSON and XML::Writer). Raw `cpan` is known to misbehave
# on Termux, so this bootstraps and uses cpanm instead, after making sure
# the build toolchain it needs (make, clang, curl) is present.
install_perl_modules()
{
    local modules="$1" mod missing=""

    for mod in $modules; do
        PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB" perl -M"$mod" -e1 >/dev/null 2>&1 || missing="$missing $mod"
    done

    [ -z "$missing" ] && return 0

    soluk_info "Installing Perl modules:$missing"
    soluk_warn "Bu islem birkac dakika surebilir (derleyici araclari da kurulacak)."

    command -v make  >/dev/null 2>&1 || pkg install make  -y >/dev/null 2>&1
    command -v clang >/dev/null 2>&1 || pkg install clang -y >/dev/null 2>&1
    command -v curl  >/dev/null 2>&1 || pkg install curl  -y >/dev/null 2>&1

    if ! command -v cpanm >/dev/null 2>&1 && [ ! -x "$HOME/perl5/bin/cpanm" ]; then
        soluk_info "Bootstrapping cpanm..."
        curl -sL https://cpanmin.us | perl - App::cpanminus >/dev/null 2>&1
    fi

    export PATH="$HOME/perl5/bin:$PATH"

    if ! command -v cpanm >/dev/null 2>&1; then
        soluk_warn "cpanm kurulamadi. Manuel kurulum gerekli:"
        soluk_warn "curl -L https://cpanmin.us | perl - App::cpanminus"
        return 1
    fi

    for mod in $missing; do
        cpanm --notest "$mod" >/dev/null 2>&1

        if PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB" perl -M"$mod" -e1 >/dev/null 2>&1; then
            soluk_ok "$mod installed."
        else
            soluk_warn "$mod otomatik kurulamadi. Manuel dene: cpanm $mod"
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

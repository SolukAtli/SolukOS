#!/usr/bin/env bash
# SolukOS - remote version check helper.
#
# This never applies updates by itself - it only tells the user one is
# available (via "soluk doctor" and a cached shell-startup notice). The
# actual update still requires running "soluk update" deliberately.

# Echoes the raw GitHub URL for this repo's VERSION file on the "main"
# branch, derived from the git remote. Handles https, ssh, and
# https URLs with embedded credentials. Returns non-zero if it can't tell.
soluk_remote_version_url()
{
    local base_dir="$1" origin owner_repo branch="main"

    origin=$(git -C "$base_dir" remote get-url origin 2>/dev/null)
    [ -z "$origin" ] && return 1

    case "$origin" in
        *github.com:*) owner_repo="${origin#*github.com:}" ;;
        *github.com/*) owner_repo="${origin#*github.com/}" ;;
        *) return 1 ;;
    esac

    owner_repo="${owner_repo%.git}"
    [ -z "$owner_repo" ] && return 1

    echo "https://raw.githubusercontent.com/$owner_repo/$branch/VERSION"
}

# Echoes the remote VERSION (trimmed), or nothing on any failure -
# offline, no git, private repo, blocked network, etc all just yield
# empty output. Also rejects anything that doesn't look like a plain
# version number (e.g. an error page or proxy message caught by curl).
soluk_fetch_remote_version()
{
    local base_dir="$1" url raw

    command -v curl >/dev/null 2>&1 || return 0
    url=$(soluk_remote_version_url "$base_dir") || return 0
    [ -z "$url" ] && return 0

    raw=$(curl -sL --max-time 5 "$url" 2>/dev/null | tr -d '[:space:]')

    if [[ "$raw" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
        echo "$raw"
    fi
}

# Synchronous check + soluk_warn if outdated. Requires ui.sh to already
# be sourced by the caller. Used by "soluk doctor".
soluk_check_update()
{
    local base_dir="$1" local_version remote_version

    local_version=$(cat "$base_dir/VERSION" 2>/dev/null)
    remote_version=$(soluk_fetch_remote_version "$base_dir")

    [ -z "$remote_version" ] && return 0
    [ "$local_version" = "$remote_version" ] && return 0

    soluk_warn "Update available: v$remote_version (you have v$local_version). Run 'soluk update' from the Manager."
}

# Background/cached check for shell startup: only actually hits the
# network once every 24h, caching the result to ~/.solukos/update_check
# for soluk_print_update_notice to read later without a network call.
soluk_background_update_check()
{
    local base_dir="$1"
    local cache_file="$HOME/.solukos/update_check"
    local now last_check local_version remote_version

    now=$(date +%s)

    if [ -f "$cache_file" ]; then
        last_check=$(head -1 "$cache_file" 2>/dev/null)
        if [ -n "$last_check" ] && [ $((now - last_check)) -lt 86400 ]; then
            return 0
        fi
    fi

    local_version=$(cat "$base_dir/VERSION" 2>/dev/null)
    remote_version=$(soluk_fetch_remote_version "$base_dir")

    mkdir -p "$HOME/.solukos"
    {
        echo "$now"
        [ -n "$remote_version" ] && [ "$remote_version" != "$local_version" ] && echo "$remote_version"
    } > "$cache_file"
}

# Prints a soluk_warn notice if the last background check found a newer
# version. Reads the local cache only - no network call here. Requires
# ui.sh to already be sourced by the caller.
soluk_print_update_notice()
{
    local cache_file="$HOME/.solukos/update_check" remote_version

    [ -f "$cache_file" ] || return 0
    remote_version=$(sed -n '2p' "$cache_file" 2>/dev/null)
    [ -z "$remote_version" ] && return 0

    soluk_warn "SolukOS v$remote_version is available - run 'soluk update' from the Manager."
}

# Allows "bash update_check.sh __bg_check <base_dir>" to kick off just the
# background check as a one-off process (e.g. from zshrc), without this
# doing anything extra when the file is merely sourced for its functions.
if [ "${BASH_SOURCE[0]}" = "$0" ] && [ "$1" = "__bg_check" ]; then
    soluk_background_update_check "$2"
fi

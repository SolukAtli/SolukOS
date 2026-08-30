## 🌫️ SolukOS

A custom-built, USB-bootable Arch Linux distribution — two desktop
environments, one identity.

## 📌 About

SolukOS started as a personal, security-flavored customization layer for
Termux on Android. It has since grown into something else entirely:
**SolukOS Linux**, a real, installable Arch-based distro with two full
desktop spins —

- **KDE Plasma** ([`iso/`](iso)) — the original, more mature spin, with a
  working Calamares installer.
- **Hyprland** ([`iso-hyprland/`](iso-hyprland)) — a newer, TUI-forward
  spin built around a quieter, more atmospheric desktop.

This repo root (`scripts/`, `bin/soluk`, `plugins/`, `packages/`) is the
`soluk` CLI — a small package-manager-and-plugin layer on top of `pacman`
that ships pre-installed inside both spins. `iso/` and `iso-hyprland/`
are the actual `archiso` profiles that turn all of this into a bootable
`.iso`.

The cybersecurity-toolkit framing from the Termux days is gone — that's
not what this project is about anymore. `soluk pkg install` can still
pull in a couple of external tools that aren't in the official Arch
repos, but it's not something we build the project's identity around.

## 🧭 What makes SolukOS different

Most personal Hyprland/Linux "rice" projects stop at a dotfiles repo you
clone and symlink into an existing install. SolukOS goes further than
that on purpose:

- **A real, installable OS, not just dotfiles.** Boot splash (Plymouth),
  login screen (SDDM), installer (Calamares) and the desktop itself are
  all part of the same build — not "apply these configs after you've
  already installed Arch yourself."
- **One identity, two desktops.** "Soluk" (muted, faded, breath-like) is
  a real design language — a specific color palette, a shared theme
  system, one mascot — carried consistently across both KDE and
  Hyprland, not just a wallpaper.
- **Deliberately quiet, not flashy.** The Hyprland spin leans on TUI
  tools (`rmpc`, `yazi`, `fastfetch`) and a muted palette instead of
  glassmorphism/gradient trends — a calmer, more "terminal" feel by
  choice.

This is still being figured out — see [Roadmap](#️-roadmap) for where
it's headed next.

## ✨ Features

**`soluk` CLI (both spins)**
- ⚙️ Interactive manager menu, or direct commands (see below)
- 📦 Package manager on top of `pacman`, with a plugin system
  (git-based installer, enable/disable, dependency resolution)
- 🌐 Repository system — pull extra package sources from remote URLs
- 🔔 Daily, cached update-check (never installs anything on its own)
- 🖼️ `soluk fetch` system summary, `soluk doctor` health check
- 💡 fzf-powered menus, zoxide/eza/bat, colorized UI throughout

**Hyprland spin**
- 🎭 Theme Manager (Soluk, Matrix, Nord) — switches waybar, mako, and
  the rest of the palette together
- 🎵 `rmpc` (TUI music player) + `mpd`, themed to match
- 📁 `yazi` (TUI file manager), themed to match
- 🪟 Custom waybar, hyprlock, hypridle, fastfetch identity panel,
  figlet-based clock widget

**KDE Plasma spin**
- 🖥️ Full Plasma desktop, Calamares installer with SolukOS branding

## 🚀 Installation

```
git clone https://github.com/solukatli/solukos.git
cd solukos
chmod +x install.sh
./install.sh
```

To build a bootable ISO instead of just installing the CLI, see
[`iso/README.md`](iso/README.md) (KDE spin — Hyprland spin's own README
is still on the roadmap, build steps are the same pattern via
`.github/workflows/build-iso-hyprland.yml` in the meantime).

## 💻 Available Commands

Running `soluk` with no arguments opens the interactive Manager menu.

**System**
- `soluk version` / `soluk doctor` / `soluk fetch` / `soluk update` / `soluk reload` / `soluk help`

**Packages**
- `soluk pkg list` / `search <name>` / `info <name>` / `install <name>` / `remove <name>` / `update [name]` / `check`

**Themes** (Hyprland spin only)
- `soluk theme list` / `soluk theme set <name>` / `soluk theme create <name>`

**Shell tools** (no `soluk` prefix — built into the terminal)
- `z <folder>` (zoxide) · `ll` / `lt` (eza) · `cat <file>` (bat) · `Ctrl+R` / `Ctrl+T` / `Alt+C` (fzf)

Full setup walkthrough: [`docs/installation.md`](docs/installation.md).

## 🛠 Project Structure

```
solukos/
├── bin/soluk           # the CLI itself
├── scripts/            # soluk's internals (menus, package/plugin logic)
├── packages/           # soluk's own package database
├── plugins/            # soluk's plugin system
├── docs/
├── iso/                # KDE Plasma spin (archiso profile)
├── iso-hyprland/       # Hyprland spin (archiso profile)
└── install.sh
```

## 🗺️ Roadmap

**Done**
- [x] `soluk` CLI: packages, plugins, themes, repositories, update checks
- [x] KDE Plasma spin: bootable ISO, Calamares installer
- [x] Hyprland spin: waybar, hyprlock/hypridle, theme system, rmpc, yazi, fastfetch, clock widget

**In progress**
- [ ] Hyprland spin: Calamares installer (KDE spin has this already, Hyprland doesn't yet)
- [ ] Hyprland spin: persistent storage on the live USB
- [ ] Hyprland spin: Plymouth boot splash
- [ ] `iso-hyprland/README.md` (parity with `iso/README.md`)

**v1.0 Linux**
- [ ] Both spins installable, persistent, and polished to the same level
- [ ] One consistent "soluk" identity from boot to desktop, on both spins

**Under consideration**
- [ ] Some form of mobile-side companion/integration — not scoped yet

## ⚠️ Disclaimer

SolukOS is intended for Linux learning, scripting practice, and desktop
customization. Users are responsible for ensuring that all activities
are lawful and authorized.

## 📜 Version

Current Version: v1.0.0



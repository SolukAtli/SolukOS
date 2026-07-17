## 🌫️ SolukOS

A lightweight, modular and cybersecurity-focused environment built on Termux.

## 📌 About

SolukOS is a personal open-source project designed to provide a Linux-inspired experience on Android through Termux.

The project combines terminal customization, package management, plugin support and system utilities into a single environment for learning Linux, cybersecurity concepts and shell scripting.

## ✨ Features

- 🐧 Linux-style terminal experience
- 🌫️ Custom SolukOS branding
- 📦 Built-in package management
- 🧩 Plugin system with a git-based remote installer
- ⚙️ SolukOS command-line interface
- 🔍 Package search and information tools
- 🩺 System diagnostics ("doctor")
- 📋 Package database support
- 🚀 Modular architecture
- 💡 fzf-powered menus and shell history/file search
- ⚡ Smart navigation with zoxide, modern `ls`/`cat` via eza and bat
- 🖼️ `soluk fetch` system summary screen
- 🎨 Consistent, colorized UI across every menu and screen
- 🎭 Theme Manager (Soluk, Matrix, Nord) via Settings
- 🕵️ Automated install for external security tools not in Termux repos (sqlmap, nikto)
- 🛡️ Confirmation prompt before uninstalling, auto-synced zsh config on update, real system logging
- 🔗 Package dependency resolution (auto-installs what a package needs first)
- 🌐 Repository system — sync extra packages into the database from remote URLs
- 🔔 Update notifications — lets you know when a newer SolukOS version is out (never updates on its own)

## 🚀 Installation

```git clone https://github.com/SolukAtli/SolukOS.git
cd SolukOS
chmod +x install.sh
./install.sh
```

## 💻 Available Commands

Running `soluk` with no arguments opens the interactive Manager menu. Unknown commands print an error instead of opening the menu.

**System**
- soluk version
- soluk doctor
- soluk reload
- soluk fetch
- soluk update
- soluk help

**Packages**
- soluk pkg list
- soluk pkg search `<package>`
- soluk pkg info `<package>`
- soluk pkg install `<package>`
- soluk pkg remove `<package>`
- soluk pkg check
- soluk pkg update

**Shell tools** (built into your terminal, no `soluk` prefix)
- `z <folder>` — jump to a frequent directory (zoxide)
- `ll` / `lt` — list files with icons (eza)
- `cat <file>` — preview a file, highlighted (bat)
- `Ctrl+R` / `Ctrl+T` / `Alt+C` — search history / files / cd (fzf)

**Settings → Theme Manager**
- Soluk (default) — muted grays, desaturated blue/gold
- Matrix — classic black/green hacker terminal
- Nord — cool blue-gray minimalist palette

**Package Manager → Install Package** (`sqlmap`, `nikto`)
- Not in the Termux repos, so these are cloned from their upstream git repo into `~/.solukos/tools/` with a wrapper command dropped into `$PREFIX/bin`
- `nikto` also needs a couple of CPAN-only Perl modules (JSON, XML::Writer) — installed automatically via `cpanm` (bootstrapped if missing), even on a re-run if they were missing before
- Works the same from `soluk pkg install sqlmap`, the Package Manager menu, or Security Toolkit's "Install All Tools"

**Update notifications**
- `soluk doctor` checks your version against GitHub and warns if you're behind
- A background check also runs once a day at shell startup (cached, throttled - doesn't slow down opening a terminal) and shows a one-line notice if a newer version exists
- Nothing is ever downloaded or applied automatically - you still choose when to run "soluk update"

**Package Manager → Repository Manager**
- `packages/sources.txt` lists URLs to remote `database.txt`-format files (pipe-delimited, same schema)
- "Update Repositories" fetches each source and adds any packages that don't already exist locally by name — existing entries are never overwritten
- Add/remove sources from the same menu, or via `soluk pkg update`

**Package Manager → dependencies**
- `packages/database.txt` entries can list required packages: `name|category|type|status|deps`
- Installing a package (via `soluk pkg install`, the Package Manager menu, or Security Toolkit) resolves and installs any missing deps first
- `soluk pkg info <name>` / Package Manager → Package Info show the "Depends" field

**Plugin Manager → Install from Git**
- Clones any git repo containing a `plugin.sh` into your installed plugins
- Rejects repos without a `plugin.sh`, strips `.git` after cloning
- ⚠️ Only install plugins from sources you trust — `plugin.sh` runs directly

**Plugin Manager → Disable / Enable Plugin**
- Temporarily turns a plugin off without uninstalling it (keeps its files, just moves it aside)
- Disabled plugins show up grayed out in "List Plugins" and can't be run until re-enabled

## 🛠 Project Structure

- SolukOS/
- ├── scripts/
- ├── packages/
- ├── plugins/
- ├── docs/
- ├── assets/
- ├── config/
- └── install.sh

## 🗺️ Roadmap

v0.6.1

- [x] Package Manager
- [x] CLI Commands
- [x] Package Search
- [x] Package Information
- [x] Package Installation
- [x] Package Removal
- [x] Doctor Command
- [x] Version Command

v0.7.0

- [x] Help Command
- [x] Update Command
- [x] Improved Diagnostics
- [x] zsh-autosuggestions / zsh-syntax-highlighting
- [x] fzf history & file search (CTRL+R / CTRL+T / ALT+C)
- [x] zoxide, bat, eza
- [x] soluk fetch
- [x] Consistent colorized UI across all menus
- [x] Theme Manager
- [x] Git-based remote Plugin Installer
- [x] Automated install for sqlmap / nikto
- [x] Plugin Enable/Disable

v0.8.0

- [x] Package Dependency Support
- [x] Repository System
- [x] Automatic Updates

v1.0.0 — First Stable Release

- [x] All v0.8.0 roadmap features complete
- [x] Fresh install tested end-to-end (Full Install)
- [x] `soluk doctor` passes all checks
- [x] Patch 21-25 fixes verified on-device
- [x] `docs/installation.md` reviewed for accuracy
- [x] Final bug sweep (logo and nikto Perl modules are explicitly out of scope for v1.0.0)

## ⚠️ Disclaimer

SolukOS is intended for Linux learning, scripting practice, terminal customization and cybersecurity education.

Users are responsible for ensuring that all activities are lawful and authorized.

## 📜 Version

Current Version: v1.0.0

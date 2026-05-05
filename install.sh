#!/usr/bin/env bash
# Install prerequisites for this Neovim config.
# Detects apt / pacman / dnf / brew and installs the matching packages.
# Safe to re-run: package managers handle already-installed packages.

set -euo pipefail

err()  { printf 'error: %s\n' "$*" >&2; exit 1; }
info() { printf '==> %s\n' "$*"; }

if [ "$(uname -s)" = "Darwin" ]; then
    command -v brew >/dev/null || err "Homebrew not found. Install from https://brew.sh first."
    info "Detected macOS — installing via Homebrew"
    brew install git ripgrep fd cmake node
    info "Done. Install a Nerd Font and select it in your terminal — see README."
    exit 0
fi

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

if command -v apt-get >/dev/null 2>&1; then
    info "Detected apt — installing for Debian/Ubuntu"
    $SUDO apt-get update
    $SUDO apt-get install -y \
        git ripgrep fd-find build-essential cmake unzip curl nodejs npm
    # Debian ships fd as `fdfind`; symlink so Telescope finds it.
    if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
        info "Symlinking fdfind -> /usr/local/bin/fd"
        $SUDO ln -s "$(command -v fdfind)" /usr/local/bin/fd
    fi
elif command -v pacman >/dev/null 2>&1; then
    info "Detected pacman — installing for Arch"
    $SUDO pacman -S --needed --noconfirm \
        git ripgrep fd base-devel cmake unzip curl nodejs npm
elif command -v dnf >/dev/null 2>&1; then
    info "Detected dnf — installing for Fedora/RHEL"
    $SUDO dnf install -y \
        git ripgrep fd-find gcc gcc-c++ make cmake unzip curl nodejs npm
else
    err "No supported package manager found (looked for apt, pacman, dnf, brew)."
fi

info "Done. Install a Nerd Font and select it in your terminal — see README."

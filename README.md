# Neovim Config

Personal Neovim setup based on ThePrimeagen's init.lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim). Tested on WSL Ubuntu and Linux.

## Prerequisites

System packages:

- `git`
- `ripgrep` — Telescope live grep
- `fd` — Telescope file finder
- `make`, a C compiler (`gcc` or `clang`), `cmake`, `unzip` — needed to build telescope-fzf-native, LuaSnip's `jsregexp`, and treesitter parsers
- `curl` — Mason
- `node` and `npm` — several LSP servers Mason installs are JS-based
- `xclip` (X11) and/or `wl-clipboard` (Wayland) — required for `<leader>y` to reach the system clipboard. WSL users don't need these; Neovim auto-uses `clip.exe` from `/mnt/c/Windows/System32` if it's on `PATH`.
- A [Nerd Font](https://www.nerdfonts.com/) installed and selected in your terminal — for statusline / nvim-tree icons

Neovim 0.9+ recommended.

### Install commands

Easiest path — run the bundled script after cloning. It detects your package manager (apt / pacman / dnf / brew) and installs everything except the Nerd Font:

```sh
./install.sh
```

Or do it manually:

Ubuntu/Debian:
```sh
sudo apt update && sudo apt install -y git ripgrep fd-find build-essential cmake unzip curl nodejs npm
# Debian ships fd as `fdfind`; symlink so Telescope finds it:
sudo ln -s "$(which fdfind)" /usr/local/bin/fd
```

Arch:
```sh
sudo pacman -S --needed git ripgrep fd base-devel cmake unzip curl nodejs npm
```

Fedora/RHEL:
```sh
sudo dnf install -y git ripgrep fd-find gcc gcc-c++ make cmake unzip curl nodejs npm
```

macOS (Homebrew):
```sh
brew install git ripgrep fd cmake node
```

### Nerd Font setup (manual)

The statusline and nvim-tree icons need a Nerd Font. The install script does **not** handle this — fonts are a terminal/OS concern.

1. Pick a font from <https://www.nerdfonts.com/> (good defaults: JetBrainsMono, FiraCode, Hack).
2. Install it:
   - **Linux**: drop the `.ttf` files into `~/.local/share/fonts/`, then `fc-cache -fv`.
   - **macOS**: `brew install --cask font-jetbrains-mono-nerd-font` (or your chosen font).
   - **Windows / WSL**: install the font on Windows (right-click `.ttf` → Install). For WSL the font is selected in the *Windows* terminal app, not inside Linux.
3. Set your terminal emulator to use the Nerd Font.
4. Restart your terminal and reopen Neovim — icons should render. If you see boxes or `?`, the terminal isn't using the Nerd Font.

### Optional

- `tmux` plus a `tmux-sessionizer` script in `PATH` — enables the `<C-f>` keymap to launch it. Without it, `<C-f>` falls back to default page-forward.

## Install

```sh
git clone <this-repo> ~/.config/nvim
cd ~/.config/nvim
./install.sh   # installs system packages
nvim           # first launch bootstraps lazy.nvim and plugins
```

On first launch:

1. lazy.nvim bootstraps itself into `~/.local/share/nvim/lazy/`.
2. Plugins from `lua/theprimeagen/lazy/` install per the pinned versions in `lazy-lock.json`.
3. Mason installs configured LSP servers.
4. Treesitter installs configured parsers (compiles from source — needs the C toolchain above).

Quit and reopen once installs settle. Subsequent launches are fast and reproducible from the lockfile.

## Notes

- Leader key is `<Space>`.
- LSP keymaps are set in the `LspAttach` autocmd in `lua/theprimeagen/init.lua` (`gd`, `K`, `<leader>v...`).
- Terminal keymaps live in `lua/theprimeagen/terminal.lua` (`<space>tf` float, `<space>tr` right, `<space>tt` toggle, `<space>tl` left, `<space>to` bottom).
- Plugin specs live one-per-file under `lua/theprimeagen/lazy/`.

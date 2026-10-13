#!/usr/bin/env bash
#
# Set up this dotfiles repo on an Arch-based machine (Arch, CachyOS, EndeavourOS, ...).
# Safe to run again: links are refreshed, existing files are backed up first,
# and packages/plugins that are already installed are skipped.
#
# Usage: ./install.sh [--skip-packages] [--skip-nvim] [--help]

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
SKIP_PACKAGES=0
SKIP_NVIM=0

PACKAGES=(
    # Shell & terminal tools
    fish tmux starship zoxide fzf eza bat ripgrep fd lazygit ranger
    # Editor + what its plugins build or run with
    neovim git base-devel unzip curl wget tree-sitter-cli luarocks
    nodejs npm python python-pip python-poetry rustup clang
    # Desktop (Wayland): clipboard, launcher, notifications, fonts
    wl-clipboard rofi libnotify ttf-jetbrains-mono-nerd ttf-meslo-nerd
    # Desktop widget (glass system monitor)
    conky ttf-opensans
)

# Treesitter parsers (keep in sync with nvim/lua/plugins/treesitter.lua)
TS_PARSERS="'lua','python','javascript','typescript','vimdoc','vim','regex','terraform','sql','dockerfile','toml','json','java','groovy','go','gitignore','graphql','yaml','make','cmake','markdown','markdown_inline','bash','tsx','css','html','c','cpp'"
# none-ls formatters/linters + debugger (the LSP servers come from :MasonToolsInstallSync)
MASON_EXTRA="prettier eslint_d clang-format shfmt checkmake debugpy"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*"; }

usage() {
    sed -n '3,7p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

for arg in "$@"; do
    case "$arg" in
    --skip-packages) SKIP_PACKAGES=1 ;;
    --skip-nvim) SKIP_NVIM=1 ;;
    -h | --help) usage ;;
    *)
        echo "unknown option: $arg" >&2
        exit 1
        ;;
    esac
done

# Link $DOTFILES/$1 to $2, moving anything already there into $BACKUP_DIR.
link() {
    local src="$DOTFILES/$1" dest="$2"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        return
    fi
    if [[ -e "$dest" || -L "$dest" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
        warn "moved existing $dest to $BACKUP_DIR/"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    info "linked $dest -> $src"
}

install_packages() {
    if ! command -v pacman >/dev/null; then
        warn "pacman not found; install these yourself: ${PACKAGES[*]}"
        return
    fi
    info "Installing packages (sudo)"
    sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

    if ! rustup show active-toolchain >/dev/null 2>&1; then
        info "Installing the stable Rust toolchain"
        rustup default stable
    fi
}

link_configs() {
    info "Linking configs"
    link nvim "$HOME/.config/nvim"
    link .tmux.conf "$HOME/.tmux.conf"
    link .clang-format "$HOME/.clang-format"
    link starship "$HOME/.config/starship"
    link rofi "$HOME/.config/rofi"
    link conky "$HOME/.config/conky"
    link conky/conky.service "$HOME/.config/systemd/user/conky.service"
    systemctl --user daemon-reload 2>/dev/null &&
        systemctl --user enable conky.service >/dev/null 2>&1 ||
        warn "could not enable conky.service; run: systemctl --user enable --now conky.service"
    link fish/conf.d "$HOME/.config/fish/conf.d"
    link fish/functions "$HOME/.config/fish/functions"
}

# COSMIC keyboard shortcuts. Copied (not linked) because the path to the rofi script
# has to be absolute, and the COSMIC settings app rewrites this file in place.
install_cosmic_shortcuts() {
    local dest="$HOME/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom"
    local rendered
    rendered="$(sed "s|@HOME@|$HOME|g" "$DOTFILES/cosmic/shortcuts.ron")"

    if [[ -f "$dest" && "$(cat "$dest")" == "$rendered" ]]; then
        return
    fi
    if [[ -e "$dest" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp "$dest" "$BACKUP_DIR/cosmic-shortcuts-custom"
        warn "backed up existing COSMIC shortcuts to $BACKUP_DIR/cosmic-shortcuts-custom"
    fi
    mkdir -p "$(dirname "$dest")"
    printf '%s\n' "$rendered" >"$dest"
    info "installed COSMIC shortcuts (Super+Space: rofi hub, Super+Return: terminal)"
}

setup_tmux() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "Installing tpm"
        git clone -q --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
    info "Installing tmux plugins"
    # Use a private tmux socket dir so a tmux server that is already running doesn't redirect the install.
    local sock_dir
    sock_dir="$(mktemp -d)"
    TMUX_TMPDIR="$sock_dir" "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null
    rm -rf "$sock_dir"
}

setup_nvim() {
    info "Installing Neovim plugins (versions from lazy-lock.json)"
    # Headless Neovim can exit non-zero while Mason is still working in the background;
    # the explicit Mason/treesitter steps below finish the job, so ignore that here.
    nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || true

    info "Installing language servers, formatters and debuggers (Mason)"
    nvim --headless -c "MasonToolsInstallSync" -c "MasonInstall $MASON_EXTRA" -c qa >/dev/null 2>&1 ||
        warn "some Mason packages failed; open nvim and check :Mason"

    info "Installing treesitter parsers"
    nvim --headless -c "lua require('nvim-treesitter').install({ $TS_PARSERS }):wait(900000)" -c qa >/dev/null 2>&1 ||
        warn "some treesitter parsers failed; open nvim and run :TSUpdate"
}

set_login_shell() {
    local fish_path
    fish_path="$(command -v fish || true)"
    [[ -z "$fish_path" ]] && return
    # Compare by name: /bin/fish and /usr/bin/fish are the same binary on Arch.
    if [[ "$(basename "$(getent passwd "$USER" | cut -d: -f7)")" != fish ]]; then
        info "Setting fish as your login shell"
        chsh -s "$fish_path" || warn "could not change shell; run: chsh -s $fish_path"
    fi
}

check_git_identity() {
    if [[ -z "$(git config --global user.name || true)" || -z "$(git config --global user.email || true)" ]]; then
        warn "git has no name/email yet. Run:"
        echo '    git config --global user.name "Your Name"'
        echo '    git config --global user.email "you@example.com"'
    fi
}

[[ $SKIP_PACKAGES -eq 0 ]] && install_packages
link_configs
install_cosmic_shortcuts
setup_tmux
[[ $SKIP_NVIM -eq 0 ]] && setup_nvim
set_login_shell
check_git_identity

info "Done. Open a new terminal (it starts fish inside tmux)."
if [[ -d "$BACKUP_DIR" ]]; then
    info "Replaced files were saved in $BACKUP_DIR"
fi

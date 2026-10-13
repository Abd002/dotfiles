# Environment (fish port of zsh/.zshenv)

# XDG Base directory specification
set -gx XDG_CONFIG_HOME $HOME/.config     # Config files
set -gx XDG_CACHE_HOME $HOME/.cache       # Cache files
set -gx XDG_DATA_HOME $HOME/.local/share  # Application data
set -gx XDG_STATE_HOME $HOME/.local/state # Logs and state files

# Themes (onedark or nord)
set -gx NVIM_THEME nord
set -gx STARSHIP_THEME nord

# Use Neovim as default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Starship config lives in its own folder
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml

# Pipenv
set -gx PIPENV_VENV_IN_PROJECT 1

# PATH: /usr/local/bin first, then user binaries (poetry, pipx, cargo)
fish_add_path /usr/local/bin $HOME/.local/bin $HOME/.cargo/bin

# Libraries installed from source with --prefix=/usr/local (e.g. libcups3):
# Arch's pkg-config only searches /usr/lib/pkgconfig and /usr/share/pkgconfig.
if test -d /usr/local/lib/pkgconfig; and not contains /usr/local/lib/pkgconfig $PKG_CONFIG_PATH
    set -gx --path PKG_CONFIG_PATH /usr/local/lib/pkgconfig $PKG_CONFIG_PATH
end

# Pyenv (optional)
if test -d $HOME/.pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
end

# Secrets: ~/.env with KEY=value lines (same file the zsh setup used, "export" prefix allowed)
if test -f $HOME/.env
    for line in (string match -rv '^\s*(#|$)' <$HOME/.env)
        set -l kv (string split -m1 = (string replace -r '^\s*export\s+' '' -- $line))
        test (count $kv) -eq 2; or continue
        set -gx $kv[1] (string trim -c '"\'' -- $kv[2])
    end
end

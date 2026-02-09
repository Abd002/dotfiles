# Ubuntu/WSL-safe zsh custom config

# Prevent errors like: no matches found: *:globbed-files
setopt nonomatch

# Init completion system EARLY (before any eval/init scripts)
autoload -Uz compinit
compinit

# Pipenv
export PIPENV_VENV_IN_PROJECT=1

# Poetry (optional)
export PATH="$HOME/.local/bin:$PATH"

# Pyenv (optional)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

# fzf (Ubuntu-provided scripts)
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# Starship (optional)
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# zoxide (optional)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Plugins (Ubuntu paths)
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

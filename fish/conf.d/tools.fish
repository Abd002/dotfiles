# Interactive tools (fish port of zsh/custom.zsh)
# fish has autosuggestions, syntax highlighting and git completion built in.
status is-interactive; or return

# Starship prompt
command -q starship; and starship init fish | source

# zoxide (z / zi)
command -q zoxide; and zoxide init fish | source

# fzf key bindings: Ctrl+R history, Ctrl+T files, Alt+C cd
command -q fzf; and fzf --fish | source

# Pyenv (optional)
command -q pyenv; and pyenv init - fish | source

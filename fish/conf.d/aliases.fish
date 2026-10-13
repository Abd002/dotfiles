# Aliases (fish port of zsh/aliases.zsh)
# Abbreviations expand when you press Space/Enter, so you see the real command.
status is-interactive; or return

# System
abbr -a shutdown 'systemctl poweroff'
abbr -a restart 'systemctl reboot'
abbr -a suspend 'systemctl suspend'
abbr -a c clear
abbr -a e exit

# Git
abbr -a g git
abbr -a ga 'git add'
abbr -a gafzf 'git ls-files -m -o --exclude-standard | grep -v "__pycache__" | fzf -m --print0 | xargs -0 -o -t git add' # Git add with fzf
abbr -a grmfzf 'git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git rm' # Git rm with fzf
abbr -a grfzf 'git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore' # Git restore with fzf
abbr -a grsfzf 'git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore --staged' # Git restore --staged with fzf
abbr -a gf 'git fetch'
abbr -a gs 'git status'
abbr -a gss 'git status -s'
abbr -a gup 'git fetch && git rebase'
abbr -a gtd 'git tag --delete'
abbr -a gtdr 'git tag --delete origin'
abbr -a glo 'git pull origin'
abbr -a gl 'git pull'
abbr -a gb 'git branch'
abbr -a gbr 'git branch -r'
abbr -a gd 'git diff'
abbr -a gco 'git checkout'
abbr -a gcob 'git checkout -b'
abbr -a gcofzf 'git branch | fzf | xargs git checkout' # Select branch with fzf
abbr -a gre 'git remote'
abbr -a gres 'git remote show'
abbr -a glgg 'git log --graph --max-count=5 --decorate --pretty="oneline"'
abbr -a gm 'git merge'
abbr -a gp 'git push'
abbr -a gpo 'git push origin'
abbr -a ggpush 'git push origin (git branch --show-current)'
abbr -a gc 'git commit -v'
abbr -a gcm 'git commit -m'
abbr -a gcmnv 'git commit --no-verify -m'
abbr -a gcanenv 'git commit --amend --no-edit --no-verify'
abbr -a gqc quick_commit
abbr -a gqcp 'quick_commit push'

# Neovim (v / vi use "poetry run nvim" inside poetry projects, see functions/v.fish)
alias vi v

# Folders
abbr -a doc 'cd ~/Documents'
abbr -a dow 'cd ~/Downloads'

# Lazygit
abbr -a lg lazygit

# Better ls (the CachyOS fish config already maps ls/la/ll/lt to eza, so only needed elsewhere)
if not test -f /usr/share/cachyos-fish-config/cachyos-config.fish; and command -q eza
    alias ls 'eza --all --icons=always'
    alias ll 'eza -l --all --icons=always --group-directories-first'
    alias lt 'eza -aT --icons=always --group-directories-first'
end

# Start every terminal inside tmux.
# Re-uses a detached session if one exists (so closed windows can be picked up again),
# otherwise starts a new one. Closing tmux closes the terminal window.
# Skipped inside tmux, Neovim's :terminal, the VS Code terminal, Linux TTYs and SSH,
# and when NO_TMUX is set (e.g. `NO_TMUX=1 cosmic-term`).
status is-interactive; or return
command -q tmux; or return

if set -q TMUX; or set -q NVIM; or set -q NO_TMUX; or set -q SSH_TTY
    return
end
if test "$TERM_PROGRAM" = vscode; or test "$TERM" = linux
    return
end

set -l detached (tmux list-sessions -F '#{session_attached} #{session_name}' 2>/dev/null | string match -rg '^0 (.+)$')
if set -q detached[1]
    exec tmux attach-session -t $detached[1]
else
    exec tmux new-session
end

# Commit with ticket ID from current branch (e.g. abc-123-foo -> "ABC-123: msg").
# "quick_commit push msg..." also pushes.
function quick_commit --description 'Commit with ticket ID from branch name, optionally push'
    set -l branch_name (git branch --show-current); or return
    set -l ticket_id (string upper (string join - (string split - $branch_name)[1..2]))

    if test "$argv[1]" = push
        git commit --no-verify -m "$ticket_id: $argv[2..]"; and git push
    else
        git commit --no-verify -m "$ticket_id: $argv"
    end
end

#!/usr/bin/env bash

FILE="$HOME/.projects.txt"
touch "$FILE"

values=$(cat "$FILE")
selected_value=$(printf "add\nrm\n%s\n" "$values" | rofi -dmenu -p "Projects:" -i)

if [[ "$selected_value" == "add" ]]; then
    result=$(rofi -dmenu -p "Enter path to add:")
    if [[ -n "$result" ]]; then
        clean_path="${result/#\~/$HOME}"
        echo "$clean_path" >>"$FILE"
    fi

elif [[ "$selected_value" == "rm" ]]; then
    to_remove=$(cat "$FILE" | rofi -dmenu -p "Select project to remove:")
    if [[ -n "$to_remove" ]]; then
        sed -i "\|^$to_remove$|d" "$FILE"
    fi

elif [[ -n "$selected_value" ]]; then
    clean_path="${selected_value/#\~/$HOME}"

    if [[ ! -d "$clean_path" ]]; then
        notify-send "Project not found" "$clean_path"
        exit 1
    fi

    win_name="$(basename "$clean_path")"

    # Pick the most recently attached tmux session, if one exists.
    session=$(
        tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null |
            sort -nr |
            awk 'NR==1 {print $2}'
    )

    if [[ -z "$session" ]]; then
        session="main"
        tmux new-session -d -s "$session" -c "$clean_path" -n "$win_name" nvim .
    else
        tmux new-window -t "$session:" -c "$clean_path" -n "$win_name" nvim .
    fi

    # Always show a terminal window attached to that session.
    cosmic-term -- tmux attach-session -t "$session"
fi

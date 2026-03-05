#!/bin/bash

# --- Configuration ---
FILE="$HOME/.projects.txt"
touch "$FILE"

# --- Logic ---
values=$(cat "$FILE")

# Prompt user for action or project selection
selected_value=$(echo -e "add\nrm\n$values" | rofi -dmenu -p "Projects:" -i)

# 1. ADD PROJECT
if [[ "$selected_value" == "add" ]]; then
    result=$(rofi -dmenu -p "Enter path to add:")
    if [ -n "$result" ]; then
        clean_path="${result/#\~/$HOME}"
        echo "$clean_path" >>"$FILE"
    fi

# 2. REMOVE PROJECT (The "Fail-Proof" Logic)
elif [[ "$selected_value" == "rm" ]]; then
    # We select from the file again to ensure we have the exact string
    to_remove=$(cat "$FILE" | rofi -dmenu -p "Select project to remove:")

    if [ -n "$to_remove" ]; then
        # Use 'sed' instead of 'grep' to delete the line.
        # It's often more reliable for exact line removal in scripts.
        sed -i "\|^$to_remove$|d" "$FILE"
    fi

# 3. OPEN PROJECT
elif [[ -n "$selected_value" ]]; then
    if [ -n "$TMUX" ]; then
        tmux new-window -c "$selected_value" -n "Editor" "nvim ."
    else
        cd "$selected_value" && nvim .
    fi
fi

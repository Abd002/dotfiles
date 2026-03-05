#!/bin/bash

FILE="$HOME/.notes.txt"
touch "$FILE"

# 1. Get the list
values=$(cat "$FILE")

# 2. Select snippet
selected_value=$(echo -e "add\nrm\n$values" | rofi -dmenu -p "Snippets:" -i)

if [[ "$selected_value" == "add" ]]; then
    result=$(rofi -dmenu -p "Enter snippet:")
    [[ -n "$result" ]] && echo "$result" >>"$FILE"

elif [[ "$selected_value" == "rm" ]]; then
    nvim "$FILE"

elif [[ -n "$selected_value" ]]; then
    # Get the ID of the window that was open BEFORE Rofi
    # Rofi usually unsets focus, so we wait for it to return
    sleep 0.3

    # Send the keys to the currently active window
    # --clearmodifiers ensures Shift/Alt/Ctrl aren't "stuck"
    xdotool type --clearmodifiers --delay 10 "$selected_value"
fi

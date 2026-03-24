#!/bin/bash

FILE="$HOME/.notes.txt"
touch "$FILE"

values=$(cat "$FILE")
selected_value=$(printf "add\nrm\n%s\n" "$values" | rofi -dmenu -p "Snippets:" -i)

if [[ "$selected_value" == "add" ]]; then
    result=$(rofi -dmenu -p "Enter snippet:")
    [[ -n "$result" ]] && echo "$result" >>"$FILE"

elif [[ "$selected_value" == "rm" ]]; then
    nvim "$FILE"

elif [[ -n "$selected_value" ]]; then
    printf '%s' "$selected_value" | wl-copy
    notify-send "Snippet copied" "$selected_value"
fi

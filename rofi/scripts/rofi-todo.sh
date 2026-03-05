#!/bin/sh
#
# A clean, hidden task manager for Rofi.
#

file="$HOME/.todo"
touch "$file"

# Minimalist theme string to keep it "hidden"
# This removes the prompt and keeps the window narrow
THEME_STR="window { width: 20%; } listview { fixed-height: false; } inputbar { children: [entry]; }"

prompt="Task: "

# Initial launch
cmd=$(rofi -dmenu -p "$prompt" -theme-str "$THEME_STR" "$@" <"$file")

while [ -n "$cmd" ]; do
    if grep -q "^$cmd\$" "$file"; then
        # If task exists, remove it
        grep -v "^$cmd\$" "$file" >"$file.$$"
        mv "$file.$$" "$file"
    else
        # If task is new, add it
        echo "$cmd" >>"$file"
    fi

    # Relaunch Rofi to show updated list until Esc is pressed
    cmd=$(rofi -dmenu -p "$prompt" -theme-str "$THEME_STR" "$@" <"$file")
done

exit 0

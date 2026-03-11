#!/usr/bin/env bash

choice=$(printf "Apps\nProjects\nSnippets\nTodo\n" | rofi -dmenu -p "Mode")

case "$choice" in
Apps) rofi -show drun ;;
Projects) ~/.config/rofi/scripts/rofi-projects.sh ;;
Snippets) ~/.config/rofi/scripts/rofi-snippets.sh ;;
Todo) ~/.config/rofi/scripts/rofi-todo.sh ;;
esac

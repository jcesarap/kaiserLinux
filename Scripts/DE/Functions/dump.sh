#!/bin/bash
content=$(cat "~/Documents/.dump.txt" | tr -d '\n' | sed 's/[[:space:]]*$//')
echo -n "$content" | xclip -selection clipboard
sleep 0.2
xdotool key ctrl+shift+v

#!/bin/bash
# Query files and directories using 'find' and 'rofi'
selected=$(find "~/Dropbox/Notes/Runaglyfi/References" -path '*/\.*' -prune -o -type f -o -type d | rofi -dmenu -i)
# Extract the path from the selected item
selected_path=$(realpath "$selected")

selected=\$(cat \"$selected\" | rofi -dmenu -i)

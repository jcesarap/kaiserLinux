#!/bin/bash

function path() {
    # Query files and directories using 'find' and 'rofi'
    selected=$(find "$HOME" -path '*/\.*' -prune -o -type f -o -type d | rofi -dmenu -i)

    # Extract the path from the selected item
    selected_path=$(realpath "$selected")
}

function markdown_browser() {
    date="date +%s"
    tempfile="/tmp/pandoc.tmp.$date.html"
    pandoc "$@" -t html -o "$tempfile" "$selected_path"
    firefox "$tempfile" 2>/dev/null
    sleep 5
    rm -f "$tempfile"
}

function open_alacritty_here() {
    # Trim last \\ from the path (as it's the line of the code, meant for loading images)
    parent_dir="${selected_path%/*}"
    alacritty --working-directory "$parent_dir"
}

function options(){
    # Options
    declare -A main_options=(
        ["1		Alacritty"]="open_alacritty_here"
        ["2		Neovim"]="alacritty -e nvim \"$selected_path\""
        ["3		Abrir Imagem"]="feh --keep-zoom-vp \"$selected_path\""
        ["4		Ranger"]="dirname=\$(dirname \"$selected_path\") && alacritty -e ranger \"\$dirname\""
        ["5		Explorador de Arquivos"]="dolphin \"$selected_path\""
        ["6		Executar"]="\"$selected_path\""
        ["7		Typora"]="flatpak run io.typora.Typora \"$selected_path\""
        ["8		PDF Reader"]="evince \"$selected_path\""
        ["9		Xournal"]="flatpak run com.github.xournalpp.xournalpp \"$selected_path\""
        ["10		Summarise"]="selected=\$(grep '^#' \"$selected\" | rofi -dmenu -i)"
        ["11		Micro"]="alacritty -e micro \"$selected_path\""
        ["12		Krita"]="flatpak run org.kde.krita \"$selected_path\""
        ["13		Inkscape"]="flatpak run org.inkscape.Inkscape \"$selected_path\""
        ["14		Abrir Video"]="vlc \"$selected_path\""
        ["15		VSCode"]="code --profile main \"$selected_path\""
        ["16		Música"]="cmus \"$selected_path\""
        ["17		Firefox"]="firefox \"$selected_path\""
        ["18		Markdown no Navegador"]="markdown_browser"
        ["19		Obsidian"]="flatpak run md.obsidian.Obsidian \"$selected_path\""
        ["20		Extrair"]="tar -xvzf \"$selected_path\""
        ["21		Descompactar"]="unzip \"$selected_path\""
        ["22		Abrir Video 2"]="mpv \"$selected_path\""
    )
    # Execute Options
    selected_option=$(printf "%s\n" "${!main_options[@]}" | LC_ALL=C sort -n | rofi -dmenu -i)
    if [[ -n $selected_option ]]; then
        command="${main_options[$selected_option]}"
        eval "$command"
    fi
}

if [[ "$1" == "openwithrofi"  ]]; then
    options
else
    path
    options
fi

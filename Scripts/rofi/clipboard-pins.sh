#!/bin/bash

# Declare, then Populate associative array
declare -A main_options=(
    # --- Mth
	["Mth, Interseção"]="∩"
	["Mth, União"]="∪"
	["Mth, Para todo"]="∀"
	["Mth, Subconjunto"]="⊆"
	["Mth, Subconjunto Próprio"]="⊂"
	["Mth, Existe"]="∃"
	["Mth, Pertence a"]="∈"
	["Mth, Não Pertence a"]="∉"
	["Mth, E"]="∧"
    ["Mth, Ou (Disjunção)"]="∨"
    ["Mth, Equivalência"]="<=>"
	["Mth, Ou Exclusivo"]="⊕"
	["Mth, Bicondicional"]="↔"
	["Mth, Scheffer Acima"]="↑"
	["Mth, Scheffer Abaixo"]="↓"
	["Mth, Condicional"]="→"
	["Mth, Delta"]="Δ"
	["Mth, Conclusão"]="⊢"
	["Mth, Pi"]="π"
    # --- Digital Circuits
	["Mth, Complemento A"]="Ā"
	["Mth, Complemento B"]="B̄"
	["Mth, Complemento C"]="C̄"
    # --- Phusis
    #
	["Physis, Ohm"]="Ω"
    # --- Data
	["WhatsApp"]="https://web.whatsapp.com/"
	["Traduzir"]="https://translate.google.com/"
	["Configurações"]="about:preferences"
	["Correio"]="https://mail.proton.me/u/1/inbox"
	["ChatGPT"]="https://chatgpt.com/"
    ["Endereço"]="Rua Sidney Brito Sobreira, n. 30, bairro Bugi"
    ["Número de Telefone"]="88999578273"
    # --- Quick Type
    ["Zheng Ming"]="正名"
    ["Yin-Yang"]="阴阳"
    ["Jian Wu Wei"]="儉无为"
    # --- Bookmarks
    ["(URL) Referência zsh"]="https://cheatography.com/davidsouther/cheat-sheets/bash-zsh-shourtcuts/"
    ["(URL) Modo Leitura"]="about:reader?url="
    ["(URL) Syncthing"]="http://127.0.0.1:8384/"
    ["(URL) PDF para MSCZ # Musescore"]="musescore.com/user/login?destination=%2Fimport"
    ["(URL) Baixador de Tablaturas"]="https://www.songsterr-downloader.com/"
    ["(URL) Conversor de Tablaturas"]="https://gpxtopdf.com/"
    # Requires Log-in
    ["(URL) Trello"]="trello.com"
    ["(URL) Discord"]="discord.com"
    # Bookmarks no login required
	["(URL) Folha de Cola do Vim"]="https://vim.rtorr.com/"
	["(URL) Resumir"]="https://notegpt.io/youtube-video-summarizer"
    ["(URL) Papéis de Parede"]="github.com/goatfiles/mut-ex-wallpapers"
    ["(URL) Phind"]="phind.com"
    ["(URL) Dicionário"]="collinsdictionary.com"
    ["(URL) Email Temporário"]="temp-mail.org/en"
    ["(URL) Editor de Fotos"]="photopea.com"
    ["(URL) Editor de Vídeos"]="123apps.com/pt"
    ["(URL) Limpador de URL"]="linkcleaner.app"
    # Design
    ["(URL) Design — Recursos"]="drawkit.com/"
    ["(URL) Design — Ilustrações 1"]="undraw.co/search"
    ["(URL) Design — Ilustrações 2"]="manypixels.co/gallery"
    ["(URL) Design — Fotos 1"]="unsplash.com/"
    ["(URL) Design — Fotos 2"]="openverse.org/"
    ["(URL) Design — Fontes"]="dafont.com/pt/"
    ["(URL) Design — Ícones"]="ionic.io/ionicons"
    # Litill
    ["(URL) APK da Play Store"]="apps.evozi.com/apk-downloader"
    # Shopping
    ["(URL) Compras Google"]="shopping.google.com/?nord=1"
    ["(URL) Buscapé"]="buscape.com.br/"
)

# --- Rofi
menu_options=()
for key in "${!main_options[@]}"; do
    menu_options+=("$key")
done
selected_option=$(printf "%s\n" "${menu_options[@]}" | sort | rofi -dmenu -i)
if [[ -n $selected_option ]]; then
    value_to_copy="${main_options[$selected_option]}"
    echo -n "$value_to_copy" | xclip -selection clipboard
    xdotool key ctrl+shift+v
fi
# WORKING ON HYPRLAND, NO IDEA HOW xD

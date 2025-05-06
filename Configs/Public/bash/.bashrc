# .bashrc

# --- --- Bash
# --- --- bash_profile contains the rest of configurations - if you ever decide to change shells
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

PS1=' \n  \w \$  ' # Theme

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias r='ranger .'
alias m='bash ~/Dropbox/Kaiser-Linux/Scripts/menu.sh bash'

# --- ---- Modifications

# Pywal 
# Import colorscheme from 'wal' asynchronously
# &  Run the process in the background; ( ) Hide shell job control messages.
(cat ~/.cache/wal/sequences &)
cat ~/.cache/wal/sequences # Alternative (blocks terminal for 0-3ms)
source ~/.cache/wal/colors-tty.sh # To add support for TTYs this line can be optionally added.

# --- --- Message
cat << EOF

  þérs'av Strømrav
  Breath
  Versai
EOF
###
# Pré-Cálculo
# Introdução à eletricidade e eletrônica
# Lógica matemática
# Lógica de Programação
# Introdução à Ciência da Computação


# --- --- Bash on Nvim


# --- --- Service Checking
if pgrep -x "dropbox" > /dev/null && pgrep -x "syncthing" > /dev/null; then
    echo " "
else
    echo -e "\033[0;31m — Daemons - Fail / Press m for menu \033[0m"  # Red
fi

# Make all commands accessible from nvim - maybe even assign a shortcut to it - as a floating window

# --- Post Output
~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh calculate_cycles # Independent Shell Mods
~/Dropbox/Kaiser-Linux/Scripts/DE/eye.sh # Monitor

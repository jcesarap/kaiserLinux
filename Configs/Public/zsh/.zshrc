# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
setopt INTERACTIVE_COMMENTS
setopt autocd extendedglob notify
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "~/.zshrc"
autoload -Uz compinit
compinit
# History options
HISTSIZE=2000
SAVEHIST=2000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
export HISTFILE=~/.histfile



# One of the best functions of zsh is TAB to show suggestions of commands




# Redirect output to be accessible via nvim - At Alt+Shift+´
# Log every command to a file
#function log_command() {
#  echo "————————————————————————\n# ———— Command:\n$1\n\n# ———— Output\n" >> ~/.bash_to_nvim.txt
#  eval $1 >> ~/.bash_to_nvim.txt 2>&1
#}
#
## Hook to log commands before they are executed
#preexec() {
#  log_command "$1"
#}


# End of lines added by compinstall

# --- --- --- Bash imports

# Text editor for shell
export user=$(whoami)
sed -i "s/^set \$user .*/set \$user $(whoami)/" ~/.config/i3/config
export GTK_THEME=Layan-Dark-Solid
export VISUAL=micro
export EDITOR=micro
export PATH=$PATH:/usr/local/go/bin
# export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude ~/.Snapshots" # So you don"t edit files which are soon overwritten
export FZF_DEFAULT_COMMAND="fd --type d --hidden --exclude .git ~/Dropbox"
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export EXT_MONITOR="HDMI-1-0"
export INT_MONITOR="eDP1"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PF_INFO="ascii title os host kernel uptime memory palette"

# User specific environment and startup programs
if [ -d "/var/lib/flatpak/exports/bin" ]; then
    PATH="/var/lib/flatpak/exports/bin:$PATH"
fi

# Nix profile setup
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi # added by Nix installer

# Source global definitions (for zsh, this file is typically /etc/zshrc or similar)
if [ -f /etc/zshrc ]; then
    source /etc/zshrc
fi

# User-specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH


# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias r='ranger .'
alias m='bash ~/Dropbox/Kaiser-Linux/Scripts/menu.sh bash'
alias d='bash ~/Dropbox/Kaiser-Linux/Scripts/DE/reminders.sh write'
alias i='bash ~/Dropbox/Kaiser-Linux/Scripts/DE/Commands/quick_convertion.sh nvim_img'
alias n='nvim'
alias t='vtop'
alias ir='cd $(find ~ -type d | fzf)'
alias co='~/Dropbox/Kaiser-Linux/Scripts/DE/quick_compile.sh options' # For Options
alias cc='~/Dropbox/Kaiser-Linux/Scripts/DE/quick_compile.sh compile' # For Compile Code
alias cr='~/Dropbox/Kaiser-Linux/Scripts/DE/quick_compile.sh run' # For Compile (kinda the name of the script) Run
alias car='~/Dropbox/Kaiser-Linux/Scripts/DE/quick_compile.sh compile_and_run' # For Compile And Run
alias ds='ollama run deepseek-r1:7b' 
alias gm='ollama run gemma:7b'
alias h='history -f' # See command history with timestamps
alias hf='fc -l 0' 

# --- Modifications

function cd() {
    builtin cd "$@" && ls --color=auto
}

# Pywal: Import colorscheme from "wal" asynchronously
# & Run the process in the background; ( ) Hide shell job control messages.
(cat ~/.cache/wal/sequences &)
cat ~/.cache/wal/sequences # Alternative (blocks terminal for 0-3ms)
source ~/.cache/wal/colors-tty.sh # Optional: Adds support for TTYs

# --- Message

echo " "
pfetch
cat << EOF
=== Atalhos ===
- Ctrl Q            Fecha janela
- Alt B             Abre o Navegador
- Alt Q, W, A, S    Áreas de Trabalho
- F2 e F3           Controla o volume
- F5 e F6           Controla o brilho
- Alt -             Fecha notificações
- Alt P             Pausa mídia
- Alt <>            Próxima música ou anterior
- Alt Setas         Muda a janela em foco
- Ctrl Alt Setas    Redimensiona janelas              
- Shift Alt Setas   Troca posição de janelas

=== Outras dicas (para a big-big 😺) ===
- Digite (ir) no terminal para rapidamente mover-se entre pastas
- Baixe KeepassXC (gerenciador de senhas), KDE-Connect e Syncthing no celular - e configurar eles com o PC.
- Obsidian para anotações no Dropbox - já está baixado

EOF

# --- Service Checking
if pgrep -x "dropbox" > /dev/null && pgrep -x "syncthing" > /dev/null; then
    echo " "
else
    echo -e "\033[0;31m — ERRO - Dropbox ou Syncthing não estão rodando \033[0m"  # Red message if services are not running
fi

# Move cursor by word
#PROMPT="%{[%D{%f/%m/%y} %D{%L:%M}] "$PROMPT
#PROMPT="   %{[%D{%L:%M}] %1d  "
bindkey "^[[1;5D" backward-word  # Ctrl+Left Arrow
bindkey "^[[1;5C" forward-word   # Ctrl+Right Arrow

# Home and End keys
bindkey "^[[H" beginning-of-line  # Home key
bindkey "^[[F" end-of-line        # End key
# --- Post Output
nohup ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh calculate_cycles > /dev/null 2>&1 &! 
nohup ~/Dropbox/Kaiser-Linux/Scripts/DE/eye.sh > /dev/null 2>&1 &! 
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -e /home/bianca/.nix-profile/etc/profile.d/nix.sh ]; then . /home/bianca/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

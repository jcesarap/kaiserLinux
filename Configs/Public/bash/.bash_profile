# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Text editor for shell
export VISUAL=nvim
export EDITOR=nvim
export PATH=$PATH:/usr/local/go/bin

# User specific environment and startup programs
if [ -d "/var/lib/flatpak/exports/bin" ] ; then
    PATH="/var/lib/flatpak/exports/bin:$PATH"
fi

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -e /home/bianca/.nix-profile/etc/profile.d/nix.sh ]; then . /home/bianca/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

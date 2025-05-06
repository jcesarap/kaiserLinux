hdajackretask
hdajackretask
pulseaudio -k && sudo alsa force-reload
sudo alsa force-reload
sudo pacman -S alsa
alsamixer -c 0
aplay -l
sudo pacman -S wireplumber pavucontrol pipewire-pulse pipewire-alsa pipewire
i3-msg reload
micro
nvim
micro
i3-msg reload
nvim
r
micro
r
nvim
cmus
sudo pacman -S cmus
cmus
nmcli dev wifi list
nmcli device wifi connect ifce-alunos password ifce1234
i3-msg reload
pkill kitty
cmus
man git
man git >> git-manual.txt
man git > git-manual.txt
git -h
micro
git -p
git -P
nvim
i3-msg reload
nvim
alacritty migrate
alacritty migrate
pkill picom
picom -b
xev
xprop
pkill picom
picom -b
ranger
alacritty && ranger
clear
ls
sudo chmod +x *
script
micro
clear
nmcli dev wifi list
nmcli dev wifi list
nmcli dev wifi list
nmcli dev wifi list
micro
nmcli device wifi connect brisa-4035988-turbo password mxgeane6
nmcli dev wifi list
flatpak update
micro
cmus
micro
micro 
micro
micro
cmus
cd mtp://SAMSUNG_SAMSUNG_Android_RX8RA0EGG7F/Internal%20storage/
cat
showkey -a
micro
sudo pacman -R xserver-xorg-input-libinput xserver-xorg-input-synaptics
sudo pacman -R libinput synaptics
pacman -Qe | grep syna
sudo pacman -R libinput
sudo pacman -R xf86-input-libinput
sudo pacman -S synaptics
sudo ranger .
c
sudo pacman -S pass
c
pass
pass -h
pass show
pass init
sudo pacman -R nautilus
sudo pacman -R nautilus-dropbox nautilus
sudo pacman -S thunar
sudo pacman -S nautilus
sudo pacman -R nautilus thunar
sudo pacman -S dolphin
c
sudo pacman -S nautilus
sudo pacman -S arc-gtk-theme
sudo pacman -S arc-icon-theme
fastfetch
nix-env -iA nixpkgs.nautilus
sudo pacman -R nautilus
nix-env -iA nixpkgs.nautilus
nix-env -iA nixpkgs.gnome.nautilus
clear
yay -S nautilus
ls
sudo nvim 70-synaptics.conf 
ls
nvim 70-synaptics.conf 
sudo nvim 70-synaptics.conf 
sudo pacman -S ueberzug
sudo pacman -S imagemagick magick_cli
sudo pacman -R luarocks
luarocks
luarocks list
pacman -Qe | grep lua
cmus
micro
flatpak install lutris
yay -S teamviewer
teamviewer --daemon start
sudo teamviewer --daemon start
systemctl start teamviewerd.service
systemctl start teamviewerd.service
yay -R teamviewer
flatpak install flathub com.anydesk.Anydesk
micro
micro
micro
flatpak remove AnyDesk
flatpak install steam
cmus
cmus
pkill cmus
cmus
sudo pacman -S nodejs
clear
ls
node port.js 
clear
ls
a.out
.a.out
./a.out 
teset
ls
clear
ls
cd git
cd git_dir_test/
ls
clear
touch port.js
./por
node
clear
node port.js 
nvim port.js 
touch hello.c
nvim hello.c 
cc hello.c 
nvim hello.c 
cc hello.c 
nvim hello.c 
r
clear
ls
cmus
htop
ranger
r
ls
micro cycles.sh 
poweroff
ranger
r
~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh 12h & sleep 15 && pkill -f ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh
~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh 12h & sleep 30 && pkill -f ~/Dropbox/Kaiser-Linux/Scripts/DE/cycles.sh
r
m
reboot
sudo pacman -Syu
sudo pacman -Syu && sudo pacman -S lib32-mesa mesa
sudo pacman -Syu --no-confirm && sudo pacman -S lib32-mesa mesa --no-confirm
sudo pacman -Syu --noconfirm && sudo pacman -S lib32-mesa mesa --noconfirm
sudo pacman -Syu --noconfirm && sudo pacman -S lib32-mesa mesa --noconfirm
pkill lutris
reboot
reboot
nvim
alacritty -e sudo envycontrol -s hybrid --force-comp
sudo pacman -S xf86-video-nouveau
sudo pacman - S nvidia-open-dkms dkms xorg-server xorg-xinit xf86-video-intel mesa lib32-mesa xf86-video-nouveau
sudo pacman -S nvidia-open-dkms dkms xorg-server xorg-xinit xf86-video-intel mesa lib32-mesa xf86-video-nouveau
flatpak search steam
flatpak install com.valvesoftware.Steam
flatpak remove com.valvesoftware.Steam
sudo pacman -S steam
flatpak uninstall --unused
sudo pacman -R steam
flatpak install steam
flatpak search steam
flatpak install com.valvesoftware.Steam
nvim backup.md
steam --reset
sudo mv /etc/resolv.conf /etc/resolv.conf.bak
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
ls -l /etc/resolv.conf
sudo systemctl restart systemd-resolved
ping -c 3 google.com
resolvectl status
flatpak kill steam
micro
micro
micro
adb shell cmd package install-existing com.android.vending
micro
sudo pacman -S syncplay
sudo pacman -R syncplay
micro
micro
micro
xev
i3-msg reload
sudo pacman -S extracthere
sudo pacman -S xarchive
sudo pacman -S xarchiver
clear
nvim
pkill ranger
sudo pacman -S atool
sudo pacman -S aunpack
sudo pacman -S atool
sudo pacman -S unzip
nvim
flatpak list
flatpak list | grep steam
flatpak list | grep Steam
flatpak kill com.valvesoftware.Steam
flatpak kill com.valvesoftware.Steam
	# General
	read -p "Open (to generate configs): Typora, Freetube, Inkscape,"
	read -p "Have you opened and closed those apps? [Press Enter if you have]"
	# Redundancy
	rm -r "~/.var/app/io.typora.Typora/config/Typora" || :
	rm -r "~/.var/app/io.freetubeapp.FreeTube/config/FreeTube" || :
	rm -r "~/.var/app/org.inkscape.Inkscape/config/inkscape" || :
	rm -r "~/.var/app/com.github.xournalpp.xournalpp/config/xournalpp" || :
	rm -r "~/.var/app/md.obsidian.Obsidian/config/obsidian" || :
	rm -r "~/.var/app/org.musescore.MuseScore/config/MuseScore" || :
	# Linking
	ln -s "$BASE_DIR/——— Flatpak/Typora/" "$FLATPAK_DIR/io.typora.Typora/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/FreeTube/" "$FLATPAK_DIR/io.freetubeapp.FreeTube/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Inkscape/" "$FLATPAK_DIR/org.inkscape.Inkscape/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Xournal/" "$FLATPAK_DIR/com.github.xournalpp.xournalpp/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Obsidian/" "$FLATPAK_DIR/md.obsidian.Obsidian/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Musescore/" "$FLATPAK_DIR/org.musescore.MuseScore/config/" || :
BASE_DIR="~/Dropbox/Kaiser-Linux/Configs/Public"
CONFIG_DIR="~/.config"
SUDO_CONFIG_DIR="/etc"
FLATPAK_DIR="~/.var/app"
	# General
	read -p "Open (to generate configs): Typora, Freetube, Inkscape,"
	read -p "Have you opened and closed those apps? [Press Enter if you have]"
	# Redundancy
	rm -r "~/.var/app/io.typora.Typora/config/Typora" || :
	rm -r "~/.var/app/io.freetubeapp.FreeTube/config/FreeTube" || :
	rm -r "~/.var/app/org.inkscape.Inkscape/config/inkscape" || :
	rm -r "~/.var/app/com.github.xournalpp.xournalpp/config/xournalpp" || :
	rm -r "~/.var/app/md.obsidian.Obsidian/config/obsidian" || :
	rm -r "~/.var/app/org.musescore.MuseScore/config/MuseScore" || :
	# Linking
	ln -s "$BASE_DIR/——— Flatpak/Typora/" "$FLATPAK_DIR/io.typora.Typora/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/FreeTube/" "$FLATPAK_DIR/io.freetubeapp.FreeTube/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Inkscape/" "$FLATPAK_DIR/org.inkscape.Inkscape/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Xournal/" "$FLATPAK_DIR/com.github.xournalpp.xournalpp/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Obsidian/" "$FLATPAK_DIR/md.obsidian.Obsidian/config/" || :
	ln -s "$BASE_DIR/——— Flatpak/Musescore/" "$FLATPAK_DIR/org.musescore.MuseScore/config/" || :
	rm -r "~/.var/app/com.github.xournalpp.xournalpp/config/xournalpp" || :
	ln -s "$BASE_DIR/——— Flatpak/xournalpp/" "$FLATPAK_DIR/com.github.xournalpp.xournalpp/config/" || :
BASE_DIR="~/Dropbox/Kaiser-Linux/Configs/Public"
CONFIG_DIR="~/.config"
SUDO_CONFIG_DIR="/etc"
FLATPAK_DIR="~/.var/app"
	ln -s "$BASE_DIR/——— Flatpak/xournalpp/" "$FLATPAK_DIR/com.github.xournalpp.xournalpp/config/" || :
i3-msg reload
xprop
gnome-calculator
Calculator
flatpak list
flatpak list | grep Cal
i3-msg reload
i3-msg reload
xev
i3-msg reload
micro
flatpak list
flatpak list | grep tau
flatpak list | grep rh
flatpak list | grep Ta
flatpak list | grep Rh
pacman -Qe | grep rh
pacman -Qe | grep Tau
sudo pacman -R rhythmbox
flatpak list
flatpak list | moo
flatpak list | grep moo
flatpak list | grep moo
sudo pacman -S xf-input-libinput
sudo pacman -S xf86-input-libinput
sudo pacman -R xf86-input-libinput
xinput list-props
xinput list
xinput list 10
xinput list-props 10
sudo pacman -R xf86-input-synaptics
cd /etc/X11/xorg.conf.
cd /etc/X11/xorg.conf.d
ls
sudo ranger
clear
ls
nvim 70-synaptics.conf 
touch 30-touchpad.conf
sudo touch 30-touchpad.conf
sudo nvim 30-touchpad.conf
clear
cd /etc/X11/xorg.conf.d
ls
sudo nvim 30-touchpad.conf
xinput list 10
xinput list
xinput list-props 12
xinput list-props 12
xinput list-props 12 | grep Sy
xinput list-props 12 | grep sy
xinput list-props 12 | grep lib
ls
sudo rm 30-touchpad.conf 
xinput list
xinput list-props 12
sudo pacman -R xf86-input-synaptics
sudo pacman -S xf86-input-synaptics
sudo ranger
xinput lisst
xinput list
xinput list-props 12
nvim
    sudo printf 'Section "InputClass"\n    Identifier "Synaptics touchpad"\n    MatchIsTouchpad "on"\n    Driver "synaptics"\n    Option "FingerLow" "1"\n    Option "FingerHigh" "5"\n    Option "MaxTapTime" "180"\n    Option "PalmDetect" "0"\n    Option "SHMConfig" "on"\nEndSection\n' > /etc/X11/xorg.conf.d/70-synaptics.conf
    sudo sed -i 's/\(options .* quiet\)/\1 psmouse.synaptics_intertouch=0/' /boot/loader/entries/*.conf
    sudo printf 'USB_AUTOSUSPEND=0\n' >> /etc/tlp.conf
    sudo printf 'ACTION=="add|change", SUBSYSTEM=="input", ATTR{name}=="*Synaptics*", ATTR{power/control}="on"\n' > /etc/udev/rules.d/90-touchpad-nopowersave.rules
sudo printf 'Section "InputClass"\n    Identifier "Synaptics touchpad"\n    MatchIsTouchpad "on"\n    Driver "synaptics"\n    Option "FingerLow" "1"\n    Option "FingerHigh" "5"\n    Option "MaxTapTime" "180"\n    Option "PalmDetect" "0"\n    Option "SHMConfig" "on"\nEndSection\n' > /etc/X11/xorg.conf.d/70-synaptics.conf
    sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 psmouse.synaptics_intertouch=0"/' /etc/default/grub && sudo update-grub
    sudo printf 'USB_AUTOSUSPEND=0\n' >> /etc/tlp.conf
    sudo printf 'ACTION=="add|change", SUBSYSTEM=="input", ATTR{name}=="*Synaptics*", ATTR{power/control}="on"\n' > /etc/udev/rules.d/90-touchpad-nopowersave.rules
nvim
downgrade xf86-input-synaptics
sudo downgrade xf86-input-synaptics
reboot
micro
xinput list-props 12
nvim
xinput list-props 12
m
tmux
sudo pacman -S syncplay
sudo pacman -S termux
sudo pacman -S tmux
sudo pacman -R tmux
ls -la | nvim -
ls -la | nvim -
ls -la | nvim -
ls -la | nvim -
    cp "b_to_nvim.txt" "-backup.txt"
    b_to_nvim="~/.Snapshots/Manual/Glyphi/Magn/Assets/bash_to_nvim"
    cp "${b_to_nvim}.txt" "${b_to_nvim}-backup.txt"
    cp "${b_to_nvim}.txt" "${b_to_nvim}-backup.txt"
    truncate -s 0 "${b_to_nvim}.txt"
b_to_nvim="~/.Snapshots/Manual/Glyphi/Magn/Assets/bash_to_nvim"
    cp "${b_to_nvim}.txt" "${b_to_nvim}-backup.txt"
    truncate -s 0 "${b_to_nvim}.txt"
    b_to_nvim="~/.bash_to_nvim"
    cp "${b_to_nvim}.txt" "${b_to_nvim}-backup.txt"
    truncate -s 0 "${b_to_nvim}.txt"
ls -la | nvim -
ls -la | nvim -
ls
ls
ls
ls
ls
ls
ls
ls
ls
cd Mus
cd Music/
i3-msg reload
i3-msg restart
xprop
xprop | grep instance
xprop | grep instance
xprop
i3-msg reload
i3-msg reload
i3-msg reload
i3-msg reload
i3-msg reload
i3-msg reload
i3-msg reload
i3-msg restart
ls
ls
ls
nvim
time
ls
ls
yay -S i3lock-color
ls
ls
ls
ls
ls
sudo pacman -S zsh
chsh -s $(which zsh)
which zsh
sudo nvim /etc/shells
chsh -s $(which zsh)
sudo nvim /etc/shells
grep $(whoami) /etc/passwd
cat /etc/passwd
sudo sed -i 's|/usr/bin/bash$|/usr/bin/zsh|' /etc/passwd
grep $(whoami) /etc/passwd
echo $SHELL
r
ls
sudo ./setup.sh 
nvim setup.sh 
sudo ./setup.sh 
mkdir "~/.minecraft/saves"
mkdir -p "~/.minecraft/saves"
nvim setup.sh 
sudo ./setup.sh 
nvim setup.sh 
sudo ./setup.sh 
sudo systemctl unmask power-profiles-daemon.service
sudo ./setup.sh 
nvim setup.sh 
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
r
cd Dropbox/Kaiser-Linux/Scripts/
sudo ./setup.sh 
sudo pacman -S code
cp setup.sh 
cp setup.sh setup_bak.sh
ls
sudo pacman -S xorg-xclipboard
xorg-xclipboard
ls
sudo ./setup.sh 
sudo ./setup.sh 
dropbox
reboot
ls
cd Dropbox/
ls
cd Glyphi/
ls
cd Magn/
ls
cd Scripts/
ls
ls
clear
ls
ls
ls
ls
ls
ls
ls
lsls
clear
ls
ls
sudo ./setup
sudo ./setup.sh
sudo pacman -S lxqt-polkit
sudo pacman -S lxqt-policykit
vim setup.sh
clear
sudo ./setup.sh
sudo ./setup.sh
sudo ./setup.sh
sudo chown -R magn ~
sudo ./setup.sh
dropbox
touch learn-kotlin
reboot
nix-env -iA nixpkgs.dust
ls
cd Dropbox/
ls
cd Glyphi/
ls
cd Magn/
ls
cd Scripts/
ls
sudo ./setup.sh
sudo sed -i 's|/usr/bin/bash$|/usr/bin/zsh|' /etc/passwd
ranger
ranger
ls
r
sudo dnf install i3
sudo dnf install -y i3 i3status dmenu i3lock xbacklight feh conky
sudo dnf install -y xss-lock picom network-manager-applet light maim xclip dunst polkit-gnome polybar rofi
sudo dnf install -y xss-lock picom network-manager-applet light maim xclip dunst polybar rofi
ls
cd Dropbox
ls
cd Kaiser-Linux/
ls
cd Scripts/
ls
sudo ./setup.sh
chsh -s $(which zsh)
ls
sudo vi /etc/passwd
nvim .zshrc
clear

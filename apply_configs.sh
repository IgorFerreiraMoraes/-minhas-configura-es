fedora_version=$(cat /etc/fedora-release | grep -o '[0-9]*')

# Remove Unwanted Programs
sudo dnf remove libreoffice* connections gnome-contacts gnome-maps -y
sudo dnf autoremove -y
sudo dnf clean all

# Upgrade Packages
sudo dnf upgrade -y

# Add Third Party Repositories
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

##############################
# Basic Programs
##############################

# Firefox
flatpak install --noninteractive flathub org.mozilla.firefox

# Obsidian
flatpak install --noninteractive flathub md.obsidian.Obsidian

# Flatseal
flatpak install --noninteractive flathub com.github.tchx84.Flatseal

# OpenTabletDriver
wget https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest/download/OpenTabletDriver.rpm
sudo dnf install ./OpenTabletDriver.rpm -y
systemctl --user enable opentabletdriver.service --now

# Wine
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/$fedora_version/winehq.repo
sudo dnf install winehq-stable -y

##############################
# Programming
##############################

# Git && GitHub
sudo dnf install git
flatpak install --noninteractive flathub io.github.shiftey.Desktop

# Neovim
sudo dnf install gcc
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
cp -r nvim ~/.config/

# NPM
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

##############################
# Design
##############################

# Photoshop
chmod u+x ./photoshop2021install.sh
./photoshop2022install.sh ~/.wine
curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > CameraRaw_12_2_1.exe WINEPREFIX=~/.wine wine CameraRaw_12_2_1.exe

# Figma Agent
bash -c "$(curl -fsSL https://raw.githubusercontent.com/neetly/figma-agent-linux/main/scripts/install.sh)"

##############################
# GNOME Tweaks && Extensions
##############################

# Install Tweaks and Manager
sudo dnf install gnome-tweaks -y
flatpak install --noninteractive flathub com.mattjakeman.ExtensionManager
mkdir extensions
cd extensions

# User Themes
wget https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v57.shell-extension.zip
gnome-extensions install user-themegnome-shell-extensions.gcampax.github.com.v57.shell-extension.zip

# Blur my Shell
wget https://extensions.gnome.org/extension-data/blur-my-shellaunetx.v61.shell-extension.zip
gnome-extensions install blur-my-shellaunetx.v61.shell-extension.zip

# Hide Top Bar
wget https://extensions.gnome.org/extension-data/hidetopbarmathieu.bidon.ca.v117.shell-extension.zip
gnome-extensions install hidetopbarmathieu.bidon.ca.v117.shell-extension.zip

cd ..

##############################
# Customization
##############################
mkdir customization
cd customization

# Orchis-theme
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh -t default -c light -s standard -l --tweaks solid nord
cp -r ~/.themes/Orchis-Light-Nord/gtk-4.0 ~/.config/gtk-4.0
dconf write /org/gnome/shell/extensions/user-theme/name "'Orchis-Light-Nord'"
gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Light-Nord"
sudo flatpak override --env=GTK_THEME=Orchis-Light-Nord
sudo flatpak override --env=GTK_THEME=Orchis-Light-Nord
sudo flatpak override --filesystem=$HOME/.themes

cd ..

# Tela-circle icon theme
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme
./install.sh nord
gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-nord-light"
cd ..

# Graphite-dark-cursor
git clone https://github.com/vinceliuice/Graphite-cursors.git
cd Graphite-cursors
./install.sh
mkdir -p ~/.icons/
sudo cp -r ~/.local/share/icons/Graphite-* /usr/share/icons
sudo mv ~/.local/share/icons/Graphite-* ~/.icons/
gsettings set org.gnome.desktop.interface cursor-theme "Graphite-dark-nord-cursors"
cd ..
cd ..

curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

# Resources
mkdir -p ~/.fonts
cp -r resources/fonts/* ~/.fonts
gsettings set org.gnome.desktop.interface font-name "Barlow Regular 10"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Barlow Regular 10"
gsettings set org.gnome.desktop.interface document-font-name "Barlow Regular 10"
gsettings set org.gnome.desktop.interface monospace-font-name "Sono Regular 10"
gsettings set org.gnome.desktop.background picture-uri resources/bg.jpg
gsettings set org.gnome.desktop.background picture-uri-dark resources/bg.jpg
dconf load /org/gnome/terminal/legacy/profiles:/ < resources/themes/nord-light-profile.dconf

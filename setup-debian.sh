#!/bin/bash

git clone https://github.com/nlahmi/nvim-config ~/.config/nvim

# Install Fonts
mkdir ~/.local/share/fonts
# Consider changing to a simple recursive copy
find ~/.config/nvim/fonts -type f -name "*.ttf" -exec cp "{}" ~/.local/share/fonts/ \;
fc-cache -f -v

# Install wezterm
#curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
#echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install ripgrep fd-find git python3 python3-venv python3-pip npm xclip -y 
 # sudo apt install wezterm -y

# Install from appimage since apt is always outdated
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod 755 nvim.appimage
sudo chown root:root nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# On WSL1 (or any other system that doesnt have FUSE/Modprobe, we need to extract the Appimage
if [ ! -f /dev/fuse ]; then
    sudo mv /usr/local/bin/nvim /usr/local/bin/nvim.appimage
    nvim.appimage --appimage-extract
    sudo mv squashfs-root /opt/
    sudo ln -s /opt/squashfs-root/AppRun /usr/bin/nvim
fi

# Install plugins with Lazy
nvim --headless "+Lazy! install" +qa

# Install dependencies with Mason
nvim "+Mason"

#LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
#curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
#tar xf lazygit.tar.gz lazygit
#sudo install lazygit /usr/local/bin

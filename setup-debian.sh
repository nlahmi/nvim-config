#!/bin/bash

# Install Fonts
find fonts -type f -name "*.ttf" -exec cp "{}" ~/.local/share/fonts \;  # Consider changing to a simple recursive copy
fc-cache -f -v

# Install wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install wezterm ripgrep fd-find git python3 python3-venv python3-pip npm -y

# Install from appimage since apt is always outdated
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod 755 nvim.appimage
sudo chown root:root nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

git clone https://github.com/nlahmi/nvim-config ~/.config/nvim



#LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
#curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
#tar xf lazygit.tar.gz lazygit
#sudo install lazygit /usr/local/bin

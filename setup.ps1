# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Nerd Font (LiterationMono)
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/LiberationMono.zip
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem -Recurse -include *.ttf | % { $fonts.CopyHere($_.fullname) }

# Set it as option in legacy CMD
New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -name 7778 -PropertyType String -Value "LiterationMono Nerd Font"

# Todo: Set it as default on legacy CMD
# Todo: Set it as default on Windows Terminal

# Install deps
choco install lazygit mingw ripgrep fd git neovim -y

# Install lazy-nvim
git clone https://github.com/nlahmi/nvim-config $env:LOCALAPPDATA\nvim

# Launch nvim
nvim
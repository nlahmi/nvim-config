# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Nerd Font (LiterationMono)
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/LiberationMono.zip
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem -Recurse -include *.ttf | % { $fonts.CopyHere($_.fullname) }

# Set it as option in legacy CMD
New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -name 7778 -PropertyType String -Value "LiterationMono Nerd Font"

# Set it as default on legacy CMD
Set-ItemProperty -LiteralPath "HKCU:\Console" -name "FaceName" -Value "LiterationMono Nerd Font Mono"

# Set it as default on Windows Terminal
$p = $env:localappdata + "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $p) {
    
    # Make a copy
    Copy-Item $p ($p + ".bak")
    
    # Read and parse the json
    $decoded = Get-Content $p -Raw | ConvertFrom-Json
    
    # Add the font setting to the default profile
    Add-Member -InputObject $decoded.profiles.defaults -NotePropertyName font -NotePropertyValue @{face="LiterationMono Nerd Font Mono"} -ErrorAction Ignore
    
    # Save the file
    $decoded | ConvertTo-Json -Depth 100 -Compress | Set-Content $p
}

# Install deps
choco install lazygit mingw ripgrep fd git neovim neovide -y

# Install lazy-nvim
git clone https://github.com/nlahmi/nvim-config $env:LOCALAPPDATA\nvim

# Launch nvim
nvim

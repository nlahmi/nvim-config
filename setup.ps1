#$chosen_font = "LiterationMono Nerd Font"
$chosen_font = "Hack Nerd Font Mono"
# $chosen_font = "Hack Nerd Font Mono JBM Ligatured CCG"

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Nerd Font(s)
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem -Exclude _* fonts | Get-ChildItem -Recurse | ? {$_.fullname -match "ttf" } | % { $fonts.CopyHere($_.fullname) }

# Set it as option in legacy CMD
New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -name 7778 -PropertyType String -Value $chosen_font
Set-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -name 7778 -PropertyType String -Value $chosen_font

# Set it as default on legacy CMD
Set-ItemProperty -LiteralPath "HKCU:\Console" -name "FaceName" -Value $chosen_font

# Set it as default on Windows Terminal
$p = $env:localappdata + "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $p) {
    
    # Make a copy
    Copy-Item $p ($p + ".bak")
    
    # Read and parse the json
    $decoded = Get-Content $p -Raw | ConvertFrom-Json
    
    # Add the font setting to the default profile
    Add-Member -InputObject $decoded.profiles.defaults -NotePropertyName font -NotePropertyValue @{face=$chosen_font} -ErrorAction Ignore
    
    # Save the file
    $decoded | ConvertTo-Json -Depth 100 -Compress | Set-Content $p
}

# TODO: Install gruvbox theme (for terminal and maybe others)

# Install deps
choco install wezterm lazygit mingw ripgrep fd git neovim python311 nodejs jq sudo -y

# Install lazy-nvim
git clone https://github.com/nlahmi/nvim-config $env:LOCALAPPDATA\nvim

# Launch nvim
nvim

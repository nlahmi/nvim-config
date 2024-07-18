## Windows Install (Powershell)
Make sure to run as admin
```
git clone https://github.com/nlahmi/nvim-config $env:LOCALAPPDATA\nvim
cd $env:LOCALAPPDATA\nvim
.\setup.ps1
```

## Linux Install (Debian)
```
sh -c "$(curl -fsLS https://raw.githubusercontent.com/nlahmi/nvim-config/main/setup-debian.sh)"

# git clone https://github.com/nlahmi/nvim-config ~/.config/nvim
# sh ~/.config/nvim/setup-debian.sh
```

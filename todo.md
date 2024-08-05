# General

- [ ] Configure default debug configs like that: https://www.reddit.com/r/neovim/comments/17yzofg/running_and_building_node_application_when/
- [ ] consider adding a divider between default configs and launch.json https://www.youtube.com/watch?v=Ul_WPhS2bis 8:35
- [ ] Conf default build configs (such as gradle)

# Fix

- [x] Import errors (venv not detected by LSP) in python - https://github.com/linux-cultist/venv-selector.nvim?tab=readme-ov-file#hooks
- [ ] Not super urgent: Give desc to automatic keymaps (fuzzy search <Plug>)
- [ ] Java DAP not working and some lsp keybinds dont work in Java

# Hotkeys

## Debugging

- [x] dl - should saveall, terminate, then do last (or even better, map it to something like F5)
- [x] Create the equivalent without debug (for python [-i] at least)
- [ ] Also consider having dC to start last config (if not in a session already) because it essentially makes you have a breakpoint prior
- [x] debug current file (no prompts)
- [x] debug default config (no prompts)
- [ ] run current file (no prompts)
- [ ] run default config (no prompts)
      all those above will save and kill first the running instance
- [x] ctrl space to `CTRL-X CTRL-O` (I think it's already implemented, but not in the debug console: https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt # auto complete) - also https://github.com/rcarriga/cmp-dap
- [ ] reconfigure ui

## Else

- [ ] :make keymap
- [ ] ctrl / to comment this line and move down (or comment lines in v mode)
- [ ] consider moving ga (charactarize), but surely give it a better description
- [x] find a way to focus on current debug line (https://github.com/ofirgall/goto-breakpoints.nvim)
- [ ] Jump to buffer by number
- [ ] More session keys
- [x] git keymaps
- [!] Save all (and exit?) - ~~implement a save-all util function~~ just do `:wa`. use it with git commits, debug, run etc.
- [ ] Make <tab> move down in the autocomplete list (currently it's with the arrows) - and of course shift+tab to go up
- [ ] Open terminal to the side (:vsplit | term c)

# Settings

Good source: https://github.com/omerxx/dotfiles/blob/master/nvim/lua/options.lua

- [x] Save undo history
      vim.o.undofile = true
- [x] Case insensitive searching UNLESS /C or capital in search
      vim.o.ignorecase = true
      vim.o.smartcase = true
- [ ] Split to the right instead of the left (vim.opt.splitright = true)
- [ ] Add git info to statusline (with fugitive %{FugitiveStatusline()})

# Languages

https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

## Must-Have

- [x] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/markdown.lua
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/docker.lua
- [x] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/json.lua
- [x] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/yaml.lua
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#powershell_es
- [x] kubernetes: https://joshrosso.com/c/vim-k8s-yaml-support/

## Optional:

- [ ] https://github.com/BlackLight/nvim-http
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript.lua
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/terraform.lua
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/rust.lua
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/ruby.lua
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/omnisharp.lua
- [x] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/java.lua - Mostly works (no DAP)
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua
- [x] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/clangd.lua
- [ ] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/cmake.lua
- [ ] SQL - https://github.com/tpope/vim-dadbod
- [x] C/C++ (is clangd enough?)
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ansiblels
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#arduino_language_server
      https://github.com/stevearc/vim-arduino
      https://stefka.eu/posts/2023/07/platformio+nvim/
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#asm_lsp
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dartls
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#docker_compose_language_service
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#graphql
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#hdl_checker
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#helm_ls
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonnet_ls
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#markdown_oxide -- Obsidian
- [x] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#marksman
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#nginx_language_server
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#openscad_lsp
- [ ] https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#phpactor
- [ ] Latex - https://github.com/lervag/vimtex?tab=readme-ov-file - https://github.com/circuitikz/circuitikz
- [x] OpenAPI/Swagger - https://github.com/daveshanley/vacuum
      https://github.com/luizcorreia/spectral-language-server
      https://github.com/vinnymeller/swagger-preview.nvim
      https://github.com/shuntaka9576/preview-swagger.nvim
      https://github.com/rusagaib/oas-preview.nvim
      https://github.com/b0o/SchemaStore.nvim

# Plugins

## Must-Have

- [x] Code folding (like in lazyvim) - actually, it's already in vim :D
- [x] https://github.com/chipsenkbeil/distant.nvim
- [x] https://github.com/voldikss/vim-browser-search
- [x] https://github.com/tpope/vim-surround - used surround.mini
- [x] https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bufremove.md
- [x] https://github.com/Dax89/automaton.nvim - Used Compiler.nvim instead
- [x] https://github.com/tpope/vim-sleuth - used guess-indent
- [ ] https://github.com/nvim-neo-tree/neo-tree.nvim
- [ ] https://github.com/AckslD/swenv.nvim - If existing venv plugin won't work eventually
- [x] https://github.com/ahmedkhalf/project.nvim
- [x] https://github.com/andrewferrier/debugprint.nvim
- [ ] https://github.com/ofirgall/goto-breakpoints.nvim
- [x] https://github.com/Weissle/persistent-breakpoints.nvim
- [x] https://github.com/LiadOz/nvim-dap-repl-highlights
- [x] https://github.com/hedyhli/outline.nvim
- [x] https://github.com/nvimdev/template.nvim
- [ ] https://github.com/akinsho/toggleterm.nvim
- [ ] https://github.com/folke/edgy.nvim

### REPL (python?)
- https://github.com/milanglacier/yarepl.nvim
- https://github.com/Vigemus/iron.nvim
- https://github.com/jpalardy/vim-slime

## Optional

- [ ] https://github.com/ThePrimeagen/harpoon/tree/harpoon2
- [ ] https://github.com/epwalsh/obsidian.nvim
- [ ] https://github.com/skanehira/k8s.vim
- [ ] https://github.com/0oAstro/silicon.lua
- [x] https://github.com/iamcco/markdown-preview.nvim
- [ ] https://github.com/nvim-pack/nvim-spectre
- [ ] https://github.com/zbirenbaum/copilot.lua
- [ ] https://github.com/LintaoAmons/easy-commands.nvim
- [ ] https://github.com/stevearc/oil.nvim # File manager that you interact with usind vim motions

### Debugging

- [ ] https://github.com/jbyuki/one-small-step-for-vimkind
- [ ] https://github.com/folke/trouble.nvim

## Probably won't install

- https://github.com/romgrk/barbar.nvim
- https://github.com/nvim-orgmode/orgmode
- https://github.com/mbbill/undotree
- https://github.com/vimwiki/vimwiki
- https://github.com/NeogitOrg/neogit
- https://github.com/neoclide/coc.nvim
- https://github.com/nvim-telescope/telescope-dap.nvim
- https://github.com/3rd/image.nvim
- https://github.com/edluffy/hologram.nvim
- https://nvimdev.github.io/lspsaga/
- https://github.com/stevearc/conform.nvim
- https://github.com/stevearc/aerial.nvim - Already installed outline

## Themes

Just for reference

- https://github.com/sainnhe/everforest?tab=readme-ov-file
- Catpucchin

# Useful Resources

## General

- https://www.youtube.com/watch?v=oYzZxi3SSnM&list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn&index=7
- https://forum.arduino.cc/t/arduino-and-vim-no-ide-required/882004

## Curated Lists

- https://github.com/rockerBOO/awesome-neovim
- https://vimawesome.com/

## Related Projects

- https://github.com/MashMB/nvim-ide
- https://github.com/glacambre/firenvim
- https://github.com/eyalk11/.vim/blob/win/pycharmst.py

## Dotfiles

- https://github.com/bennypowers/dotfiles/tree/cca747c27d400133dcce9cdce70ed6ab9d0980c1/.config/nvim/lua/plugins/languages
- https://github.com/Dax89/nvim-config/tree/master/lua/plugins
- https://github.com/jdhao/nvim-config/tree/master
- https://github.com/ThePrimeagen/neovimrc/blob/master/lua/theprimeagen/lazy/lsp.lua
- https://github.com/dasupradyumna/.pde

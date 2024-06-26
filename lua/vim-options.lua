vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

vim.wo.number = true
vim.wo.relativenumber = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- CursorHold event trigger time
vim.opt.updatetime = 300

-- Something for auto-session
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Terminal True Colors
vim.opt.termguicolors = true

-- Auto Folding Detection
vim.opt.foldmethod = "indent"
vim.foldenable = false
vim.opt.foldlevel = 99

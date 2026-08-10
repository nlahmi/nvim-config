-- Not used as an API: nvim-lspconfig only ships the lsp/*.lua files that supply
-- each server's cmd/filetypes/root_markers. Our own settings are layered on top
-- via vim.lsp.config in lua/lsp-setup.lua. Neovim bundles no server defaults.
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
}

return {
    "voldikss/vim-browser-search",
    lazy = false,
    keys = {
        { "gs", "<cmd>BrowserSearch<cr>",      mode = "n", desc = "Browser Search" },
        { "gs", "<cmd>'<,'>BrowserSearch<cr>", mode = "v", desc = "Browser Search" },
    },
}

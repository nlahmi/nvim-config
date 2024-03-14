return {
    "glepnir/template.nvim",
    cmd = { "Template", "TemProject" },
    config = function()
        require("template").setup({
            temp_dir = vim.fn.stdpath("config") .. "/templates",
            author = "n.lahmi",
            email = "n@lahmi.co.il",
        })
        require("telescope").load_extension("find_template")
    end,
    keys = {
        { "<leader>fT", "<cmd>Telescope find_template<cr>", desc = "Find Templates" },
        { "<leader>ft", "<cmd>Telescope find_template type=insert<cr>", desc = "Insert Template" },
    }
}

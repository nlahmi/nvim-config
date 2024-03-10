return {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require("project_nvim").setup({ show_hidden = false })
        require("telescope").load_extension("projects")

        vim.keymap.set("n", "<leader>pp", require("telescope").extensions.projects.projects, { desc = "Project Picker" })
    end,
}

return {
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
    keys = {
      { "<leader>rr", "<cmd>CompilerStop<cr><cmd>CompilerRedo<cr>", desc = "Run with Last Config" },
      { "<leader>rc", "<cmd>CompilerOpen<cr>", desc = "Compile Menu" },
      { "<leader>rt", "<cmd>CompilerToggleResults<cr>", desc = "Toggle Compiler Results" },
    },
  },
  { -- The task runner we use
    "stevearc/overseer.nvim",
    commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}

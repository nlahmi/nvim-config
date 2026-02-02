local lang = require("plugins.lsp.lang.all")

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

-- local function reload_vscode_configs()
--   require("dap.ext.vscode").load_launchjs(nil, {
--     gdb = { "c", "cpp" },
--     debugpy = { "python" },
--   })
-- end

return {
  {
    "Joakker/lua-json5",
    lazy = false,
    -- build = "./install.sh",
    -- NOTE: You need cargo (only worked for me using rustup)
    build = function()
      if vim.fn.has("unix") == 1 then
        print("linux!")
        return "./install.sh"
      else
        print("windows!")
        return "powershell ./install.ps1"
      end
    end,
    setup = function()
      require("dap.ext.vscode").json_decode = require("json5").parse
    end,
  },
  {
    "mfussenegger/nvim-dap",
    tag = "0.10.0",
    dependencies = {
      -- Fancy UI for the debugger
      { "rcarriga/nvim-dap-ui" },

      -- Virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          --- A callback that determines how a variable is displayed or whether it should be omitted
          display_callback = function(variable, buf, stackframe, node, options)
            -- By default, strip out new line characters
            local stripped = variable.value:gsub("%s+", " ")

            -- Limit size because it's annoying
            local max_len = 20
            if string.len(stripped) > max_len then
              stripped = string.sub(stripped, 0, max_len) .. "..."
            end

            -- Inline vs not
            if options.virt_text_pos == "inline" then
              return " = " .. stripped
            else
              return variable.name .. " = " .. stripped
            end
          end,
        },
      },

      -- mason.nvim integration
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },
      { "Weissle/persistent-breakpoints.nvim" },
    },

  -- stylua: ignore
  keys = {
    { "<leader>dR", function() require("persistent-breakpoints.api").clear_all_breakpoints() end,      desc = "Clear all Breakpoints" },
    { "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end,          desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end,                                          desc = "Continue" },
    { "<leader>dn", "<cmd>DapNew<cr>",                                                                 desc = "New" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end,                     desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end,                                     desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end,                                             desc = "Go to line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end,                                         desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end,                                              desc = "Down" },
    { "<leader>dk", function() require("dap").up() end,                                                desc = "Up" },
    {
      "<leader>dl",
      function()
        vim.api.nvim_input("<cmd>wa<cr>")

        require("dap").run_last()
      end,
      desc = "Run Last"
    },
    -- { "<leader>dd", function() vim.api.nvim_input("<leader>dl") end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end,                            desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end,                           desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end,                               desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle(nil, "belowright vsplit") end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end,                             desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end,                           desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end,                    desc = "Debug Hover" },
    -- { "<leader>dv", reload_vscode_configs,                                               desc = "Reload .vscode" },
  },

    config = function()
      local Config = require("utils")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Set up lang(s) config functions
      local dap = require("dap")
      for _, f in pairs(lang.dap_config) do
        f(dap)
      end
    end,
  },
}

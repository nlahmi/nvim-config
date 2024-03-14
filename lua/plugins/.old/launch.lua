return {
    "dasupradyumna/launch.nvim",
    dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("launch").setup({
            debug = {
                -- mapping from filetypes to debug adapter names as specified in `require('dap').adapters`
                -- `nil` implies that the filetypes themselves are used as the adapter names
                -- adapters = nil, ---@type table<string, string>

                -- custom debugger launcher function which receives the selected debug configuration as an
                -- argument; `nil` implies `require('dap').run` is used by default
                -- NOTE : users should ignore this unless they know what they are doing
                -- runner = nil, ---@type function

                -- table containing debug configuration template per filetype
                templates = {
                    c = {
                        name = "Default c++ debug",
                        request = "launch",
                        stopAtEntry = true,
                        externalConsole = true,
                        MIMode = "gdb",
                        miDebuggerPath = "/usr/bin/gdb",
                    },
                    cpp = {
                        name = "Default c++ debug",
                        request = "launch",
                        stopAtEntry = true,
                        externalConsole = true,
                        MIMode = "gdb",
                        miDebuggerPath = "/usr/bin/gdb",
                    },
                    python = {
                        name = "Default python debug",
                        request = "launch",
                        console = "integratedTerminal",
                        stopOnEntry = true,
                        justMyCode = false,
                        showReturnValue = true,
                    },
                },
            },

            -- task runner settings
            task = {
                -- whether to render the task output in a tabpage or a floating window, by default
                display = "tab",

                -- whether to enter INSERT mode after launching task in a buffer
                -- insert_on_launch = false, ---@type boolean

                -- same fields as `TaskOptions` in "Task Configuration" subsection
                -- options = {
                --     -- set the default current working directory for all tasks
                --     cwd = nil, ---@type string|fun():string
                --
                --     -- table with definitions of environment variables to be set for all tasks
                --     env = nil, ---@type table<string, string|number>
                --
                --     -- table containing executable and command-line arguments to launch a shell process
                --     shell = nil, ---@type { exec: string, args: string[] }
                -- },
                -- custom task launcher function which receives the selected task configuration as an
            },
        })
    end,
}

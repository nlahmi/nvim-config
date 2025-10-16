return {
  packages = {},

  mason_packages = {
    "harper-ls",
  },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("harper_ls",{
        settings = {
          ["harper-ls"] = {
            linters = {
              spell_check = false,
              -- spelled_numbers = true,
              -- an_a = true,
              sentence_capitalization = false,
              -- unclosed_quotes = true,
              -- wrong_quotes = true,
              long_sentences = false,
              -- repeated_words = true,
              -- spaces = true,
              -- matcher = true,
              -- correct_number_suffix = true,
              -- number_suffix_capitalization = true,
              -- multiple_sequential_pronouns = true,

              -- diagnosticSeverity = "hint" -- Can also be "information", "warning", or "error"

              codeActions = {
                forceStable = true,
              },
            },
          },
        },
      })
    end,
  },
}

return {
  packages = {},

  mason_packages = {
    "harper-ls",
  },

  nonls_packages = {},

  lsp_config = {
    function(lspconfig, capabilities, custom_attach)
      lspconfig.harper_ls.setup({
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

-- Overrides mason-org's tree-sitter-cli, which ships the upstream release binary.
-- That binary is linked against glibc 2.39, so on anything older (Debian 12 has
-- 2.36) it installs "successfully" but cannot run -- and because mason/bin comes
-- first on nvim's PATH it then shadows any working CLI. Building the crate links
-- against the local glibc instead.
--
-- nvim-treesitter's main branch shells out to `tree-sitter build` for every
-- parser, so this has to work for treesitter to work at all.
return {
  schema = "registry+v1",
  name = "tree-sitter-cli",
  description = "The Tree-sitter CLI, used by nvim-treesitter to build parsers. Built from source to match the local glibc.",
  homepage = "https://tree-sitter.github.io/tree-sitter/",
  licenses = { "MIT" },
  languages = {},
  categories = { "Compiler" },
  source = {
    id = "pkg:cargo/tree-sitter-cli@0.26.12",
  },
  bin = {
    ["tree-sitter"] = "cargo:tree-sitter",
  },
}

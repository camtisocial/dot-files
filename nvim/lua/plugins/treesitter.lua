return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = {
        "c",
        "lua",
        "cpp",
        "javascript",
        "json",
        "typescript",
        "sql",
        "rust",
        "css",
        "html",
        "go",
        "markdown",
        "markdown_inline",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}

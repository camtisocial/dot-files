return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "html", "mdx_analyzer", "eslint", "ts_ls", "rust_analyzer", "biome", "ast_grep"},
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.clangd.setup({})
      lspconfig.eslint.setup({})
      lspconfig.html.setup({})
      lspconfig.mdx_analyzer.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.biome.setup({})
      lspconfig.ast_grep.setup({})
      lspconfig.ts_ls.setup({})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end
  },
}

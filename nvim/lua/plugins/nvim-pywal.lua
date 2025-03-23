return {
  "AlphaTechnolog/pywal.nvim",
  lazy = false, -- Load immediately
  priority = 1000, -- Load before other themes
  config = function()
    require("pywal").setup()
  end,
}

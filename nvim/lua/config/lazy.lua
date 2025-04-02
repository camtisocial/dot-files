-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
require("vim-options")
require("lazy").setup({

  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- install = { colorscheme = { "wal" } },
  checker = { enabled = true },
  change_detection = { notify = false },
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#70655c' });
  vim.api.nvim_set_hl(0, 'LineNr', { fg = '#cf9b3f' });
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#70655c' });
  vim.api.nvim_set_hl(0, 'UfoFoldedEllipsis', { fg = '#de499c' });
  vim.api.nvim_set_hl(0, 'UfoFoldedBg', { fg = '#de499c' });
  vim.api.nvim_set_hl(0, 'UfoFoldedFg', { fg = '#de499c' });
  vim.api.nvim_set_hl(0, 'UfoPreviewCursorLine', { fg = '#de499c' });
  vim.api.nvim_set_hl(0, 'UfoFoldedLine', { fg = '#de499c' });
  vim.api.nvim_set_hl(0, 'UfoPreviewWinBar', { fg = '#de499c' });

})

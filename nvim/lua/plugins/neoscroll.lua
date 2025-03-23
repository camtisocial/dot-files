return {
  "karb94/neoscroll.nvim",
  opts = {},
  config = function()
    local neoscroll = require('neoscroll')

    neoscroll.setup({})

    -- Smooth scrolling mappings with cursor centering
    vim.keymap.set('n', '<C-j>', function()
      vim.cmd("normal! zz")
      neoscroll.scroll(10, { smooth = true, duration = 100 })
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<C-k>', function()
      vim.cmd("normal! zz")
      neoscroll.scroll(-10, { smooth = true, duration = 100 })
    end, { noremap = true, silent = true })

    vim.keymap.set('v', '<C-j>', function()
      vim.cmd("normal! zz")
      neoscroll.scroll(10, { smooth = true, duration = 100 })
    end, { noremap = true, silent = true })

    vim.keymap.set('v', '<C-k>', function()
      vim.cmd("normal! zz")
      neoscroll.scroll(-10, { smooth = true, duration = 100 })
    end, { noremap = true, silent = true })

    -- Smooth half-page scrolling with cursor centering
    vim.keymap.set('n', '<C-d>', function()
      vim.cmd("normal! zz")
      neoscroll.scroll(vim.api.nvim_win_get_height(0) / 2, { smooth = true, duration = 300 })
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<C-u>', function()
      vim.cmd("normal! zz")
      neoscroll.scroll(-vim.api.nvim_win_get_height(0) / 2, { smooth = true, duration = 300 })
    end, { noremap = true, silent = true })
  end,
}


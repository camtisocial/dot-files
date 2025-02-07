return {
    "nvim-neo-tree/neo-tree.nvim",
     branch = "v3.x",
     dependencies = {
       "nvim-lua/plenary.nvim",

       "nvim-tree/nvim-web-devicons",
       "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set('n', '<leader>n', function()
      vim.cmd('Neotree filesystem reveal left')
      end, { noremap = true, silent = true })

      vim.keymap.set('n', '<leader>nn', function()
      vim.cmd('Neotree close')
      end, { noremap = true, silent = true })
    end
}


return {
  {
   'nvim-telescope/telescope.nvim', tag = '0.1.8',
   dependencies = { 'nvim-lua/plenary.nvim' },
   config = function ()
     local builtin = require('telescope.builtin')
     vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
     vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
     vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>', { noremap = true, silent = true })
   end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      -- This is your opts table
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        },

        }
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("noice")
    end
  },

}

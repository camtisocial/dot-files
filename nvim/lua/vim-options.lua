vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
--vim.cmd([[autocmd VimEnter * Neotree filesystem reveal left]])

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

--mappings for using leader, can't get this to work with tmux sadly
--vim.keymap.set('n', '<leader>h', '<C-w>h', { noremap = true, silent = true }) -- Move left
--vim.keymap.set('n', '<leader>l', '<C-w>l', { noremap = true, silent = true }) -- Move right
--vim.keymap.set('n', '<leader>j', '<C-w>j', { noremap = true, silent = true }) -- Move down
--vim.keymap.set('n', '<leader>k', '<C-w>k', { noremap = true, silent = true }) -- Move up

--mappings to match tmux navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true }) -- Move left
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true }) -- Move right
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true }) -- Move down
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true }) -- Move up

--mappings to resize windows
vim.keymap.set('n', '<M-S-h>', '<C-w><', { noremap = true, silent = true }) -- Decrease width
vim.keymap.set('n', '<M-S-l>', '<C-w>>', { noremap = true, silent = true }) -- Increase width
vim.keymap.set('n', '<M-S-j>', '<C-w>-', { noremap = true, silent = true }) -- Decrease height
vim.keymap.set('n', '<M-S-k>', '<C-w>+', { noremap = true, silent = true }) -- Increase height

--mappings to move panes
vim.keymap.set('n', '<M-C-h>', '<C-w>H', { noremap = true, silent = true }) -- Move pane left
vim.keymap.set('n', '<M-C-l>', '<C-w>L', { noremap = true, silent = true }) -- Move pane right
vim.keymap.set('n', '<M-C-j>', '<C-w>J', { noremap = true, silent = true }) -- Move pane down
vim.keymap.set('n', '<M-C-k>', '<C-w>K', { noremap = true, silent = true }) -- Move pane up

--mappings for creating splits
vim.keymap.set('n', '<leader>h', '<C-w>s', { noremap = true, silent = true }) -- Split horizontally
vim.keymap.set('n', '<leader>v', '<C-w>v', { noremap = true, silent = true }) -- Split vertically 

vim.keymap.set("i", "hh", "<Esc>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':bd<CR>', { noremap = true, silent = true }) -- Quit buffer
vim.keymap.set('n', '<Tab>', ':bprevious<CR>', { noremap = true, silent = true }) -- Previous buffer
vim.keymap.set('n', '<S-Tab>', ':bnext<CR>', { noremap = true, silent = true }) -- Next buffer
vim.keymap.set('n', '<A-Tab>', ':b#<CR>', { noremap = true, silent = true }) -- switch to last buffer
vim.keymap.set('n', '<leader>/', ':noh<CR><Esc>', { noremap = true, silent = true }) -- clear / search
vim.keymap.set('t', '<leader>t', '<C-\\><C-n>', { noremap = true, silent = true }) -- exit terminal mode
vim.keymap.set('n', '<leader>nt', ':enew | terminal<CR>', { noremap = true, silent = true }) -- new terminal



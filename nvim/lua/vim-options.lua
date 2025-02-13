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

--mappings for scrolling
-- vim.keymap.set('n', '<M-j>', '3<C-e>M', { noremap = true, silent = true }) -- Scroll down 
-- vim.keymap.set('n', '<M-k>', '3<C-y>M', { noremap = true, silent = true }) -- Scroll up 
-- vim.keymap.set('n', '<M-d>', '<C-d>zz', { noremap = true, silent = true }) -- Scroll down half page
-- vim.keymap.set('n', '<M-u>', '<C-u>zz', { noremap = true, silent = true }) -- Scroll up half page

--mappings for search
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true }) -- keep centered while searching
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true }) -- 

--mappings for visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Move selected lines down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- Move selected lines up

--mappings for copy and paste
vim.keymap.set('n', '<leader>y', "\"+y", { noremap = true, silent = true }) -- Copy to clipboard
vim.keymap.set('v', '<leader>y', "\"+y", { noremap = true, silent = true }) -- Copy to clipboard

--escape remap
vim.keymap.set("i", "hh", "<Esc>", { noremap = true, silent = true })

--buffers and windows
vim.keymap.set('n', '<leader>q', ':bd<CR>', { noremap = true, silent = true }) -- Quit buffer
vim.keymap.set('n', '<leader><Tab>', '<C-^>', { noremap = true, silent = true }) -- Switch buffer
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true }) -- Previous buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true }) -- Next buffer
vim.keymap.set('n', '<leader>/', ':noh<CR><Esc>', { noremap = true, silent = true }) -- clear / search
vim.keymap.set('t', '<leader>t', '<C-\\><C-n>', { noremap = true, silent = true }) -- exit terminal mode
vim.keymap.set('n', '<leader>nt', ':enew | terminal<CR>', { noremap = true, silent = true }) -- new terminal

--temporary full screen
vim.keymap.set('n', '<leader>fs', '<C-w>|', { noremap = true, silent = true }) -- full screen
vim.keymap.set('n', '<leader>sf', '<C-w>=', { noremap = true, silent = true }) -- full screen


"vim settings--------------------------------
syntax on
set tabstop=4 softtabstop=4
set shiftwidth=4
set textwidth=0
set wrapmargin=0
set autoindent
set expandtab
set nu
set nowrap
set smartcase
set incsearch
set noerrorbells
set history=1000
set encoding=UTF-8
set showmatch
set termguicolors

"folding settings------------------------------
set foldmethod=indent
set foldlevel=5
set foldclose=all

"file templates------------------------------
:autocmd BufNewFile *.cpp 0r ~/.vim/templates/skeleton.cpp


"plugins-------------------------------------

filetype plugin indent on

if (has("termguicolors"))
    set termguicolors
endif

call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'valloric/python-indent'
Plug 'oblitum/youcompleteme'
Plug 'scrooloose/syntastic'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

colorscheme gruvbox
set background=dark

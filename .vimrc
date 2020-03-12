" Basic vimrc, parts may get overriden by Vundle...
" Remember to run :PluginInstall
set nowrap
set showbreak=+++
set textwidth=100
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4

set ruler
set undolevels=1000
set backspace=indent,eol,start

set mouse-=a

syntax on
filetype plugin indent on

" Vundle specific
set nocompatible                    " be iMproved, required
filetype off                        " required

set rtp+=~/.vim/bundle/Vundle.vim   " Vundle required
call vundle#begin()                 " Vundle required

Plugin 'VundleVim/Vundle.vim'       " Vundle main
Plugin 'bling/vim-airline'

call vundle#end()                   " required
filetype plugin indent on           " required

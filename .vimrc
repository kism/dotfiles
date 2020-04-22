" Basic vimrc, parts may get overriden by Vundle...
" Remember to run :PluginInstall
set nowrap
set mouse-=a

syntax on
filetype plugin indent on

" Vundle specific
set nocompatible                    " be iMproved, required
filetype off                        " required

set rtp+=~/.vim/bundle/Vundle.vim   " Vundle required
call vundle#begin()                 " Vundle required

Plugin 'VundleVim/Vundle.vim'       " Vundle main
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()                   " required
filetype plugin indent on           " required

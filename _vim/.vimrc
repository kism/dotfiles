" Basic vimrc, parts may get overriden by Vundle...
" Remember to run :PluginInstall

" Vundle specific
set nocompatible                    " be iMproved, required
filetype off                        " required

set rtp+=~/.vim/bundle/Vundle.vim   " Vundle required
call vundle#begin()                 " Vundle required

Plugin 'VundleVim/Vundle.vim'       " Vundle main
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth'
" Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()                   " required
filetype plugin indent on           " required

" Regular preferences 
set nowrap                          " Wordwrap off
set mouse-=a                        " Mouse off
set pastetoggle=<F2>                " Toggle paste mode with F2
set t_u7=                           " Fix Windows Terminal compatibility
set tw=0                            " Set text wrapping off for the language formatter
set noshowmode                      " Dont display -- Insert -- since that's handled by vim-airline

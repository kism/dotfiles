" Basic vimrc, parts may get overriden by NeoBundle...
" Remember to run :PluginInstall

" NeoBundle specific
set nocompatible                    " be iMproved, required
filetype off                        " required

set runtimepath+=~/.vim/bundle/neobundle.vim/    " required
call neobundle#begin(expand('~/.vim/bundle/'))   " required

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle  'tpope/vim-sensible'
NeoBundle  'tpope/vim-sleuth'
NeoBundle  'vim-airline/vim-airline'
NeoBundle  'vim-airline/vim-airline-themes'

call neobundle#end()                " required
filetype plugin indent on           " required

NeoBundleCheck

" Regular preferences
set nowrap                          " Wordwrap off
set mouse-=a                        " Mouse off
set pastetoggle=<F2>                " Toggle paste mode with F2
set t_u7=                           " Fix Windows Terminal compatibility
set tw=0                            " Set text wrapping off for the language formatter
set noshowmode                      " Dont display -- Insert -- since that's handled by vim-airline

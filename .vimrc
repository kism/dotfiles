" .vimrc

" Wrapping
set nowrap
set showbreak=+++
set textwidth=100

" Search
set hlsearch
set smartcase
set ignorecase
set incsearch

" Indent
set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4

" Keymaps
map q <Nop>

" Misc preferences
set mouse-=a                        " Mouse off
set pastetoggle=<F2>                " Toggle paste mode with F2
set t_u7=                           " Fix Windows Terminal compatibility
set tw=0                            " Set text wrapping off for the language formatter
set ruler
set undolevels=1000
set backspace=indent,eol,start
set showmatch
set visualbell
set nonumber

syntax on
filetype plugin indent on

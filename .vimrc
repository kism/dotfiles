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
set mouse-=a                   " Mouse off
set pastetoggle=<F2>           " Toggle paste mode with F2
set t_u7=                      " Fix Windows Terminal compatibility
set tw=0                       " Set text wrapping off for the language formatter
set undolevels=1000            " Set the number of undos
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set showmatch                  " Show matching brackets
set visualbell                 " No beeping
set nonumber                   " No line numbers

" Speed up responsiveness
set ttimeout
set ttimeoutlen=1
set ttyfast

" Set terminal cursor shape depending on terminal
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Statusline
set noshowmode
set laststatus=2
set statusline=
set statusline+=\ %f
set statusline+=\ 
set statusline+=%m\ 
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

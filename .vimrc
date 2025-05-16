" .vimrc

" Wrapping
set nowrap        " Don't wrap lines
set showbreak=+++ " Show a break line when wrapping
set textwidth=100 " Wrap lines at 100 characters

" Search
set hlsearch    " Highlight search results
set smartcase   " Override ignorecase if the search pattern contains uppercase characters
set ignorecase  " Ignore case when searching
set incsearch   " Incremental search

" Indent
set autoindent     " Copy indent from current line when starting a new line
set shiftwidth=4   " Number of spaces to use for autoindent
set smartindent    " Do smart autoindenting when starting a new line
set smarttab       " Use shiftwidth for tabstop
set softtabstop=4  " Number of spaces that a <Tab> in the file counts for

" Keymaps
map q <Nop> " Prevent myself from entering macro mode

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
syntax on                      " Syntax highlighting

" Speed up responsiveness
set ttimeout
set ttimeoutlen=1
set ttyfast

" Set terminal cursor shape depending on terminal
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif


" Set colour mode depending on terminal type
if $TERM_PROGRAM == 'Apple_Terminal'
elseif $TERM !~? '^\(vt\|linux\|ansi\)'
    set termguicolors
endif

" Statusline
" https://pastebin.com/qWRQVzES
" https://shapeshed.com/vim-statuslines/
"red, yellow, green, blue, magenta, cyan, white, black, gray

" Default matches normal mode
highlight ModeIndicator       guifg=#FFFFFF guibg=#808080 ctermfg=black ctermbg=white
" These are constants
highlight StatusLineRegularBG guifg=#FFFFFF guibg=#444444 ctermfg=black ctermbg=gray
highlight StatusLineLineInfo  guifg=#FFFFFF guibg=#808080 ctermfg=white ctermbg=black
highlight StatusLineFileType  guifg=#FFFFFF guibg=#008080 ctermfg=black ctermbg=white

function! SetModeColour()
    let l:current_mode = mode()

    if l:current_mode==#"n"
        highlight ModeIndicator guifg=#FFFFFF guibg=#808080 ctermfg=white ctermbg=black
    elseif l:current_mode==#"i"
        highlight ModeIndicator guifg=#FFFFFF guibg=#00af00 ctermfg=black ctermbg=green
    elseif l:current_mode==#"c"
        highlight ModeIndicator guifg=#FFFFFF guibg=#008080 ctermfg=black ctermbg=green
    elseif l:current_mode==#"v"
        highlight ModeIndicator guifg=#FFFFFF guibg=#800080 ctermfg=black ctermbg=magenta
    elseif l:current_mode==#"V"
        highlight ModeIndicator guifg=#FFFFFF guibg=#800080 ctermfg=black ctermbg=magenta
    elseif l:current_mode==#"\<C-v>"
        highlight ModeIndicator guifg=#FFFFFF guibg=#800080 ctermfg=black ctermbg=magenta
    elseif l:current_mode==#"R"
        highlight ModeIndicator guifg=#FFFFFF guibg=#808000 ctermfg=black ctermbg=yellow    
    elseif l:current_mode==#"t"
        highlight ModeIndicator guifg=#FFFFFF guibg=#808000 ctermfg=black ctermbg=yellow
    endif
endfunction

function! GetNiceMode()
    call SetModeColour()
    let l:current_mode = mode()
    let l:mode_map = {'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'}
    let l:mode_str = get(l:mode_map, l:current_mode, '')
    if &paste
        let l:mode_str = l:mode_str . ' PASTE'
    endif

    return l:mode_str
endfunction

function! GetNiceFileType()
    let l:filetype = &filetype
    if l:filetype ==# ''
        return 'text'
    endif
    return l:filetype
endfunction

set noshowmode
set laststatus=2

function SetStatusLine()
    set statusline=
    set statusline+=%#ModeIndicator#
    set statusline+=\ 
    set statusline+=%{GetNiceMode()}
    set statusline+=\ 
    set statusline+=%#StatusLineRegularBG#
    set statusline+=\ 
    set statusline+=\ %f
    set statusline+=%m
    set statusline+=\ 
    set statusline+=%=
    set statusline+=%#StatusLineFileType#
    set statusline+=\ 
    set statusline+=%{GetNiceFileType()}
    set statusline+=\ 
    set statusline+=%#StatusLineLineInfo#
    set statusline+=\ 
    set statusline+=%{&fileencoding?&fileencoding:&encoding}
    set statusline+=\     
    set statusline+=\[%{&fileformat}\]
    set statusline+=\ %p%%
    set statusline+=\ %l:%c
    set statusline+=\ 
endfunction

augroup SetStatusLineColour
    autocmd!
    autocmd BufEnter,WinEnter * call SetStatusLine()
augroup END

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

highlight ModeIndicator       guifg=#FFFFFF guibg=#808080 ctermfg=15 ctermbg=8
highlight StatusLineRegularBG guifg=#FFFFFF guibg=#444444 ctermfg=15 ctermbg=8
highlight StatusLineFileType  guifg=#FFFFFF guibg=#008080 ctermfg=15 ctermbg=6
highlight StatusLineLineInfo  guifg=#FFFFFF guibg=#808080 ctermfg=15 ctermbg=8
highlight StatusLineExtra     guifg=#FFFFFF guibg=#FF0000 ctermfg=15 ctermbg=1

function SetModeColour()
    let l:current_mode = mode()

    if l:current_mode==#"n"
        highlight ModeIndicator guifg=#FFFFFF guibg=#808080 ctermfg=15 ctermbg=8
    elseif l:current_mode==#"i"
        highlight ModeIndicator guifg=#FFFFFF guibg=#00af00 ctermfg=15 ctermbg=2
    elseif l:current_mode==#"c"
        highlight ModeIndicator guifg=#FFFFFF guibg=#008080 ctermfg=15 ctermbg=6
    elseif l:current_mode==#"v"
        highlight ModeIndicator guifg=#FFFFFF guibg=#800080 ctermfg=15 ctermbg=5
    elseif l:current_mode==#"V"
        highlight ModeIndicator guifg=#FFFFFF guibg=#800080 ctermfg=15 ctermbg=5
    elseif l:current_mode==#"\<C-v>"
        highlight ModeIndicator guifg=#FFFFFF guibg=#800080 ctermfg=15 ctermbg=5
    elseif l:current_mode==#"R"
        highlight ModeIndicator guifg=#FFFFFF guibg=#808000 ctermfg=15 ctermbg=3    
    elseif l:current_mode==#"s"
           
    elseif l:current_mode==#"t"
        highlight ModeIndicator guifg=#FFFFFF guibg=#808000 ctermfg=15 ctermbg=3
    endif
endfunction

function! GetNiceMode()
    let l:current_mode = mode()
    let l:mode_map = {'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'}
    return get(l:mode_map, l:current_mode, '')
endfunction

au InsertLeave,InsertEnter,BufWritePost   * call SetModeColour()
set noshowmode
set laststatus=2

set statusline=
set statusline+=%#ModeIndicator#
set statusline+=\ 
set statusline+=%{GetNiceMode()}
set statusline+=\ 
set statusline+=%#StatusLineRegularBG#
set statusline+=\ %f
set statusline+=\ 
set statusline+=%m\ 
set statusline+=%=
set statusline+=\ %y
set statusline+=%#StatusLineExtra#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

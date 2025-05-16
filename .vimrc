" .vimrc
" https://learnvimscriptthehardway.stevelosh.com/
" https://learnvim.irian.to/

" Wrapping
set nowrap        " Don't wrap lines by default
set showbreak=+++ " When wrapping, show a break line when wrapping
set textwidth=100 " When wrapping, wrap at 120 characters

" Search
set hlsearch    " Highlight search results
set smartcase   " Override ignorecase if the search pattern contains uppercase characters
set ignorecase  " Ignore case when searching
set incsearch   " Incremental search, real time results as you type

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
set undolevels=250             " Set the number of undos
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set showmatch                  " Show matching brackets
set visualbell                 " No beeping
set nonumber                   " No line numbers
syntax on                      " Syntax highlighting

" Speed up responsiveness, uncomment the first two if you get a weird g inserted when opening a file?
set ttimeout        " Speed up changing modes
set ttimeoutlen=10  " Speed up changing modes
set ttyfast         " Break compatibility with serial terminals

" Set colour mode depending on terminal type
if $TERM !~? '^\(vt\|linux\|ansi\)'
    " Apple Terminal.app struggles with 256 colours, despite using xterm-256color???
    if $TERM_PROGRAM !=# 'Apple_Terminal' " Depending on :set ignorecase/noignorecase the == is case sensitive, we use ==#
        set termguicolors
    endif

    " Set the terminal cursor depending on the mode
    let &t_SI = "\e[6 q" " Insert mode
    let &t_EI = "\e[2 q" " Normal mode
    let &t_SR = "\e[4 q" " Replace mode

    " Reset the cursor on startup
    augroup myCmds
    au!
    autocmd VimEnter * silent !echo -ne "\e[2 q"
    augroup END
endif

" Statusline
" https://pastebin.com/qWRQVzES
" https://shapeshed.com/vim-statuslines/
" red, yellow, green, blue, magenta, cyan, white, black, gray

" Default matches normal mode
highlight ModeIndicator       guifg=#FFFFFF guibg=#808080 ctermfg=black ctermbg=white
" These are constants, for other parts of the statusline
highlight StatusLineRegularBG guifg=#FFFFFF guibg=#444444 ctermfg=black ctermbg=gray
highlight StatusLineLineInfo  guifg=#FFFFFF guibg=#808080 ctermfg=white ctermbg=black
highlight StatusLineFileType  guifg=#FFFFFF guibg=#008080 ctermfg=black ctermbg=white

function! SetModeColour()
    " Depending on the mode, set the colour of ModeIndicator
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
    " Get the mode, return a string that nicely represents it
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
    " Get the file type, if not possible return 'text'
    let l:filetype = &filetype
    if l:filetype ==# ''
        return 'text'
    endif
    return l:filetype
endfunction

set noshowmode   " Do not show -- INSERT --
set laststatus=2 " Two rows, status line, command line

function SetStatusLine()
    " On god this is the best way to do this
    " Seriously, look at github 'set statusline+=' in the code search
    " https://learnvimscriptthehardway.stevelosh.com/chapters/17.html
    set statusline=                                      " Clear the statusline
    set statusline+=%#ModeIndicator#\ %{GetNiceMode()}\  " Set the colour for the mode indication, print the mode per the GetNiceMode function
    set statusline+=%#StatusLineRegularBG#               " Set the colour for the bulk of the statusline
    set statusline+=\ \ %f\ %m                           " Two spaces and then print the file path, modified flag
    set statusline+=%=                                   " Expand the next part of the statusline to the right
    set statusline+=%#StatusLineFileType#\ %{GetNiceFileType()}\  " Set the colour for the file type, print the file type per the GetNiceFileType function
    set statusline+=%#StatusLineLineInfo#                " Set the colour for the status line
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}\   " Print the file encoding (utf-8, utf-16, etc)
    set statusline+=\[%{&fileformat}\]                   " In square brackets, print the file format (unix, dos, mac)
    set statusline+=\ %p%%                               " Print the percent through the file
    set statusline+=\ %l:%c\                             " Print the line number, column number
endfunction

augroup SetStatusLineColour
    autocmd!
    autocmd BufEnter,WinEnter * call SetStatusLine()
augroup END

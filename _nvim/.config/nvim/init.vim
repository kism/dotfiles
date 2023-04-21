" Plug Init
call plug#begin()
" Basics
Plug 'tpope/vim-sensible'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" Python
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
" Themes
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'
call plug#end()

lua << END
require('lualine').setup{
  options = {
    icons_enabled = false,
    theme = 'powerline_custom',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  }
}
END

" Cursorline
set cursorline                    " highlight current cursorline
highlight CursorLine cterm=NONE   " remove underline
highlight CursorLine ctermbg=238  " set cursorline to dark grey

" Number
set number
highlight LineNr       ctermfg=250  " set linenumber colour
highlight CursorLineNr cterm=NONE   " remove underline
highlight CursorLineNr ctermbg=234  " set linenumber bg
highlight CursorLineNr ctermfg=255  " set linenumber fg

" List
set list
set listchars=tab:▷▷,trail:◄,extends:>,precedes:<

" Paste Toggle
nnoremap <F2> :set cursorline! <Bar> set number! <Bar> set paste! <Bar> set list!<CR>

" Indentation, 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab

" Regular preferences
set nowrap                  " Wordwrap off
set mouse=                  " Mouse off
set tw=0                    " Set text wrapping off for the language formatter
set noshowmode              " Dont display -- Insert -- since that's handled by ???
set ttyfast                 " Speed up scrolling in Vim

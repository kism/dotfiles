call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
call plug#end()

lua << END
require('lualine').setup{
  options = {
    icons_enabled = false,
    theme = 'powerline',
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
highlight LineNr       ctermfg=250
highlight CursorLineNr cterm=NONE   " remove underline
highlight CursorLineNr ctermbg=234  " set cursorline to dark grey
highlight CursorLineNr ctermfg=255  " set cursorline to dark grey


" Paste Toggle
nnoremap <F2> :set cursorline! <Bar> set number! <Bar> set paste!<CR>

" Regular preferences
set nocompatible            " disable compatibility to old-time vi
set nowrap                  " Wordwrap off
set mouse=                  " Mouse off
set tw=0                    " Set text wrapping off for the language formatter
set noshowmode              " Dont display -- Insert -- since that's handled by ???
set ttyfast                 " Speed up scrolling in Vim

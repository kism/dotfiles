--- Plug Init
local vim = vim
local Plug = vim.fn['plug#']
vim.call('plug#begin')

--- Basics
Plug('tpope/vim-sensible')
Plug('nvim-lualine/lualine.nvim')
Plug('kyazdani42/nvim-web-devicons')

--- Python
Plug('Shougo/deoplete.nvim', { ['do'] = function()
  vim.fn[':UpdateRemotePlugins']()
end })
Plug('deoplete-plugins/deoplete-jedi')
Plug('averms/black-nvim', { ['do'] = function()
  vim.fn[':UpdateRemotePlugins']()
end })

--- Themes
Plug('folke/tokyonight.nvim')
Plug('morhetz/gruvbox')
Plug('mhartington/oceanic-next')

vim.call('plug#end')

require('lualine').setup{
  options = {
    icons_enabled = false,
    theme = 'powerline_custom',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  }
}

--- Cursorline
vim.cmd('set cursorline')                    --- highlight current cursorline
vim.cmd('highlight CursorLine cterm=NONE')   --- remove underline
vim.cmd('highlight CursorLine ctermbg=238')  --- vim.cmd('set cursorline to dark grey

--- Number
vim.cmd('set number')
vim.cmd('highlight LineNr       ctermfg=250')  --- vim.cmd('set linenumber colour
vim.cmd('highlight CursorLineNr cterm=NONE')   --- remove underline
vim.cmd('highlight CursorLineNr ctermbg=234')  --- vim.cmd('set linenumber bg
vim.cmd('highlight CursorLineNr ctermfg=255')  --- vim.cmd('set linenumber fg

--- List
vim.cmd('set list')
vim.cmd('set listchars=tab:▷▷,trail:◄,extends:>,precedes:<')

--- Paste Toggle
vim.cmd('nnoremap <F2> :set cursorline! <Bar> set number! <Bar> set paste! <Bar> set list!<CR>')

--- Indentation, 4 spaces
vim.cmd('set tabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set softtabstop=0')
vim.cmd('set expandtab')

--- Regular preferences
vim.cmd('set nowrap')                  --- Wordwrap off
vim.cmd('set mouse=')                  --- Mouse off
vim.cmd('set tw=0')                    --- vim.cmd('set text wrapping off for the language formatter
vim.cmd('set noshowmode')              --- Dont display -- Insert -- since that's handled by ???
vim.cmd('set ttyfast')                 --- Speed up scrolling in Vim

--- Binds
vim.cmd('map q <Nop>')                 --- Speed up scrolling in Vim



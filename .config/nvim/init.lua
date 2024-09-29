--- Plug Init
local vim = vim

local handle = io.popen("id -u")
local user_id = handle:read("*a")
handle:close()

user_id = user_id:gsub("%s+", "")

if user_id ~= "0" then
    -- vim.print("we are not root!")
    local Plug = vim.fn['plug#']
    vim.call('plug#begin')

    --- Basics
    -- Plug('tpope/vim-sensible')
    Plug('nvim-lualine/lualine.nvim')
    Plug('kyazdani42/nvim-web-devicons')

    --- Python
    Plug('Shougo/deoplete.nvim', {
        ['do'] = function()
            vim.fn[':UpdateRemotePlugins']()
        end
    })
    Plug('deoplete-plugins/deoplete-jedi')

    vim.call('plug#end')

    require('lualine').setup {
        options = {
            icons_enabled = false,
            theme = 'powerline_custom',
            component_separators = {
                left = '',
                right = ''
            },
            section_separators = {
                left = '',
                right = ''
            }
        }
    }
end

--- Set transparent background
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

--- Set transparent background
vim.cmd [[
  highlight Normal guibg=none
  highlight Normal ctermbg=none
  highlight NonText guibg=none
  highlight NonText ctermbg=none
]]

--- Cursorline
vim.cmd('set cursorline') --- highlight current cursorline
vim.cmd('highlight CursorLine cterm=NONE') --- remove underline
vim.cmd('highlight CursorLine ctermbg=238') --- vim.cmd('set cursorline to dark grey

--- Number
vim.cmd('set number')
vim.cmd('highlight LineNr       ctermfg=250') --- vim.cmd('set linenumber colour
vim.cmd('highlight CursorLineNr cterm=NONE') --- remove underline
vim.cmd('highlight CursorLineNr ctermbg=234') --- vim.cmd('set linenumber bg
vim.cmd('highlight CursorLineNr ctermfg=255') --- vim.cmd('set linenumber fg

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
vim.cmd('set nowrap') --- Wordwrap off
vim.cmd('set mouse=') --- Mouse off
vim.cmd('set tw=0') --- vim.cmd('set text wrapping off for the language formatter
vim.cmd('set noshowmode') --- Dont display -- Insert -- since that's handled by The statusline

vim.cmd('set ttyfast') --- Speed up scrolling in Vim

--- Binds
vim.cmd('map q <Nop>') --- Unbind macros

if user_id == "0" then --- Statusline (Root user) https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
    -- vim.print("we are root!")
    local modes = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        ["s"] = "SELECT",
        ["S"] = "SELECT LINE",
        [""] = "SELECT BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rv"] = "VISUAL REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MOAR",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL"
    }

    local function mode()
        local current_mode = vim.api.nvim_get_mode().mode
        return string.format(" %s ", modes[current_mode]):upper()
    end

    local function update_mode_colors()
        local current_mode = vim.api.nvim_get_mode().mode
        local mode_color = "%#StatusLineAccent#"
        if current_mode == "n" then
            mode_color = "%#StatuslineAccent#"
        elseif current_mode == "i" or current_mode == "ic" then
            mode_color = "%#StatuslineInsertAccent#"
        elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
            mode_color = "%#StatuslineVisualAccent#"
        elseif current_mode == "R" then
            mode_color = "%#StatuslineReplaceAccent#"
        elseif current_mode == "c" then
            mode_color = "%#StatuslineCmdLineAccent#"
        elseif current_mode == "t" then
            mode_color = "%#StatuslineTerminalAccent#"
        end
        return mode_color
    end

    local function filepath()
        local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
        if fpath == "" or fpath == "." then
            return " "
        end

        return string.format(" %%<%s/", fpath)
    end

    local function filename()
        local fname = vim.fn.expand "%:t"
        if fname == "" then
            return ""
        end
        return "%#INVALIDWIP#" .. fname .. " "
    end

    local function filetype()
        return string.format(" %s ", vim.bo.filetype):upper()
    end

    local function lineinfo()
        if vim.bo.filetype == "alpha" then
            return ""
        end
        return " %P %l:%c "
    end

    Statusline = {}

    Statusline.active = function()
        return table.concat {"%#Statusline#", update_mode_colors(), mode(), "%#Normal# ", filepath(), filename(),
                             "%#Normal#", "%=%#StatusLineExtra#", filetype(), lineinfo()}
    end

    function Statusline.inactive()
        return " %F"
    end

    function Statusline.short()
        return "%#StatusLineNC#   NvimTree"
    end

    vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
    augroup END
    ]], false)

end

--- Define vim object?
local vim = vim

--- Wrapping
vim.cmd('set nowrap') --- Wordwrap off

--- Search, Neovim defaults are fine

--- Indentation, 4 spaces
vim.cmd('set expandtab')
vim.cmd('set autoindent')
vim.cmd('set tabstop=4')
vim.cmd('set shiftwidth=4')
-- vim.cmd('set softtabstop=0')

--- Keymaps
vim.cmd('map q <Nop>') --- Unbind macros

-- Misc, Neovim defaults are fine
vim.cmd('set mouse=')     --- Mouse off
vim.cmd('set tw=0')       --- Set text wrapping off for the language formatter
vim.cmd('set noshowmode') --- Don't display -- Insert -- since that's handled by The statusline


--- Speed up responsiveness, Neovim defaults are fine

--- Setup colour modes
vim.cmd('set termguicolors') --- Enable 24-bit RGB colours
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
]] --- Set transparent background

--- List, Show whitespace (tabs (don't like them), trailing spaces)
vim.cmd('set list')
vim.cmd('set listchars=tab:▷▷,trail:◄,extends:>,precedes:<')

--- Cursorline
vim.cmd('set cursorline')                                   --- highlight current cursorline
vim.cmd('highlight CursorLine guifg=#FFFFFF guibg=#444444') --- Set cursorline colour

--- Number
vim.cmd('set number') --- show line numbers
vim.cmd [[
    highlight LineNr guifg=#808080 guibg=None
    highlight CursorLineNr guifg=#FFFFFF guibg=#444444
    highlight NonText guifg=#808080 guibg=None
]] --- Set line number colours

--- Paste Toggle on F2
vim.cmd('nnoremap <F2> :set cursorline! <Bar> set number! <Bar> set paste! <Bar> set list!<CR>')

--- Statusline https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
--- Set default statusline colours
vim.cmd [[
    highlight ModeIndicatorNormal guifg=#FFFFFF guibg=#808080
    highlight ModeIndicatorInsert guifg=#FFFFFF guibg=#00af00
    highlight ModeIndicatorVisual guifg=#FFFFFF guibg=#800080
    highlight ModeIndicatorReplace guifg=#FFFFFF guibg=#808000
    highlight ModeIndicatorCmdLine guifg=#FFFFFF guibg=#008080
    highlight ModeIndicatorTerminal guifg=#FFFFFF guibg=#808000
    highlight StatusLineRegularBG guifg=#FFFFFF guibg=#444444
    highlight StatusLineFileType guifg=#FFFFFF guibg=#008080
    highlight StatusLineLineInfo guifg=#FFFFFF guibg=#808080
    highlight StatusLineExtra guifg=#FFFFFF guibg=#FF0000
]]

-- Mode mapping
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

local function mode() --- Returns the current mode
    local current_mode = vim.api.nvim_get_mode().mode
    local paste = vim.o.paste and "PASTE" or ""
    if paste ~= "" then
        return string.format(" %s %s ", modes[current_mode], paste):upper()
    end
    return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colours() --- Update mode indicator colours
    local current_mode = vim.api.nvim_get_mode().mode
    local mode_colour = "%#StatusLineAccent#"
    if current_mode == "n" then
        mode_colour = "%#ModeIndicatorNormal#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_colour = "%#ModeIndicatorInsert#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
        mode_colour = "%#ModeIndicatorVisual#"
    elseif current_mode == "R" then
        mode_colour = "%#ModeIndicatorReplace#"
    elseif current_mode == "c" then
        mode_colour = "%#ModeIndicatorCmdLine#"
    elseif current_mode == "t" then
        mode_colour = "%#ModeIndicatorTerminal#"
    end
    return mode_colour
end

local function filepath() --- Returns the current file path
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then
        return " "
    end
    local out = string.format(" %%<%s/", fpath)

    return "%#StatusLineRegularBG#" .. out
end

local function filename() --- Returns the current file name
    local fname = vim.fn.expand "%:t"
    if fname == "" then
        return ""
    end
    return "%#StatusLineRegularBG#" .. fname .. " "
end

local function filetype() --- Returns the current file type, defaults to text
    local out = string.format(" %s ", vim.bo.filetype):lower()
    if vim.bo.filetype == "" then
        out = " text "
    end

    return "%#StatusLineFileType#" .. out
end

local function lineinfo() --- Returns the current line number and column
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return " %P %l:%c "
end

local function encoding()
    return "%#StatusLineLineInfo#" .. " %{&fileencoding?&fileencoding:&encoding} [%{&fileformat}] "
end

--- Build the statusline
Statusline = {}
Statusline.active = function()
    return table.concat { "%#Statusline#", update_mode_colours(), mode(), "%#StatusLineRegularBG# ", filepath(),
        filename(), "%#StatusLineRegularBG#", "%=%#StatusLineExtra#", filetype(), encoding(), lineinfo() }
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

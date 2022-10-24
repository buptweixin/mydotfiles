-- basics
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.termguicolors  = true
vim.opt.shiftround     = true
vim.opt.updatetime     = 100
vim.opt.cursorline     = true
vim.opt.cursorcolumn   = true
vim.opt.autowrite      = true
vim.opt.autoread       = true
vim.opt.smarttab       = true
vim.opt.history        = 2000
vim.opt.wildignore     = "*.swp,*.bak,*.pyc,*.class,.svn,*.o,*~"
vim.opt.magic          = true
vim.opt.showcmd        = true
vim.opt.showmode       = true
vim.opt.scrolloff      = 7
vim.opt.backup         = false
vim.opt.swapfile       = false 
vim.opt.laststatus     = 2
vim.opt.showmatch      = true
vim.opt.matchtime      = 2 -- How many tenths of a second to blink when matching brackets
vim.opt.incsearch      = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.hidden         = true
vim.opt.wildmode       = "list:longest"
vim.opt.ttyfast        = true
vim.opt.encoding       = "utf-8"
vim.opt.fileencodings  = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"
vim.opt.termencoding   = "utf-8"
vim.opt.ffs            = "unix,dos,mac"
vim.opt.completeopt    = "longest,menu"
vim.opt.wildmenu       = true
-- using absolute column number in insert mode, otherwise relateive column number.
vim.api.nvim_create_autocmd('InsertEnter', { command = "set norelativenumber number" })
vim.api.nvim_create_autocmd('InsertLeave', { command = "set relativenumber" })
vim.api.nvim_create_autocmd('InsertLeave', { command = "set nopaste" })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = '*.py', command = "inoremap # X<c-h>#" })

vim.opt.hlsearch       = true
if (vim.fn.has('termguicolors') == 1) then
	vim.opt.termguicolors = true
end

-- indent
vim.opt.smartindent    = true
vim.opt.autoindent  = true

-- tabs
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.smarttab    = true
vim.opt.mouse       = 'a'
vim.opt.shiftround  = true
vim.opt.expandtab   = true
vim.opt.autowrite   = false
vim.opt.formatoptions = ''

require("core.keymaps")
--require("core.dvorak")	-- delete this line if you don't like using DVORAK
require("core.plugins")
--require("core.gui")
-- disable some useless standard plugins to save startup time
-- these features have been better covered by plugins
--vim.g.loaded_matchparen        = 1
--vim.g.loaded_matchit           = 1
--vim.g.loaded_logiPat           = 1
--vim.g.loaded_rrhelper          = 1
--vim.g.loaded_tarPlugin         = 1
--vim.g.loaded_gzip              = 1
--vim.g.loaded_zipPlugin         = 1
--vim.g.loaded_2html_plugin      = 1
--vim.g.loaded_shada_plugin      = 1
--vim.g.loaded_spellfile_plugin  = 1
--vim.g.loaded_netrw             = 1
--vim.g.loaded_netrwPlugin       = 1
--vim.g.loaded_tutor_mode_plugin = 1
--vim.g.loaded_remote_plugins    = 1
require("core.theme")

require('image').setup {
	min_padding = 5,
	show_label = true,
	render_using_dither = true,
    foreground_color = false,
    background_color = false,
    events = {
    update_on_nvim_resize = true,
  },
}
--
---- Load plugin configs
---- plugins without extra configs are configured directly here
--require("impatient")
--
require("configs.autocomplete").config()
require("configs.symbols_outline").config()
require("configs.statusline").config()
require("configs.filetree").config()
require("configs.treesitter").config()
require("configs.startscreen").config()
require("configs.git").config()
require("configs.bufferline").config()
require("configs.terminal").config()

vim.g.mapleader = ','

local function set_bg_light()
    vim.cmd('set background=light')
    local colors_name = vim.g.colors_name
    vim.cmd('colorscheme shine')
    vim.cmd('colorscheme ' .. colors_name)
end

local function set_bg_dark()
    vim.cmd('set background=dark')
    local colors_name = vim.g.colors_name
    vim.cmd('colorscheme ron')
    vim.cmd('colorscheme ' .. colors_name)
end

local function number_toggle()
    if vim.opt.relativenumber then
       vim.opt.relativenumber = false
       vim.opt.number = true
    else
        vim.opt.relativenumber = true
    end
end


-- keymaps
--vim.keymap.set({'i', 'n'}, 'kj', '<esc>')
vim.keymap.set({'x', 'n'}, ';', ':')
vim.keymap.set('i', '<C-g>', '<esc>')
vim.keymap.set('i', '<C-;>', '::') -- for C++ and Rust
vim.keymap.set('n', '<leader>vl', set_bg_light)
vim.keymap.set('n', '<leader>vd', set_bg_dark)
vim.keymap.set('n', '<leader>', ':')
vim.keymap.set('n', '<leader>n', number_toggle)
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gk', 'k')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('i', '<C-a>', '<C-o>0')
vim.keymap.set('i', '<C-e>', '<C-o>$')
vim.keymap.set('n', '<Space>', '<C-F>')
vim.keymap.set('x', 'v', '<C-V>')
vim.keymap.set('c', '<C-V>', '<C-R>+')
vim.keymap.set('c', '<C-j>', '<t_kd>')
vim.keymap.set('c', '<C-k>', '<t_ku>')
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
-- Keep search pattern at the center of the screen.
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
vim.keymap.set('n', '<leader>/', ':nohls<CR>', { silent = true }) -- remove search highlight
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>v', 'V`}')
vim.keymap.set('c', 'w!!', 'w !sudo tee >/dev/null %`}')
vim.keymap.set('n', '<C-e>', '2<C-e>')
vim.keymap.set('n', '<C-y>', '2<C-y>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')

-- 交换 ' `, 使得可以快速使用'跳到marked位置
vim.keymap.set('n', "'", '`')
vim.keymap.set('n', '`', "'")

-- switch * and #
vim.keymap.set('n', '*', '#')
vim.keymap.set('n', '#', '*')

vim.keymap.set('n', 'U', '<C-r>')



-- tabs
vim.keymap.set('n', '<leader>1', '1gt')
vim.keymap.set('n', '<leader>2', '2gt')
vim.keymap.set('n', '<leader>3', '3gt')
vim.keymap.set('n', '<leader>4', '4gt')
vim.keymap.set('n', '<leader>5', '5gt')
vim.keymap.set('n', '<leader>6', '6gt')
vim.keymap.set('n', '<leader>7', '7gt')
vim.keymap.set('n', '<leader>8', '8gt')
vim.keymap.set('n', '<leader>9', '9gt')
vim.keymap.set('n', '<leader>0', ':tablast<cr>')
-- f: file tree
vim.keymap.set('n', '<F3>', ':NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>ft', ':NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>ff', ':NvimTreeFocus<cr>')
-- paste mode
vim.opt.pastetoggle = '<F6>'
-- y: telescope
require('telescope').load_extension('projects')
vim.keymap.set('n', '<F7>', function() require 'telescope.builtin'.current_buffer_fuzzy_find {} end)
vim.keymap.set('n', '<F8>', function() require 'telescope.builtin'.registers {} end)
vim.keymap.set('n', '<F9>', function() require 'telescope.builtin'.find_files {} end)
vim.keymap.set('n', '<F10>', function() require 'telescope.builtin'.git_files {} end)
vim.keymap.set('n', '<F11>', function() require 'telescope.builtin'.buffers {} end)
vim.keymap.set({ 'n', 'i' }, '<C-p>', function() require 'telescope.builtin'.oldfiles {} end)
-- w: window
vim.keymap.set('n', '<leader>w1', '<c-w>o')
vim.keymap.set('n', '<leader>wx', ':x<cr>')
vim.keymap.set('n', '<leader>w2', ':sp<cr>')
vim.keymap.set('n', '<leader>w3', ':vs<cr>')
-- window resize
vim.keymap.set('n', '<m-9>', '<c-w><')
vim.keymap.set('n', '<m-0>', '<c-w>>')
vim.keymap.set('n', '<m-->', '<c-w>-')
vim.keymap.set('n', '<m-=>', '<c-w>+')
-- b: buffer
vim.keymap.set('n', '[b', ':bprevious<cr>')
vim.keymap.set('n', ']b', ':bnext<cr>')
vim.keymap.set('n', ']d', ':Bdelete<cr>')
-- p: plugins
vim.keymap.set('n', '<leader>pi', ':PackerInstall<cr>')
vim.keymap.set('n', '<leader>pc', ':PackerClean<cr>')
-- s: search
vim.keymap.set('n', '<leader>ss', '/')
vim.keymap.set('n', '<leader>sw', '/\\<lt>\\><left><left>')
-- l/g/w: language
-- l: general
-- g: goto
-- w: workspace
-- c: inlay hints
vim.keymap.set('n', '<leader>le', ':Lspsaga show_line_diagnostics<cr>')
vim.keymap.set('n', '<leader>lE', ':Lspsaga show_cursor_diagnostics<cr>')
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>ld', ':Lspsaga peek_definition<cr>')
vim.keymap.set('n', '<leader>rn', ':Lspsaga rename<cr>')
vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>lo', "<cmd>LSoutlineToggle<CR>",{ silent = true })
vim.keymap.set('n', '<leader>lb', ':SymbolsOutline<cr>')
vim.keymap.set('n', '<leader>la', ':Lspsaga code_action<cr>')
vim.keymap.set('n', '<leader>lu', ':Lspsaga lsp_finder<cr>')
vim.keymap.set('n', '<F12>', ':Lspsaga code_action<cr>')
vim.keymap.set('n', '<f4>', ':SymbolsOutline<cr>')

vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '[e', ':Lspsaga diagnostic_jump_prev<cr>')
vim.keymap.set('n', ']e', ':Lspsaga diagnostic_jump_next<cr>')
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)

vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder)
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder)
vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)

-- t: terminal
-- use <f5> to toggle terminal, this can be set in lua/configs/terminal.lua
-- the default position is also set in lua/configs/terminal.lua
vim.keymap.set('t', '<C-g>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=tab<cr>')
vim.keymap.set('n', '<leader>tn', function() require('toggleterm.terminal').Terminal:new():toggle() end)
vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<cr>')
vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<cr>')
vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<cr>')

-- h: git
vim.keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<cr>')
vim.keymap.set('n', '<leader>hj', ':Gitsigns next_hunk<cr>')
vim.keymap.set('n', '<leader>hk', ':Gitsigns preview_hunk<cr>')
vim.keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<cr>')
vim.keymap.set('n', '<leader>hR', ':Gitsigns reset_buffer')
vim.keymap.set('n', '<leader>hb', ':Gitsigns blame_line<cr>')
vim.keymap.set('n', '<leader>hd', ':Gitsigns diffthis<cr>')
vim.keymap.set('n', '<leader>hs', ':<C-U>Gitsigns select_hunk<CR>')

-- indent of selection in virtual and normal mode
vim.keymap.set({'n', 'v'}, '>', '>gv')
vim.keymap.set({'n', 'v'}, '<', '<gv')

-- comments


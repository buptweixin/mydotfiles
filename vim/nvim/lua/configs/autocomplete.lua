local M = {}

function M.config()
    -- Setup nvim-cmp.
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require 'cmp'
    local lspkind = require('lspkind')
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                -- vsnip
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- Accept currently selected item...
            -- Set `select` to `false` to only confirm explicitly selected items:
            ['<cr>'] = cmp.mapping.confirm({ 
                select = true, 
                behavior = cmp.ConfirmBehavior.Replace
            }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, 
        }, { { name = 'buffer' } }),
        -- custom cmp icons using lspkind-nvim 
        formatting = {
            format = lspkind.cmp_format({
                with_text = true, -- do not show text alongside icons
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                before = function (entry, vim_item) 
                    vim_item.menu = "["..string.upper(entry.source.name).."]"
                    return vim_item
                end
            })
        },
    })
    
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    -- You can also set special config for specific filetypes:
    --    cmp.setup.filetype('gitcommit', {
    --        sources = cmp.config.sources({
    --            { name = 'cmp_git' },
    --        }, {
    --            { name = 'buffer' },
    --        })
    --    })

    -- nvim-cmp for commands
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local cmp = require("cmp")

    cmp.setup({

        mapping = {

            ["<C-j>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-k>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ['<Tab>'] = cmp.mapping(function(fallback)
                local copilot_keys = vim.fn['copilot#Accept']()
                if cmp.visible() then
                    cmp.select_next_item()
                elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then
                    vim.api.nvim_feedkeys(copilot_keys, 'i', true)
                else
                    fallback()
                end
            end, { 'i', 's', }),

            -- ... Your other mappings ...
        },

        -- ... Your other configuration ...
    })

    -- nvim-lspconfig config
    -- List of all pre-configured LSP servers:
    -- github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    require("mason").setup()
    require("mason-lspconfig").setup()
    --require 'lspconfig'.gopls.setup {}
    local servers = { 'clangd', 'pyright', 'sumneko_lua' }
    for _, lsp in pairs(servers) do
        require('lspconfig')[lsp].setup {
            on_attach = on_attach
        }
    end

    local devicons = require('nvim-web-devicons')
    cmp.register_source('devicons', {
        complete = function(_, _, callback)
            local items = {}
            for _, icon in pairs(devicons.get_icons()) do
                table.insert(items, {
                    label = icon.icon .. '  ' .. icon.name,
                    insertText = icon.icon,
                    filterText = icon.name,
                })
            end
            callback({ items = items })
        end,
    })

    vim.g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = false,
        ["c"] = true,
        ["c++"] = true,
        ["python"] = true,
    }
end

return M

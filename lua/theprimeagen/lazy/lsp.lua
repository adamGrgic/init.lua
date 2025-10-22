return {
    "neovim/nvim-lspconfig",
    version = "v1.0.0",  -- Pin to last stable version before deprecation
    dependencies = {
        "williamboman/mason.nvim",
        {
            "williamboman/mason-lspconfig.nvim",
            version = "v1.29.0",
        },
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        -- Suppress deprecation warnings for nvim-lspconfig
        vim.g.lspconfig_deprecation_warnings = false
        
        require("fidget").setup({})
        require("mason").setup()
        
        -- Setup mason-lspconfig WITHOUT automatic features to avoid errors
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
            },
        })

        -- Manually setup LSP servers to avoid mason-lspconfig automatic_enable errors
        local lspconfig = require("lspconfig")
        
        -- Setup rust_analyzer
        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            settings = {
                ['rust-analyzer'] = {
                    diagnostics = {
                        enable = true,
                    }
                }
            }
        })
        
        -- Setup lua_ls
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        })
        
        -- Setup gopls
        lspconfig.gopls.setup({
            capabilities = capabilities,
        })
        
        -- Setup zls if available
        if vim.fn.executable("zls") == 1 then
            lspconfig.zls.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                settings = {
                    zls = {
                        enable_inlay_hints = true,
                        enable_snippets = true,
                        warn_style = true,
                    },
                },
            })
            vim.g.zig_fmt_parse_errors = 0
            vim.g.zig_fmt_autosave = 0
        end

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<cr>'] = cmp.mapping.confirm({ select = true }),
                ["<C-pc>"] = cmp.mapping.complete(),
                ["<C-po>"] = cmp.mapping.confirm({ select = false }),

            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}

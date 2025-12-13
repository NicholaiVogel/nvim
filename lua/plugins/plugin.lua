return {
    -- Color scheme
    {
        "catppuccin/nvim",
         name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()
        end,
    },

    -- Formatter
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = { timeout_ms = 1000, lsp_fallback = true },
            formatters_by_ft = {
                javascript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                python = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
            },
        },
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "vim", "bash", "javascript", "python", "typescript", "tsx", "json", "yaml", "html", "css", "prisma",
                    "graphql"
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "luasnip" },
                },
            })
        end,
    },

    -- LSP
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "ts_ls", "eslint", "jsonls", "pyright", "html", "cssls", "tailwindcss" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup({
                settings = {
                    tsserver_file_preferences = {
                        includeInlayParameterNameHints = "all",
                        includeCompletionsForModuleExports = true
                    },
                },
            })
        end,
    },

    -- Colorizer
    {
        "NvChad/nvim-colorizer.lua",
        opts = { user_default_options = { names = false } }
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "catppuccin" },
            })
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                preset = "modern",
            })

            wk.add({
                { "<leader>e", desc = "Toggle file explorer" },
                { "<leader>f", group = "Find" },
                { "<leader>ff", desc = "Find files" },
                { "<leader>fg", desc = "Live grep" },
                { "<leader>fb", desc = "Find buffers" },
                { "<leader>w", desc = "Save" },
                { "<leader>q", desc = "Quit" },
            })
        end,
    },

    -- Alpha (dashboard)
    {
        "goolord/alpha-nvim",
        config = function()
            local alpha = require('alpha')
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
                [[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
                [[ /|\/|\/|\ /|\ ★ /  \_-__\☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
                [[ /|\/|\/|\ /|\ 󰻀 |[]| [] | 󰻀 /|\/|\ /|\/|\/|\ /|\/|\ ]],
            }

            dashboard.section.buttons.val = {
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "󰍉  Find file", ":lua require('fzf-lua').files() <CR>"),
                dashboard.button("t", "  Browse cwd", ":NvimTreeOpen<CR>"),
                dashboard.button("r", "  Browse src", ":e ~/.local/src/<CR>"),
                dashboard.button("s", "󰯂  Browse scripts", ":e ~/scripts/<CR>"),
                dashboard.button("c", "  Config", ":e ~/.config/nvim/<CR>"),
                dashboard.button("m", "  Mappings", ":e ~/.config/nvim/lua/core/keymaps.lua<CR>"),
                dashboard.button("p", "  Plugins", ":PlugInstall<CR>"),
                dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
            }

            dashboard.section.footer.val = function()
                return vim.g.startup_time_ms or "[[  ]]"
            end

            dashboard.section.buttons.opts.hl = "Keyword"
            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end,
    },
}

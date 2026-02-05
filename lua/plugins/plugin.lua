return {
    -- Color scheme
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        config = function()
            require('kanagawa').setup({
                compile = true,   -- enable compiling the colorscheme
                undercurl = true, -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,   -- do not set background color
                dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
                terminalColors = true, -- define vim.g.terminal_color_{0,17}
                colors = {             -- add/modify theme and palette colors
                    palette = {},
                    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors) -- add/modify highlights
                    return {}
                end,
                theme = "wave",    -- Load "wave" theme
                background = {     -- map the value of 'background' option to a theme
                    dark = "wave", -- try "dragon" !
                    light = "lotus"
                },
            })
            vim.cmd("colorscheme kanagawa")
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

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end
                    -- Navigation
                    map("n", "]c", function() gs.next_hunk() end, { desc = "Next hunk" })
                    map("n", "[c", function() gs.prev_hunk() end, { desc = "Previous hunk" })
                    -- Actions
                    map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
                    map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
                    map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage" })
                    map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
                    map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
                end,
            })
        end,
    },

    -- Diff view
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
            { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Close diff" },
        },
        config = true,
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
                    "lua", "vim", "bash", "javascript", "typescript", "tsx", "json", "yaml", "html", "css", "prisma",
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

    -- Auto-pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = {
                lua = { "string", "source" },
                javascript = { "string", "template_string" },
                typescript = { "string", "template_string" },
            },
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
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
                ensure_installed = { "ts_ls", "eslint", "jsonls", "html", "cssls", "tailwindcss" },
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
                options = { theme = "kanagawa" },
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
                { "<leader>e",  desc = "Toggle file explorer" },
                { "<leader>f",  group = "Find" },
                { "<leader>ff", desc = "Find files" },
                { "<leader>fg", desc = "Live grep" },
                { "<leader>fb", desc = "Find buffers" },
                { "<leader>g",  group = "Git" },
                { "<leader>w",  desc = "Save" },
                { "<leader>q",  desc = "Quit" },
                { "<leader>9",  group = "AI (99)" },
                { "<leader>9f", desc = "Fill Function" },
                { "<leader>9v", desc = "Visual AI" },
                { "<leader>9s", desc = "Stop requests" },
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
                [[  ██╗   ██╗███████╗    ██████╗ ███████╗███████╗██╗ ██████╗ ███╗   ██╗  ]],
                [[  ██║   ██║╚════██║    ██╔══██╗██╔════╝██╔════╝██║██╔════╝ ████╗  ██║  ]],
                [[  ██║   ██║    ██╔╝    ██║  ██║█████╗  ███████╗██║██║  ███╗██╔██╗ ██║  ]],
                [[  ╚██╗ ██╔╝   ██╔╝     ██║  ██║██╔══╝  ╚════██║██║██║   ██║██║╚██╗██║  ]],
                [[   ╚████╔╝    ██║      ██████╔╝███████╗███████║██║╚██████╔╝██║ ╚████║  ]],
                [[    ╚═══╝     ╚═╝      ╚═════╝ ╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝  ]],
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

    -- AI agent (99)
    {
        "ThePrimeagen/99",
        config = function()
            local _99 = require("99")
            local Providers = require("99.providers")
            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)

            -- custom provider with --attach flag for tool use
            local CustomOpenCodeProvider = setmetatable({}, {
                __index = Providers.OpenCodeProvider
            })
            
            function CustomOpenCodeProvider._build_command(_, query, request)
                return {
                    "opencode", "run", 
                    "--attach", "http://localhost:4096",
                    "-m", request.context.model,
                    query
                }
            end

            _99.setup({
                -- Auto-detect provider: OpenCode with server if available, else Claude Code
                provider = (function()
                    -- Check if opencode is installed
                    local opencode_installed = vim.fn.executable("opencode") == 1
                    if not opencode_installed then
                        return Providers.ClaudeCodeProvider
                    end
                    
                    -- Check if opencode serve is running on port 4096
                    local handle = io.popen("curl -s -o /dev/null -w '%{http_code}' http://localhost:4096/health 2>/dev/null || echo '000'")
                    local result = handle:read("*a")
                    handle:close()
                    
                    -- If server is responding (any 2xx or 404), use CustomOpenCodeProvider
                    if result:match("^[24]%d%d") then
                        return Providers.CustomOpenCodeProvider
                    end
                    
                    -- Fallback to Claude Code
                    return Providers.ClaudeCodeProvider
                end)(),
                model = (function()
                    -- Use appropriate model format based on provider
                    local opencode_installed = vim.fn.executable("opencode") == 1
                    if opencode_installed then
                        local handle = io.popen("curl -s -o /dev/null -w '%{http_code}' http://localhost:4096/health 2>/dev/null || echo '000'")
                        local result = handle:read("*a")
                        handle:close()
                        if result:match("^[24]%d%d") then
                            return "anthropic/claude-sonnet-4-5"
                        end
                    end
                    return "claude-sonnet-4-5"
                end)(),

                logger = {
                    level = _99.DEBUG,
                    path = "/tmp/" .. basename .. ".99.debug",
                    print_on_error = true,
                },

               completion = {
                    -- custom_rules = { "~/.config/nvim/rules/" },
                    source = "cmp",
                },

                md_files = {
                    "AGENT.md",
                    "CLAUDE.md",
                },
            })

            vim.keymap.set("n", "<leader>9f", function()
                _99.fill_in_function()
            end, { desc = "99: Fill function" })

            vim.keymap.set("v", "<leader>9v", function()
                _99.visual()
            end, { desc = "99: Visual AI" })

            vim.keymap.set("v", "<leader>9p", function()
            _99.visual_prompt()
            end, { desc = "99: Visual with prompt" })

            vim.keymap.set("v", "<leader>9s", function()
                _99.stop_all_requests()
            end, { desc = "99: Stop requests" })
        end,
    },
}

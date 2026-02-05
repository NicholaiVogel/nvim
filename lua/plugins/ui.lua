return {
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
                { "<leader>ft", desc = "Find TODOs" },
                { "<leader>g",  group = "Git" },
                { "<leader>h",  group = "Harpoon" },
                { "<leader>t",  group = "Theme" },
                { "<leader>th", desc = "Theme switcher" },
                { "<leader>x",  group = "Trouble" },
                { "<leader>w",  desc = "Save" },
                { "<leader>q",  desc = "Quit" },
                { "<leader>u",  desc = "Undo tree" },
                { "<leader>9",  group = "AI (99)" },
                { "<leader>9f", desc = "Fill Function" },
                { "<leader>9v", desc = "Visual AI" },
                { "<leader>9s", desc = "Stop requests" },
            })
        end,
    },

    -- Colorizer
    {
        "NvChad/nvim-colorizer.lua",
        opts = { user_default_options = { names = false } }
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            indent = { char = "│" },
            scope = { enabled = true },
        },
    },
}

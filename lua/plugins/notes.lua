return {
    -- Obsidian integration
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "hrsh7th/nvim-cmp",
        },
        opts = {
            workspaces = {
                {
                    name = "vault",
                    path = "/mnt/work/obsidian-vault/",
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
            mappings = {
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                ["<leader>oc"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true, desc = "Toggle checkbox" },
                },
            },
            new_notes_location = "current_dir",
            wiki_link_func = function(opts)
                return string.format("[[%s]]", opts.path)
            end,
            note_id_func = function(title)
                -- use title as-is for note IDs (no date prefix)
                if title ~= nil then
                    return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    return tostring(os.time())
                end
            end,
            ui = {
                enable = false, -- using render-markdown instead
            },
        },
        keys = {
            { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Quick switch" },
            { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: New note" },
            { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: Search" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: Backlinks" },
            { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Obsidian: Tags" },
            { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: Daily note" },
            { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = "v", desc = "Obsidian: Link selection" },
        },
    },

    -- Render markdown in buffer
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown", "Avante" },
        opts = {
            heading = {
                enabled = false,
            },
            code = {
                enabled = true,
                style = "normal",
                border = "thin",
            },
            bullet = {
                enabled = true,
                icons = { "•", "◦", "▪", "▫" },
            },
            checkbox = {
                enabled = true,
                unchecked = { icon = "☐ " },
                checked = { icon = "☑ " },
            },
            quote = { enabled = true },
            pipe_table = { enabled = true },
            link = { enabled = true },
            sign = { enabled = false },
        },
    },
}

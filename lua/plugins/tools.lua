return {
    -- Diagnostics list
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
        },
        opts = {},
    },

    -- TODO comments
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
        },
    },

    -- Undo tree
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
        },
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
}

return {
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
}

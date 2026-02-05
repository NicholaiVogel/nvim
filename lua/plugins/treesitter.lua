return {
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
}

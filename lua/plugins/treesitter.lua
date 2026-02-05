local config = require("core.config")

return {
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = config.get("treesitter.languages"),
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}

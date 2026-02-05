local config = require("core.config")

return {
    -- Mason (LSP installer)
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    -- Mason LSP config bridge
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = config.get("lsp.servers"),
            })
        end,
    },

    -- LSP config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
    },

    -- TypeScript tools
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
}

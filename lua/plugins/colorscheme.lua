local config = require("core.config")
local editor = config.editor()
local paths = config.paths()

return {
    -- Kanagawa colorscheme
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        lazy = false,
        priority = 1000,
        config = function()
            require('kanagawa').setup({
                compile = true,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                colors = {
                    palette = {},
                    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors)
                    return {}
                end,
                theme = editor.theme,
                background = {
                    dark = editor.theme,
                    light = "lotus"
                },
            })
            -- only set kanagawa if pywal colors don't exist
            if vim.fn.filereadable(vim.fn.expand("~/.cache/wal/colors")) == 0 then
                vim.cmd("colorscheme kanagawa")
            end
        end,
    },

    -- Pywal colorscheme (syncs with terminal)
    {
        "AlphaTechnolog/pywal.nvim",
        name = "pywal",
        lazy = false,
        priority = 1000,
        config = function()
            -- auto-load pywal if colors exist
            if vim.fn.filereadable(vim.fn.expand("~/.cache/wal/colors")) == 1 then
                vim.cmd("colorscheme pywal")
            end
        end,
    },

    -- Theme switcher
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            {
                "<leader>th",
                function()
                    local pickers = require("telescope.pickers")
                    local finders = require("telescope.finders")
                    local conf = require("telescope.config").values
                    local actions = require("telescope.actions")
                    local action_state = require("telescope.actions.state")

                    local themes = {
                        { name = "pywal (from wallpaper)", value = "pywal" },
                        { name = "Pick new wallpaper...", value = "_wallpaper_picker" },
                        { name = "kanagawa", value = "kanagawa" },
                        { name = "kanagawa-wave", value = "kanagawa-wave" },
                        { name = "kanagawa-dragon", value = "kanagawa-dragon" },
                        { name = "kanagawa-lotus", value = "kanagawa-lotus" },
                    }

                    pickers.new({}, {
                        prompt_title = "Theme Switcher",
                        finder = finders.new_table({
                            results = themes,
                            entry_maker = function(entry)
                                return {
                                    value = entry.value,
                                    display = entry.name,
                                    ordinal = entry.name,
                                }
                            end,
                        }),
                        sorter = conf.generic_sorter({}),
                        attach_mappings = function(prompt_bufnr, map)
                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local selection = action_state.get_selected_entry()
                                if selection.value == "_wallpaper_picker" then
                                    -- launch wallpaper picker, then reload pywal
                                    vim.fn.jobstart(
                                        { "bash", "-c", paths.wallpaperScript .. " && sleep 1" },
                                        {
                                            on_exit = function()
                                                vim.schedule(function()
                                                    vim.cmd("colorscheme pywal")
                                                    require("lualine").setup({ options = { theme = "pywal" } })
                                                    vim.notify("Pywal theme applied", vim.log.levels.INFO)
                                                end)
                                            end,
                                        }
                                    )
                                else
                                    vim.cmd("colorscheme " .. selection.value)
                                    -- update lualine theme
                                    local lualine_theme = selection.value:match("^kanagawa") and "kanagawa" or selection.value
                                    require("lualine").setup({ options = { theme = lualine_theme } })
                                    vim.notify("Theme: " .. selection.value, vim.log.levels.INFO)
                                end
                            end)
                            return true
                        end,
                    }):find()
                end,
                desc = "Theme switcher",
            },
        },
    },
}

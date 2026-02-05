-- Config loader module
-- Loads user configuration from config.json with defaults and validation

local M = {}

-- Default configuration values
M.defaults = {
    paths = {
        obsidianVault = "~/Documents/obsidian-vault/",
        srcDirectory = "~/.local/src/",
        scriptsDirectory = "~/scripts/",
        wallpaperScript = "~/scripts/pywal/wallpapermenu.sh",
    },
    editor = {
        tabSize = 4,
        scrollOffset = 8,
        theme = "wave",
    },
    ai = {
        model = "claude-sonnet-4-5",
        openCodeModel = "anthropic/claude-sonnet-4-5",
    },
    lsp = {
        servers = { "ts_ls", "eslint", "jsonls", "html", "cssls", "tailwindcss" },
    },
    treesitter = {
        languages = { "lua", "vim", "bash", "javascript", "typescript", "tsx", "json", "yaml", "html", "css" },
    },
}

-- Cache for loaded config
local config_cache = nil

-- Deep merge two tables (b overrides a)
local function deep_merge(a, b)
    local result = vim.deepcopy(a)
    for k, v in pairs(b) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = deep_merge(result[k], v)
        else
            result[k] = v
        end
    end
    return result
end

-- Expand ~ to home directory in paths
local function expand_path(path)
    if type(path) ~= "string" then
        return path
    end
    return path:gsub("^~", vim.fn.expand("$HOME"))
end

-- Recursively expand paths in a table
local function expand_paths(tbl)
    -- Check if this is an array (sequential numeric keys)
    if #tbl > 0 then
        local result = {}
        for i, v in ipairs(tbl) do
            result[i] = v
        end
        return result
    end

    local result = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            result[k] = expand_paths(v)
        elseif type(v) == "string" and type(k) == "string" and (k:lower():match("path") or k:lower():match("vault") or k:lower():match("directory") or k:lower():match("script")) then
            result[k] = expand_path(v)
        else
            result[k] = v
        end
    end
    return result
end

-- Load configuration from config.json
function M.load()
    if config_cache then
        return config_cache
    end

    local config_path = vim.fn.stdpath("config") .. "/config.json"
    local user_config = {}

    -- Check if config file exists
    if vim.fn.filereadable(config_path) == 1 then
        local file = io.open(config_path, "r")
        if file then
            local content = file:read("*a")
            file:close()

            -- Try to parse JSON
            local ok, parsed = pcall(vim.json.decode, content)
            if ok and type(parsed) == "table" then
                user_config = parsed
            else
                vim.notify("config.json: Parse error, using defaults", vim.log.levels.WARN)
            end
        end
    end

    -- Merge defaults with user config
    local merged = deep_merge(M.defaults, user_config)

    -- Expand paths
    config_cache = expand_paths(merged)

    return config_cache
end

-- Get a config value by dot-notation path (e.g., "paths.obsidianVault")
function M.get(path)
    local config = M.load()
    local keys = vim.split(path, ".", { plain = true })
    local value = config

    for _, key in ipairs(keys) do
        if type(value) ~= "table" then
            return nil
        end
        value = value[key]
    end

    return value
end

-- Convenience getters for common sections
function M.paths()
    return M.load().paths
end

function M.editor()
    return M.load().editor
end

function M.ai()
    return M.load().ai
end

function M.lsp()
    return M.load().lsp
end

function M.treesitter()
    return M.load().treesitter
end

-- Reset cache (useful for testing or config reload)
function M.reset()
    config_cache = nil
end

return M

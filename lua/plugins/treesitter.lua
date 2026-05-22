local config = require("core.config")

local function first_capture(capture)
    if type(capture) == "table" then
        return capture[1]
    end
    return capture
end

local function register_treesitter_compat_predicates()
    -- nvim-treesitter's legacy predicate handlers still assume captures are
    -- single TSNode values. Neovim 0.12 passes captures as TSNode arrays, which
    -- makes markdown injection parsing blow up in render-markdown.nvim with:
    --   vim.treesitter.get_range: attempt to call method 'range'
    --
    -- Re-register the nvim-treesitter compatibility predicates/directives with
    -- the same behavior, but unwrap the first node from Neovim 0.12 captures.
    local query = vim.treesitter.query
    local opts = { force = true, all = false }
    local unpack = table.unpack or unpack

    local html_script_type_languages = {
        ["importmap"] = "json",
        ["module"] = "javascript",
        ["application/ecmascript"] = "javascript",
        ["text/ecmascript"] = "javascript",
    }

    local non_filetype_match_injection_language_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        uxn = "uxntal",
        ts = "typescript",
    }

    local function get_parser_from_markdown_info_string(injection_alias)
        local match = vim.filetype.match({ filename = "a." .. injection_alias })
        return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
    end

    query.add_predicate("nth?", function(match, _, _, pred)
        local node = first_capture(match[pred[2]])
        local n = tonumber(pred[3])
        if node and node:parent() and node:parent():named_child_count() > n then
            return node:parent():named_child(n) == node
        end
        return false
    end, opts)

    query.add_predicate("is?", function(match, _, bufnr, pred)
        local locals = require("nvim-treesitter.locals")
        local node = first_capture(match[pred[2]])
        local types = { unpack(pred, 3) }
        if not node then
            return true
        end
        local _, _, kind = locals.find_definition(node, bufnr)
        return vim.tbl_contains(types, kind)
    end, opts)

    query.add_predicate("kind-eq?", function(match, _, _, pred)
        local node = first_capture(match[pred[2]])
        local types = { unpack(pred, 3) }
        if not node then
            return true
        end
        return vim.tbl_contains(types, node:type())
    end, opts)

    query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
        local node = first_capture(match[pred[2]])
        if not node then
            return
        end
        local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
        metadata["injection.language"] = html_script_type_languages[type_attr_value]
            or vim.split(type_attr_value, "/", {})[#vim.split(type_attr_value, "/", {})]
    end, opts)

    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local node = first_capture(match[pred[2]])
        if not node then
            return
        end
        local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
    end, opts)

    query.add_directive("make-range!", function() end, opts)

    query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = first_capture(match[id])
        if not node then
            return
        end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
        metadata[id] = metadata[id] or {}
        metadata[id].text = string.lower(text)
    end, opts)
end

return {
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            register_treesitter_compat_predicates()
            require("nvim-treesitter.configs").setup({
                ensure_installed = config.get("treesitter.languages"),
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}

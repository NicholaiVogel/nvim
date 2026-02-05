return {
    -- AI agent (99)
    {
        "ThePrimeagen/99",
        config = function()
            local _99 = require("99")
            local Providers = require("99.providers")
            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)

            -- custom provider with --attach flag for tool use
            local CustomOpenCodeProvider = setmetatable({}, {
                __index = Providers.OpenCodeProvider
            })

            function CustomOpenCodeProvider._build_command(_, query, request)
                return {
                    "opencode", "run",
                    "--attach", "http://localhost:4096",
                    "-m", request.context.model,
                    query
                }
            end

            _99.setup({
                -- Auto-detect provider: OpenCode with server if available, else Claude Code
                provider = (function()
                    -- Check if opencode is installed
                    local opencode_installed = vim.fn.executable("opencode") == 1
                    if not opencode_installed then
                        return Providers.ClaudeCodeProvider
                    end

                    -- Check if opencode serve is running on port 4096
                    local handle = io.popen("curl -s -o /dev/null -w '%{http_code}' http://localhost:4096/health 2>/dev/null || echo '000'")
                    local result = handle:read("*a")
                    handle:close()

                    -- If server is responding (any 2xx or 404), use CustomOpenCodeProvider
                    if result:match("^[24]%d%d") then
                        return Providers.CustomOpenCodeProvider
                    end

                    -- Fallback to Claude Code
                    return Providers.ClaudeCodeProvider
                end)(),
                model = (function()
                    -- Use appropriate model format based on provider
                    local opencode_installed = vim.fn.executable("opencode") == 1
                    if opencode_installed then
                        local handle = io.popen("curl -s -o /dev/null -w '%{http_code}' http://localhost:4096/health 2>/dev/null || echo '000'")
                        local result = handle:read("*a")
                        handle:close()
                        if result:match("^[24]%d%d") then
                            return "anthropic/claude-sonnet-4-5"
                        end
                    end
                    return "claude-sonnet-4-5"
                end)(),

                logger = {
                    level = _99.DEBUG,
                    path = "/tmp/" .. basename .. ".99.debug",
                    print_on_error = true,
                },

               completion = {
                    -- custom_rules = { "~/.config/nvim/rules/" },
                    source = "cmp",
                },

                md_files = {
                    "AGENT.md",
                    "CLAUDE.md",
                },
            })

            vim.keymap.set("n", "<leader>9f", function()
                _99.fill_in_function()
            end, { desc = "99: Fill function" })

            vim.keymap.set("v", "<leader>9v", function()
                _99.visual()
            end, { desc = "99: Visual AI" })

            vim.keymap.set("v", "<leader>9p", function()
            _99.visual_prompt()
            end, { desc = "99: Visual with prompt" })

            vim.keymap.set("v", "<leader>9s", function()
                _99.stop_all_requests()
            end, { desc = "99: Stop requests" })
        end,
    },
}

local config = require("core.config")
local ai = config.ai()

local acpx_model = ai.openCodeModel or ai.model or "zai-coding-plan/glm-5.1"

local function ensure_acpx_opencode_config()
	local root = vim.fn.stdpath("cache") .. "/99-acpx-opencode"
	local opencode_dir = root .. "/opencode"

	vim.fn.mkdir(opencode_dir, "p")
	vim.fn.writefile({
		vim.json.encode({
			["$schema"] = "https://opencode.ai/config.json",
			enabled_providers = { "zai-coding-plan" },
			model = acpx_model,
		}),
	}, opencode_dir .. "/opencode.json")

	return root
end

return {
	-- AI agent (99 via ACPX + OpenCode)
	{
		dir = "/mnt/work/dev/99-acpx",
		name = "99",
		lazy = false,
		config = function()
			local _99 = require("99")
			local Providers = require("99.providers")
			local cwd = vim.uv.cwd()
			local basename = vim.fs.basename(cwd)
			local opencode_config_home = ensure_acpx_opencode_config()

			_99.setup({
				provider = Providers.ACPXProvider,
				model = acpx_model,

				acpx = {
					command = { "npx", "-y", "acpx@0.7.0" },
					agent = "opencode",
					model = acpx_model,
					permissions = "approve-all",
					timeout = 120,
					cwd = cwd,
					env = {
						XDG_CONFIG_HOME = opencode_config_home,
					},
					signet = {
						bypass = true,
						hooks = false,
						memory = false,
						identity = false,
					},
				},

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
					"AGENTS.md",
					"CLAUDE.md",
				},
			})

			vim.keymap.set("n", "<leader>9s", function()
				_99.search()
			end, { desc = "99: Search" })

			vim.keymap.set("n", "<leader>9f", function()
				_99.search()
			end, { desc = "99: Search" })

			vim.keymap.set("n", "<leader>9v", function()
				_99.vibe()
			end, { desc = "99: Vibe" })

			vim.keymap.set("v", "<leader>9v", function()
				_99.visual()
			end, { desc = "99: Visual AI" })

			vim.keymap.set("v", "<leader>9p", function()
				_99.visual()
			end, { desc = "99: Visual AI" })

			vim.keymap.set("n", "<leader>9o", function()
				_99.open()
			end, { desc = "99: Open previous request" })

			vim.keymap.set("n", "<leader>9l", function()
				_99.view_logs()
			end, { desc = "99: View logs" })

			vim.keymap.set("n", "<leader>9x", function()
				_99.stop_all_requests()
			end, { desc = "99: Stop requests" })
		end,
	},
}

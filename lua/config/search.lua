local function setBG(group, bg_color)
	local current_hl = vim.api.nvim_get_hl_by_name(group, true)
	local fg_color = current_hl.foreground or "NONE"
	vim.api.nvim_set_hl(0, group, { fg = fg_color, bg = bg_color })
end

function telescope_setup()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					width = 0.9,
					height = 0.8,
					preview_cutoff = 0,
					preview_width = 0.6,
				},
			},
			file_ignore_patterns = {
				".git/",
				"%.o",
				"%.out",
				"%.dSYM/",
				"__pycache__",
				"build",
				"venv",
				".venv",
				"env",
				".env",
			},
		},
	})

	setBG("TelescopeSelection", "#3a3d45")
	vim.keymap.set("n", ";f", ":Telescope git_branches<CR>", { silent = true })

	local builtin = require("telescope.builtin")
	local utils = require("telescope.utils")

	vim.keymap.set("n", ";l", builtin.find_files)

	vim.keymap.set("n", ";g", builtin.live_grep)

	-------------------------------------------------------------- trouble / todo

	vim.keymap.set("n", ";c", function()
		builtin.diagnostics({ severity_limit = vim.diagnostic.severity.ERROR })
	end)

	require("trouble").setup({
		win = {
			size = 5,
		},
		filter = {
			severity = {
				min = vim.diagnostic.severity.ERROR,
				max = vim.diagnostic.severity.ERROR,
			},
		},
		update_in_insert = true,
	})

	require("todo-comments").setup({
		signs = false,
	})

	vim.keymap.set("n", "]t", function()
		require("todo-comments").jump_next()
	end, { desc = "Next todo comment" })

	vim.keymap.set("n", "[t", function()
		require("todo-comments").jump_prev()
	end, { desc = "Previous todo comment" })

	vim.keymap.set("n", ";t", "<CMD>TodoTelescope<CR>")
end

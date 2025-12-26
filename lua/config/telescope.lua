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

	vim.keymap.set("n", ";f", ":Telescope git_branches<CR>", { silent = true })

	local builtin = require("telescope.builtin")
	local utils = require("telescope.utils")

	vim.keymap.set("n", ";l", builtin.find_files)

	vim.keymap.set("n", ";g", builtin.live_grep)
end

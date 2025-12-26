-- require("octo").setup({})
-- vim.keymap.set(";w", ":Octo", "")

function git_setup()
	local function gitsign_maps(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", ";a", gitsigns.stage_hunk)
		map("n", ";w", gitsigns.reset_hunk)

		map("v", ";a", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("v", ";w", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", ";A", gitsigns.stage_buffer)
		map("n", ";W", gitsigns.reset_buffer)
		-- map("n", "<leader>hp", gitsigns.preview_hunk)
		-- map("n", "<leader>hi", gitsigns.preview_hunk_inline)

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end)

		map("n", ";d", function()
			-- toggle diff
			if vim.wo.diff then
				vim.cmd("wincmd h")
				vim.cmd("close")
			else
				gitsigns.diffthis()
			end
		end)

		map("n", ";D", function()
			gitsigns.diffthis("~")
		end)

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end)
		map("n", "<leader>hq", gitsigns.setqflist)

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
		map("n", "<leader>tw", gitsigns.toggle_word_diff)

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk)
	end

	require("gitsigns").setup({
		current_line_blame = true,
		on_attach = gitsign_maps,
	})

	local actions = require("diffview.actions")
	require("diffview").setup({
		view = {
			default = {
				layout = "diff2_horizontal",
				winbar_info = true,
			},
			merge_tool = {
				layout = "diff3_mixed",
				winbar_info = true,
			},
			file_history = {
				winbar_info = true,
			},
		},
		file_panel = {
			listing_style = "list",
			win_config = {
				position = "left",
				width = 25,
				win_opts = {},
			},
		},
		file_history_panel = {
			win_config = {
				position = "bottom",
				height = 12,
				win_opts = {},
			},
		},
		keymaps = {
			view = {
				{
					"n",
					";1",
					actions.conflict_choose("ours"),
				},
				{
					"n",
					";2",
					actions.conflict_choose("theirs"),
				},
				{
					"n",
					";3",
					actions.conflict_choose("all"),
				},
				{ "n", ";4", actions.conflict_choose("none") },
			},
			file_history_panel = {
				{
					"n",
					"f",
					actions.select_entry,
				},
				{ "n", "L", false },
				{ "n", "l", actions.open_commit_log },
			},
			file_panel = {
				{
					"n",
					"f",
					actions.select_entry,
				},
				{ "n", "L", false },
				{ "n", "l", actions.open_commit_log },
			},
		},
	})

	-- restart session
	function reset()
		vim.api.nvim_command("%bd|e#")
		vim.api.nvim_command("LspRestart")
	end

	vim.opt.diffopt:append("vertical")

	vim.keymap.set("n", ";q", "<CMD>q<CR>")
	-- vim.keymap.set("n", "+", ":Gread<CR>")

	vim.keymap.set("n", ";x", reset)

	function exists_file_type(filetype)
		local exists = false

		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			-- loaded and visible
			if vim.api.nvim_buf_is_loaded(buf) then
				local type = vim.bo[buf].filetype
				local res = type == filetype
				if type == filetype then
					exists = true
					break
				end
			end
		end
		return exists
	end

	-- TODO:
	-- overload this will all exiting binds run
	vim.keymap.set("n", "<leader>q", ":DiffviewClose<CR>", { silent = true })

	-- toggle open
	vim.keymap.set("n", "<leader>d", function()
		if exists_file_type("DiffviewFileHistory") then
			vim.cmd("DiffviewClose")
		end

		if exists_file_type("DiffviewFiles") then
			vim.cmd("DiffviewClose")
		else
			vim.cmd("DiffviewOpen")
		end
	end, { noremap = true, silent = true })

	vim.keymap.set("n", "<leader>f", function()
		if exists_file_type("DiffviewFiles") then
			vim.cmd("DiffviewClose")
		end

		if exists_file_type("DiffviewFileHistory") then
			vim.cmd("DiffviewClose")
		else
			vim.cmd("DiffviewFileHistory %")
		end
	end, { noremap = true, silent = true })

	local neogit = require("neogit")
	neogit.setup({
		mappings = {
			status = {
				["K"] = false,
				["f"] = "Toggle",
				["h"] = "Untrack",
				["L"] = false,
			},
			popup = {
				["f"] = false,
			},
		},
	})

	vim.keymap.set("n", ";s", function()
		neogit.open({ kind = "replace" })
	end)
end

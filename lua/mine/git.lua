-- require("octo").setup({})
-- vim.keymap.set(";w", ":Octo", "")

require("gitsigns").setup({
	current_line_blame = true,
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

-- toggle open
vim.keymap.set("n", ";d", function()
	if exists_file_type("DiffviewFileHistory") then
		vim.cmd("DiffviewClose")
	end

	if exists_file_type("DiffviewFiles") then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { noremap = true, silent = true })

vim.keymap.set("n", ";a", function()
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
	},
})

vim.keymap.set("n", ";s", function()
	neogit.open({ kind = "replace" })
end)

-- vim.keymap.set("n", ";s", function()
-- 	vim.api.nvim_command("Git")
-- 	reset()
-- end)

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "fugitiveblame", "fugitive", "git" },
-- 	callback = function()
-- 		vim.keymap.set("n", "J", "5j", { buffer = true })
-- 		vim.keymap.set("n", "K", "5k", { buffer = true })
-- 	end,
-- })

-- vim.keymap.set("n", ";d", ":%bd|e#<CR>")

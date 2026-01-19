----------------------------------- state -----------------------------------

local M = {}
M.buf = nil
M.keys = "qwerasdfzxcv"

---------------------------------- helpers ----------------------------------
local function valid_buf()
	return M.buf and vim.api.nvim_buf_is_valid(M.buf)
end

local function get_buf()
	if not valid_buf() then
		M.buf = vim.api.nvim_create_buf(false, true)
	end

	-- create if not valid
	return M.buf
end

local function short(name, max_len)
	return name:sub(0, math.min(#name, max_len))
end

local function center_pad(name, len)
	-- round down
	local diff = len - #name
	local side = math.floor(diff / 2)
	local rem = diff % 2

	local left = string.rep(" ", side)
	local right = string.rep(" ", side + rem)

	return left .. name .. right
end

local function update_preview()
	-- don't update
	if not valid_buf() then
		return
	end
	local buf = M.buf

	local harpoon = require("harpoon")
	local keys = M.keys

	local length = 19
	assert(length % 2 ~= 0)

	-- [l, r], comman separated get
	local function create_line(l, r)
		-- slow but ok
		local delim = " | "
		local res = ""
		for i = l, r do
			local item = harpoon:list():get(i)

			local entry
			if item == nil then
				local side = string.rep("_", (length - 1) / 2)
				entry = side .. keys:sub(i, i) .. side
			else
				-- harpoon api
				local path = item.value

				-- get just filename
				path = vim.fn.fnamemodify(path, ":t")

				-- fit to size
				path = center_pad(short(path, length), length)

				entry = path
			end

			res = res .. entry .. delim
		end
		-- ignore final line
		return res:sub(0, #res - #delim)
	end

	local tests = create_line(1, 4)
	local srcs = create_line(5, 8)
	local miscs = create_line(9, 12)

	local lines = { tests, srcs, miscs }

	-- modify
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
end

----------------------------------- setup -----------------------------------
local function navigation_setup()
	local harpoon = require("harpoon")
	vim.keymap.set("n", ";e", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)

	local keys = M.keys

	local function set_mark(idx)
		local path = vim.fn.expand("%:p")

		local target = "/home/"
		local prefix = string.sub(path, 1, #target)
		if path == nil or prefix ~= target then
			vim.notify("Harpoon: no file to mark", vim.log.levels.WARN)
			return
		end

		-- set path
		harpoon:list():replace_at(idx, { value = path })
	end

	local function go_mark(idx)
		local item = harpoon:list():get(idx)
		if item == nil then
			vim.notify("Harpoon: mark not set", vim.log.levels.WARN)
			return
		end

		harpoon:list():select(idx)
	end

	for idx = 1, #keys do
		local letter = string.sub(keys, idx, idx)
		vim.keymap.set("n", "m" .. letter, function()
			set_mark(idx)
			update_preview()
		end)
		vim.keymap.set("n", "'" .. letter, function()
			go_mark(idx)
		end)
	end
end

local function preview_setup()
	vim.keymap.set("n", "<leader>e", function()
		local buf = get_buf()
		update_preview()
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(win, buf)
	end)
end
---------------------------------- config ----------------------------------
function harpoon_setup()
	local harpoon = require("harpoon")
	harpoon:setup()

	navigation_setup()
	preview_setup()
end

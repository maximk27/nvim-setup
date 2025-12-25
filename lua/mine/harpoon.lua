local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

local function set_mark(idx)
	local path = vim.fn.expand("%:p")

	local target = "/home/"
	local prefix = string.sub(path, 1, #target)
	if path == nil or prefix ~= target then
		vim.notify("Harpoon: no file to mark", vim.log.levels.WARN)
		return
	end

	-- no need to grow to proper size

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

-- asdf source files
-- qwe test
-- r readme

-- setup mappings for A,S,D,F mapped to 1,2,3,4
for idx, letter in ipairs({ "a", "s", "d", "f", "q", "w", "e", "r" }) do
	vim.keymap.set("n", "m" .. letter, function()
		set_mark(idx)
	end)
	vim.keymap.set("n", "'" .. letter, function()
		go_mark(idx)
	end)
end

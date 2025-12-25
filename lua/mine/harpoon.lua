local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

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

-- asdf source files
-- r readme
-- t test

-- setup mappings for A,S,D,F mapped to 1,2,3,4
for idx, letter in ipairs({ "A", "S", "D", "F", "R", "T" }) do
	vim.keymap.set("n", "m" .. letter, function()
		set_mark(idx)
	end)
	vim.keymap.set("n", "'" .. letter, function()
		harpoon:list():select(idx)
	end)
end

function harpoon_setup()
	local harpoon = require("harpoon")

	-- REQUIRED
	harpoon:setup()
	-- REQUIRED
	vim.keymap.set("n", ";e", function()
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

	-- setup mappings for each key
	local keys = "asdfqwer"
	for idx = 1, #keys do
		local letter = string.sub(keys, idx, idx)
		vim.keymap.set("n", "m" .. letter, function()
			set_mark(idx)
		end)
		vim.keymap.set("n", "'" .. letter, function()
			go_mark(idx)
		end)
	end
end

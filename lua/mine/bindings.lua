vim.keymap.set("v", "gj", function()
	vim.cmd([[execute "normal! \<ESC>"]])
	local top = vim.fn.getpos("'<")[2]
	local bottom = vim.fn.getpos("'>")[2]
	vim.fn.append(top - 1, "\t// clang-format off")
	vim.fn.append(bottom + 1, "\t// clang-format on")
end)

-- toggle line nums
vim.keymap.set("n", "<leader>l", function()
	vim.o.number = not vim.o.number
end)

-- create a long line of -- title --

-- returns the length
function make_title(title, width)
	-- round down
	local side_length = math.floor((width - #title) / 2)
	local side = string.rep("-", side_length)
	local res = "// " .. side .. " " .. title .. " " .. side
	print(res)
	return res
end

vim.keymap.set("n", "<leader>-", function()
	local ok, title = pcall(vim.fn.input, "Title: ")
	if not ok then
		return
	end

	local text = make_title(title, 75)
	-- put the text at curr line
	vim.api.nvim_set_current_line(text)
end)

-- copy curr work dir
vim.keymap.set("n", "<leader>w", function()
	local path = vim.fn.expand("%:p:h")

	-- just to make it work with oil virtual paths
	local bad_prefix = "oil://"
	if string.sub(path, 0, #bad_prefix) == bad_prefix then
		path = string.sub(path, #bad_prefix + 1)
	end
	vim.fn.setreg("+", path)
	vim.notify("copied dir")
end)

-- stupid
vim.keymap.set("n", "<C-Space>", "<NOP>")
vim.keymap.set("i", "<C-c>", "<ESC>", { noremap = true, silent = true })

-- stop pinky hurt
vim.keymap.set("n", ";w", ":w")
vim.keymap.set("n", ";q", ":q")

-- v and V for pinkky lol
vim.keymap.set("n", "v", "V", { noremap = true })
vim.keymap.set("n", "V", "v", { noremap = true })

-- reset
vim.keymap.set("n", "_", ":e!<CR>", { noremap = true, silent = true })

-- indent
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })

vim.keymap.set("n", "<M-k>", "5k", { noremap = true, silent = true })
vim.keymap.set("n", "<M-j>", "5j", { noremap = true, silent = true })
vim.keymap.set("v", "<M-k>", "5k", { noremap = true, silent = true })
vim.keymap.set("v", "<M-j>", "5j", { noremap = true, silent = true })

vim.keymap.set("n", "<C-e>", "<End>", { noremap = true, silent = true })
vim.keymap.set("v", "<C-e>", "<End>", { noremap = true, silent = true })

--insert edit
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-n>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-p>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<C-o>I", { noremap = true, silent = true })
vim.keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-b>", "<S-Left>")
vim.keymap.set("i", "<A-f>", "<S-Right>")
vim.keymap.set("i", "<C-d>", "<delete>")
vim.keymap.set("i", "<A-BS>", "<C-w>", { noremap = true, silent = true })

-- command edit
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-n>", "<Down>")
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("c", "<C-a>", "<C-o>I")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<A-BS>", "<C-w>")

vim.keymap.set("c", "<A-b>", "<S-Left>")
vim.keymap.set("c", "<A-f>", "<S-Right>")
vim.keymap.set("c", "<C-d>", "<Delete>")
vim.keymap.set("c", "<A-BS>", "<C-w>", { noremap = true, silent = true })

-- pasting non overwrite
vim.keymap.set({ "n", "v" }, "<M-p>", '"_dP', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<M-c>", '"_c', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<M-d>", '"_d', { noremap = true, silent = true })

vim.keymap.set("n", "<M-C>", '"_C', { noremap = true, silent = true })
vim.keymap.set("n", "<M-D>", '"_D', { noremap = true, silent = true })

-- scrolling
vim.keymap.set("n", "<C-u>", "10<C-y>")
vim.keymap.set("n", "<C-d>", "10<C-e>")

-- window
vim.keymap.set("n", "<M-K>", ":resize +5<CR>")
vim.keymap.set("n", "<M-J>", ":resize -5<CR>")
vim.keymap.set("n", "<M-L>", ":vertical resize +5<CR>")
vim.keymap.set("n", "<M-H>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<M-)>", "<C-w>=")

vim.keymap.set("n", "<M-h>", "<C-w>h")
vim.keymap.set("n", "<M-l>", "<C-w>l")

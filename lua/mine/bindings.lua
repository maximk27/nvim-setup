vim.keymap.set("v", "gj", function()
	vim.cmd([[execute "normal! \<ESC>"]])
	local top = vim.fn.getpos("'<")[2]
	local bottom = vim.fn.getpos("'>")[2]
	vim.fn.append(top - 1, "\t// clang-format off")
	vim.fn.append(bottom + 1, "\t// clang-format on")
end)

-- stupid
vim.keymap.set("n", "<C-Space>", "<NOP>")
vim.keymap.set("i", "<C-c>", "<ESC>", { noremap = true, silent = true })

-- reset
vim.keymap.set("n", "_", ":e!<CR>", { noremap = true, silent = true })

-- indent
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })

-- vertical movement
vim.keymap.set("n", "K", "5k", { noremap = true, silent = true })
vim.keymap.set("n", "J", "5j", { noremap = true, silent = true })
vim.keymap.set("v", "K", "5k", { noremap = true, silent = true })
vim.keymap.set("v", "J", "5j", { noremap = true, silent = true })

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
vim.keymap.set("v", "P", '"_dP', { noremap = true, silent = true })
vim.keymap.set("v", "C", '"_c', { noremap = true, silent = true })
vim.keymap.set("v", "D", '"_d', { noremap = true, silent = true })

-- scrolling
vim.keymap.set("n", "<C-u>", "10<C-y>")
vim.keymap.set("n", "<C-d>", "10<C-e>")

-- window
vim.keymap.set("n", "<M-J>", ":resize -5<CR>")
vim.keymap.set("n", "<M-K>", ":resize +5<CR>")
vim.keymap.set("n", "<M-H>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<M-L>", ":vertical resize +5<CR>")

vim.keymap.set("n", "<M-j>", "<C-w>j")
vim.keymap.set("n", "<M-k>", "<C-w>k")
vim.keymap.set("n", "H", "<C-w>h")
vim.keymap.set("n", "L", "<C-w>l")

-- work on this

-- vim.keymap.set("n", "<C-w>l", "<C-w>l:vertical resize 100<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-w>h", "<C-w>h:vertical resize 100<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-w>k", "<C-w>k:horizontal resize 25<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-w>j", "<C-w>j:horizontal resize 25<CR>", { noremap = true, silent = true })

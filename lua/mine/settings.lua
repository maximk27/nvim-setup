-- must have options
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.clipboard = "unnamedplus"
vim.o.number = false
vim.o.scrolloff = 8
vim.o.guifont = "Input Mono 13"
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.undofile = true
vim.o.wrap = false
vim.o.ignorecase = true
-- vim.g.python3_host_prog = "/Users/maximkim/.config/nvim/env/bin/python3"
vim.o.numberwidth = 4
vim.o.winheight = 10
vim.o.signcolumn = "yes:2"
vim.o.showtabline = 0

vim.o.list = false
vim.o.listchars = "tab:> ,trail:·,nbsp:+"
vim.opt.fillchars = { eob = " " }

vim.o.cursorline = true

-- vim.lsp.set_log_level("off")

-- cursor
vim.o.guicursor = "n-c-i-ve-ci-v:block,r-cr-o:hor20"
-- vim.o.guicursor = "n-c-i-ve-ci-v:blinkon10"

-- indent
-- Default to 4 spaces per tab
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

-- windows
vim.o.splitbelow = true
vim.o.splitright = true

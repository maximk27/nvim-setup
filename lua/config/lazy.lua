-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- themes
		{ "catppuccin/nvim", name = "catppuccin" },
		{ "sainnhe/sonokai" },
		{ "navarasu/onedark.nvim" },
		{ "jacoborus/tender.vim" },
		{ "tanvirtin/monokai.nvim" },
		{ "morhetz/gruvbox" },
		{ "neanias/everforest-nvim" },
		{ "ishan9299/nvim-solarized-lua" },
		-- { "projekt0n/github-nvim-theme" },
		{ "Mofiqul/vscode.nvim" },
		-- { "folke/tokyonight.nvim" },
		{ "rose-pine/neovim", name = "rose-pine" },

		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		-- persistence
		{
			"folke/persistence.nvim",
		},

		-- notification
		{
			"rcarriga/nvim-notify",
		},

		-- gamify
		{
			"gisketch/triforce.nvim",
			dependencies = { "nvzone/volt" },
		},

		{ "junegunn/vim-easy-align" },

		{ "stevearc/oil.nvim" },

		-- debugger
		-- { "jay-babu/mason-nvim-dap.nvim" },
		{ "mfussenegger/nvim-dap" },
		{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
		-- { "neogen", config = true },
		-- find and replace
		{
			"nvim-pack/nvim-spectre",
		},

		-- install without yarn or npm
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
				vim.g.mkdp_auto_close = 0
				vim.g.mkdp_refresh_slow = 1
			end,
			ft = { "markdown" },
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},

		{
			"Wansmer/treesj",
			dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		},

		-- peak lines
		{
			"nacro90/numb.nvim",

			config = function()
				require("numb").setup()
			end,
		},

		-- lsp manager
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },

		-- base lsp
		{ "neovim/nvim-lspconfig" },

		-- completion and suggestions
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/nvim-cmp" },
		{ "saadparwaiz1/cmp_luasnip" },
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
		},
		{
			"ray-x/lsp_signature.nvim",
			event = "InsertEnter",
		},
		-- { "luckasRanarison/tailwind-tools.nvim", lazy = true },
		{ "brenoprata10/nvim-highlight-colors", lazy = true },

		-- formatter
		{ "stevearc/conform.nvim", opts = {} },

		-- tree-siter
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-treesitter/nvim-treesitter-context" },

		-- comment
		{ "numToStr/Comment.nvim", opts = {} },

		-- fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = {
				"BurntSushi/ripgrep",
				"nvim-lua/plenary.nvim",
			},
		},

		-- diagnostcs finder
		{ "folke/trouble.nvim" },

		-- todo comments
		{
			"folke/todo-comments.nvim",
			opts = {
				signs = false,
				keywords = {
					FIX = {
						icon = " ", -- icon used for the sign, and in search results
						color = "error", -- can be a hex color, or a named color (see below)
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
						-- signs = false, -- configure signs for some keywords individually
					},
					TODO = { icon = " ", color = "test" },
					HACK = { icon = " ", color = "warning" },
					WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
					PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
					TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				},
			},
		},

		-- icons
		{ "nvim-tree/nvim-web-devicons" },

		--auto pairs
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		{ "windwp/nvim-ts-autotag", lazy = true },

		-- surround editing
		{ "kylechui/nvim-surround" },

		-- status line
		{ "nvim-lualine/lualine.nvim" },

		-- cpp
		{
			"xeluxee/competitest.nvim",
			dependencies = "MunifTanjim/nui.nvim",
			lazy = true,
		},

		-- leetcode
		{
			"kawre/leetcode.nvim",
			dependencies = {
				"nvim-telescope/telescope.nvim",
				-- "ibhagwan/fzf-lua",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
			opts = {
				-- image_support = true,
				lang = "python3",
				injector = {
					python3 = {
						before = {},
					},
					cpp = {
						before = {},
					},
					java = {
						before = "import java.util.*;",
					},
				},
				storage = {
					home = "~/cpp/leetcode",
					cache = vim.fn.stdpath("cache") .. "/leetcode",
				},
			},
		},

		-- git
		{
			"NeogitOrg/neogit",
			lazy = true,
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"sindrets/diffview.nvim", -- optional - Diff integration

				-- Only one of these is needed.
				"nvim-telescope/telescope.nvim", -- optional
			},
			cmd = "Neogit",
		},
		{ "sindrets/diffview.nvim" },
		-- { "pwntester/octo.nvim" },
		{ "lewis6991/gitsigns.nvim", lazy = true },
		{ "tpope/vim-fugitive" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})

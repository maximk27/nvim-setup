require("config.misc")
require("config.harpoon")
require("config.git")
require("config.telescope")

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
		{ "widatama/vim-phoenix" },

		-- utilities
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			event = "VeryLazy",
			config = harpoon_setup,
		},
		{ "folke/persistence.nvim", event = "BufReadPost", config = persistence_setup },
		{ "rcarriga/nvim-notify", event = "VeryLazy", config = notify_setup },

		{
			"gisketch/triforce.nvim",
			dependencies = { "nvzone/volt" },
			event = "VeryLazy",
			config = tritforce_setup,
		},
		{ "stevearc/oil.nvim", config = oil_setup },

		-- debugger
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			event = "VeryLazy",
			config = debug_setup,
		},

		-- find and replace
		{ "nvim-pack/nvim-spectre", cmd = { "Spectre" }, config = spectre_setup },

		-- markdown preview
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			build = "cd app && yarn install",
			init = markdown_init,
		},

		-- LSP
		{
			"neovim/nvim-lspconfig",
			event = "BufReadPre",
			dependencies = {
				"williamboman/mason.nvim",
			},
			config = lsp_setup,
		},

		-- completion
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"saadparwaiz1/cmp_luasnip",
				"L3MON4D3/LuaSnip",
				"rafamadriz/friendly-snippets",
				"ray-x/lsp_signature.nvim",
				"nvim-highlight-colors",
			},
			config = suggestion_setup,
		},

		-- treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			event = "BufReadPost",
			dependencies = { "nvim-treesitter/nvim-treesitter-context" },
			config = treesitter_setup,
		},

		-- formatter
		{ "stevearc/conform.nvim", event = "BufWritePre", opts = {}, config = conform_setup },

		-- comment
		{ "numToStr/Comment.nvim", event = "VeryLazy", opts = {}, config = comment_setup },

		-- fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
			config = telescope_setup,
		},

		-- diagnostics / todo
		{
			"folke/todo-comments.nvim",
			event = "BufReadPost",
			opts = { signs = false },
			dependencies = {
				"folke/trouble.nvim",
			},
			config = trouble_todo_setup,
		},

		-- icons
		{ "nvim-tree/nvim-web-devicons", event = "VeryLazy", config = icons_setup },

		-- editing helpers
		{ "windwp/nvim-autopairs", event = "InsertEnter", config = autopairs_setup },
		{ "windwp/nvim-ts-autotag", event = "InsertEnter", config = autotag_setup },
		{ "kylechui/nvim-surround", event = "VeryLazy", config = surround_setup },

		-- status line
		{ "nvim-lualine/lualine.nvim" },

		-- cpp / contest
		{ "xeluxee/competitest.nvim", dependencies = "MunifTanjim/nui.nvim", event = "VeryLazy", config = cpp_setup },

		-- git
		{
			"NeogitOrg/neogit",
			event = "VeryLazy",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim",
				"lewis6991/gitsigns.nvim",
			},
			config = git_setup,
		},
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})

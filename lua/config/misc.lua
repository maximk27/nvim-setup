------------------------------------------lualine--------------------------------------------------
function lualine_setup()
	local theme = "iceberg_dark"
	require("lualine").setup({
		options = {
			theme = theme,
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				"filename",
				-- { "filename", path = 1 },
			},
			lualine_x = {
				{
					"diagnostics",
					sources = { "nvim_lsp" },
				},
				require("triforce.lualine").level,
			},
			lualine_y = {
				"filetype",
			},
			lualine_z = {},
		},
	})
end

----------------------------------------------markdown--------------------------------------------------

function markdown_init()
	vim.g.mkdp_filetypes = { "markdown" }
	vim.g.mkdp_auto_close = 0
	vim.g.mkdp_refresh_slow = 1
end

vim.keymap.set("n", "<leader>p", ":MarkdownPreview<CR>")

----------------------------------------------persistence--------------------------------------------------
function persistence_setup()
	require("persistence").setup()
end

vim.keymap.set("n", ";z", function()
	require("persistence").load()
end)

----------------------------------------------notify--------------------------------------------------
function notify_setup()
	vim.notify = require("notify")
	require("notify").setup({
		render = "compact",
		timeout = 1500,
		fps = 60,
	})
	vim.keymap.set("n", "<leader>c", function()
		require("notify").dismiss({ silent = true, pending = true })
	end)
end

----------------------------------------------trit force--------------------------------------------------
function tritforce_setup()
	require("triforce").setup({
		xp_rewards = {
			char = 1,
			line = 0,
			save = 0,
		},
		notifications = {
			enabled = true,
			level_up = true,
			achievements = true,
		},
	})
end

----------------------------------------------debugger--------------------------------------------------

function debug_setup()
	local dap = require("dap")
	local dapui = require("dapui")
	dapui.setup({
		layouts = {
			{
				elements = {
					{
						id = "watches",
						size = 0.2,
					},
					{
						id = "scopes",
						size = 0.6,
					},
					{
						id = "breakpoints",
						size = 0.2,
					},
				},
				position = "left",
				size = 40,
			},
			{
				elements = {
					{
						id = "repl",
						size = 0.5,
					},
					{
						id = "console",
						size = 0.5,
					},
				},
				position = "bottom",
				size = 10,
			},
		},
	})

	vim.fn.sign_define("DapBreakpoint", { text = "▲", texthl = "DapBreakpointColor", linehl = "", numhl = "" })

	require("dap.ext.vscode").load_launchjs(nil, {})

	dap.adapters.cppdbg = {
		id = "cppdbg",
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
	}

	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = function()
				local input = vim.fn.input("Arguments: ")
				return vim.split(input, " ", { trimempty = true })
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = true,
		},
	}
	--
	vim.keymap.set("n", "\\t", function()
		dap.terminate()
		dapui.close()
	end)

	vim.keymap.set("n", "\\q", function()
		dapui.toggle()
	end)
	vim.keymap.set("n", "\\c", function()
		dap.continue()
	end)
	vim.keymap.set("n", "\\r", function()
		dap.restart()
	end)
	vim.keymap.set("n", "\\w", function()
		dap.step_over()
	end)
	vim.keymap.set("n", "\\s", function()
		dap.step_into()
	end)
	vim.keymap.set("n", "\\o", function()
		dap.step_out()
	end)
	vim.keymap.set("n", "\\b", function()
		dap.toggle_breakpoint()
	end)

	dap.listeners.before.attach.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
	end
end

----------------------------------------------replacer setup--------------------------------------------------
function spectre_setup()
	require("spectre").setup()
end
vim.keymap.set("n", ";v", ":Spectre<CR>")

-----------------------------------------------suggestion setup--------------------------------------------------
function suggestion_setup()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	vim.lsp.config("*", {
		capabilities = capabilities,
		root_markers = { ".git" },
	})

	local ls = require("luasnip")

	require("luasnip.loaders.from_vscode").lazy_load()

	require("nvim-highlight-colors").setup({})

	local cmp = require("cmp")
	cmp.setup({
		preselect = cmp.PreselectMode.None,
		formatting = {
			format = require("nvim-highlight-colors").format,
		},
		snippet = {
			expand = function(args)
				ls.lsp_expand(args.body)
			end,
		},
		mapping = {
			-- ["<C-n>"] = cmp.config.disable,
			-- ["<C-p>"] = cmp.config.disable,
			["<C-e>"] = cmp.config.disable,
			["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
		},
		window = {
			completion = cmp.config.window.bordered({
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			}),
			documentation = cmp.config.window.bordered({
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			}),
		},
		performance = {
			debounce = 60,
			throttle = 30,
			fetching_timeout = 200,
			max_view_entries = 4,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "buffer" },
		}),
	})

	require("lsp_signature").setup({
		floating_window = true,
		floating_window_above_cur_line = true,
		max_height = 3,
		hint_enable = false,
	})
end

-------------------------------------------tree-sitter setup--------------------------------------------
function treesitter_setup()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "java" },
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = {
			enable = false,
		},
	})

	require("treesitter-context").setup({
		max_lines = 1,
	})

	local function setBG(group, bg_color)
		local current_hl = vim.api.nvim_get_hl_by_name(group, true)
		local fg_color = current_hl.foreground or "NONE"
		vim.api.nvim_set_hl(0, group, { fg = fg_color, bg = bg_color })
	end
	setBG("TreesitterContextBottom", "#203034")

	vim.keymap.set("n", "<C-a>", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, { silent = true })
end
-------------------------------------------comment setup--------------------------------------------------
function comment_setup()
	require("Comment").setup({
		toggler = {
			line = "<C-s>",
		},
		opleader = {
			line = "<C-s>",
		},
	})
end

-------------------------------------------autopairs setup--------------------------------------------
function autopairs_setup()
	local autopairs = require("nvim-autopairs")
	local Rule = require("nvim-autopairs.rule")
	local cond = require("nvim-autopairs.conds")

	autopairs.setup({
		map_bs = true, -- map the <BS> key
		map_c_w = true, -- Map the <C-h> key to delete a pair
		check_ts = true, -- Enable treesitter integration
		enable_afterquote = false, -- add bracket pairs after quote
		fast_wrap = {
			map = "<C-j>",
			end_key = "l",
			manual_position = false,
			keys = "asdfghjk",
			-- cursor_pos_before = treu,
		},
		ignored_next_char = "[%w%(%{%[%'%\"]",
	})

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

	function rule1(a1, ins, a2, lang)
		autopairs.add_rule(Rule(ins, ins, lang)
			:with_pair(function(opts)
				return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
			end)
			:with_move(cond.none())
			:with_cr(cond.none())
			:with_del(function(opts)
				local col = vim.api.nvim_win_get_cursor(0)[2]
				return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
			end))
	end

	rule1("(", " ", ")")
	rule1("{", " ", "}")
	rule1("[", " ", "]")

	vim.keymap.set("i", "@{<CR>", "{<CR>};<ESC>O", { noremap = true, silent = true })
	--
end

-------------------------------------------autotag setup--------------------------------------------
function autotag_setup()
	require("nvim-ts-autotag").setup({
		opts = {
			-- Defaults
			enable_close = true, -- Auto close tags
			enable_rename = true, -- Auto rename pairs of tags
			enable_close_on_slash = false, -- Auto close on trailing </
		},
	})
end

-------------------------------------------surround setup--------------------------------------------
function surround_setup()
	require("nvim-surround").setup({
		move_cursor = false,
		keymaps = {
			normal = "vs",
			normal_cur = "vss",
			normal_line = "vS",
			normal_cur_line = "vSS",
			visual = "s",
			visual_line = "gs",
			delete = "ds",
			change = "cs",
			change_line = "cS",
		},
	})
end

-------------------------------------------file manager setup--------------------------------------------

function oil_setup()
	-- setup icons
	local devicons = require("nvim-web-devicons")
	devicons.setup({})

	-- setup inl
	local hpp_icon, _ = devicons.get_icon_color("file.hpp", "hpp")
	devicons.set_icon({
		inl = {
			icon = hpp_icon,
			color = "#6cb6ff",
			name = "Inl",
		},
	})

	-- setup edit hub
	require("oil").setup({
		view_options = {
			show_hidden = true,
			show_parent_dir = false,
		},
		keymaps = {
			["<C-c>"] = { "", mode = "n" },
			["_"] = { "e!", mode = "c" },
			["f"] = "actions.select",
		},

		win_options = {
			signcolumn = "yes:2",
		},
	})
end
vim.keymap.set("n", "-", ":Oil<CR>", { silent = true })

-------------------------------------------cpp setup--------------------------------------------

-- set keybinds
function cpp_setup()
	-- change theme colors
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "leetcode.nvim",
		callback = function()
			vim.api.nvim_set_hl(0, "leetcode_dyn_p", { fg = "#B0B0B0" })
			vim.api.nvim_set_hl(0, "leetcode_dyn_pre", { fg = "#B0B0B0" })
			vim.api.nvim_set_hl(0, "leetcode_ok", { fg = "#228B22" })
			vim.api.nvim_set_hl(0, "leetcode_case_ok", { fg = "#228B22" })
			vim.api.nvim_set_hl(0, "leetcode_case_focus_ok", { bg = "#228B22", fg = "#FFFFFF" })

			-- keybinds
			vim.keymap.set("n", "<leader>lr", ":Leet random<CR>")
			vim.keymap.set("n", "<leader>lq", ":Leet console<CR>")
			vim.keymap.set("n", "<leader>le", ":Leet run<CR>")
			vim.keymap.set("n", "<leader>lw", ":Leet desc<CR>")
			vim.keymap.set("n", "<leader>lf", ":Leet list<CR>")
			vim.keymap.set("n", "<leader>ld", ":Leet tabs<CR>")
			vim.keymap.set("n", "<leader>ls", ":Leet submit<CR>")
			vim.keymap.set("n", "<leader>ll", ":Leet lang<CR>")
			vim.keymap.set("n", "-", function()
				vim.notify("nope")
			end)
		end,
	})
end

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
	vim.keymap.set("n", "<leader>c", ":NotificationsClear<CR>", { silent = true })
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

----------------------------------------------icons--------------------------------------------------

function icons_setup()
	local devicons = require("nvim-web-devicons")
	local hpp_icon, _ = devicons.get_icon_color("file.hpp", "hpp")

	devicons.set_icon({
		inl = {
			icon = hpp_icon,
			color = "#6cb6ff", -- lighter blue
			name = "Inl",
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

----------------------------------------------lsp setup--------------------------------------------------
function lsp_setup()
	require("mason").setup({})

	vim.lsp.config("pyright", {
		settings = {
			["python"] = {
				analysis = {
					typeCheckingMode = "off",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "openFilesOnly",
					extraPaths = { "." },
				},
			},
		},
	})

	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})

	vim.lsp.config("rust-analyzer", {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml" },
		settings = {
			["rust-analyzer"] = {
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
				},
			},
		},
	})

	local ls_to_setup = { "pyright", "clangd", "lua_ls", "html", "ts_ls", "cmake", "rust-analyzer", "taplo" }
	for _, server in ipairs(ls_to_setup) do
		vim.lsp.enable(server)
	end

	vim.lsp.set_log_level("WARN")

	function hoverLook()
		vim.lsp.buf.hover({
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		})
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "LSP actions",
		callback = function(event)
			local opts = { buffer = event.buf }
			vim.keymap.set("n", "<C-k>", hoverLook, opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>cexpr []<cr><cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", ";r", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			-- vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "ge", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			vim.keymap.set("n", "<M-l>", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
			vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
			vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
		end,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true,
		signs = {
			severity = { min = vim.diagnostic.severity.WARN },
			text = {
				[vim.diagnostic.severity.ERROR] = "●",
				[vim.diagnostic.severity.WARN] = "●",
				[vim.diagnostic.severity.HINT] = "●",
				[vim.diagnostic.severity.INFO] = "●",
			},
		},
		virtual_lines = false,
		underline = false,
		update_in_insert = false,
		float = { border = "rounded" },
	})
end

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
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
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
		max_lines = 2,
	})

	vim.keymap.set("n", ";e", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, { silent = true })
end
-------------------------------------------conform setup--------------------------------------------------
function conform_setup()
	local conform = require("conform")
	conform.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			python = { "ruff_format" },
			javascript = { "prettierd", "prettier" },
			html = { "prettierd", "prettier" },
			rust = { "rustfmt" },
			-- ["_"] = { "trim_whitespace" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	})
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	vim.api.nvim_set_keymap("n", "==", "gqq", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "=", "gq", { noremap = true, silent = true })
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
function cpp_setup()
	local args = {
		"-std=c++23",
		"-O0",
		"$(FNAME)",
		"-o",
		"$(FNOEXT)",
	}

	require("competitest").setup({
		compile_command = {
			cpp = { exec = "g++", args = args },
			python = { exec = "pypy3" },
		},
		-- replace_received_testcases = true,
		popup_ui = {
			total_width = 0.9,
			total_height = 0.95,
			layout = {
				{
					1,
					{
						{ 1, "so" },
						{
							1,
							{
								{ 1, "tc" },
								{ 1, "se" },
							},
						},
					},
				},
				{ 1, {
					{ 1, "eo" },
					{ 1, "si" },
				} },
			},
		},
		template_file = {
			cpp = "~/cpp/template/setup.cpp",
			py = "~/cpp/template/setup.py",
		},
		received_contests_directory = "$(HOME)/cpp/contest/$(CONTEST)",
		received_problems_path = "$(HOME)/cpp/problems/$(PROBLEM).$(FEXT)",
		evaluate_template_modifiers = true,
	})
end

vim.keymap.set("n", "<leader>le", ":CompetiTest run<CR>")
vim.keymap.set("n", "<leader>lw", ":CompetiTest receive problem<CR>")
vim.keymap.set("n", "<leader>lc", ":CompetiTest receive contest<CR>")
vim.keymap.set("n", "<leader>lq", ":CompetiTest show_ui<CR>")

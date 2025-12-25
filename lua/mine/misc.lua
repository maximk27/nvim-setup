----------------------------------------------persistence--------------------------------------------------
require("persistence").setup()

vim.keymap.set("n", ";z", function()
	require("persistence").load()
end)

----------------------------------------------notify--------------------------------------------------
vim.notify = require("notify")
require("notify").setup({
	render = "compact",
	timeout = 1500,
	fps = 60,
})

----------------------------------------------trit force--------------------------------------------------
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

----------------------------------------------icons--------------------------------------------------

local devicons = require("nvim-web-devicons")
local hpp_icon, _ = devicons.get_icon_color("file.hpp", "hpp")

devicons.set_icon({
	inl = {
		icon = hpp_icon,
		color = "#6cb6ff", -- lighter blue
		name = "Inl",
	},
})

----------------------------------------------alignment--------------------------------------------------
vim.keymap.set("n", "ga", ":EasyAlign<CR>*")
vim.keymap.set("v", "ga", ":EasyAlign<CR>*")

vim.keymap.set("v", "gj", function()
	vim.cmd([[execute "normal! \<ESC>"]])
	local top = vim.fn.getpos("'<")[2]
	local bottom = vim.fn.getpos("'>")[2]
	vim.fn.append(top - 1, "\t// clang-format off")
	vim.fn.append(bottom + 1, "\t// clang-format on")
end)

----------------------------------------------debugger--------------------------------------------------
-- require("mason-nvim-dap").setup()
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

----------------------------------------------doc generator--------------------------------------------------

vim.keymap.set("n", ";e", ':lua require("neogen").generate()<CR>', { noremap = true })

----------------------------------------------replacer setup--------------------------------------------------
require("spectre").setup()
vim.keymap.set("n", ";v", ":Spectre<CR>")

----------------------------------------------indent setup--------------------------------------------------
-- vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "NONE", nocombine = true })
require("ibl").setup({
	enabled = true,
	indent = {
		char = "┆",
	},
	scope = {
		enabled = false,
	},
	-- whitespace = {
	-- 	remove_blankline_trail = false,
	-- },
})

----------------------------------------------tree setup--------------------------------------------------

local tsj = require("treesj")
tsj.setup({
	use_default_keymaps = false,
})
vim.keymap.set("n", "<C-j>", ":lua require('treesj').toggle()<CR>", { silent = true })

----------------------------------------------lsp setup--------------------------------------------------

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup({})
-- require("mason-lspconfig").setup({
-- 	automatic_enable = true,
-- })

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

vim.lsp.config("pyright", {
	settings = {
		["python"] = {
			analysis = {
				typeCheckingMode = "off",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				extraPaths = { "." }, -- optional but reinforces absolute path support
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
			-- workspace = {
			-- 	library = vim.api.nvim_get_runtime_file("", true),
			-- 	checkThirdParty = false,
			-- },
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

----------------------------------------------lsp setup--------------------------------------------------

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

-- make hover rounded window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	-- virtual_text = {
	-- 	prefix = "▲",
	-- 	severity = {
	-- 		min = vim.diagnostic.severity.ERROR,
	-- 	},
	-- },
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
	-- underline = {
	-- 	severity = {
	-- 		min = vim.diagnostic.severity.WARN,
	-- 		max = vim.diagnostic.severity.ERROR,
	-- 	},
	-- },
	update_in_insert = false,
	float = { border = "rounded" },
})

-----------------------------------------------suggestion setup--------------------------------------------------
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

-------------------------------------------tree-sitter setup--------------------------------------------
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

vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-------------------------------------------conform setup--------------------------------------------------
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

-------------------------------------------comment setup--------------------------------------------------
require("Comment").setup({
	toggler = {
		line = "<C-s>",
	},
	opleader = {
		line = "<C-s>",
	},
})

-------------------------------------------fuzzy finder setup--------------------------------------------
local telescope = require("telescope")
telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				width = 0.9,
				height = 0.8,
				preview_cutoff = 0,
				preview_width = 0.6,
			},
		},
		file_ignore_patterns = {
			".git/",
			"%.o",
			"%.out",
			"%.dSYM/",
			"__pycache__",
			"build",
			"venv",
			".venv",
			"env",
			".env",
		},
	},
	-- pickers = {
	-- 	find_files = {
	-- 		theme = "ivy",
	-- 	},
	-- 	buffers = {
	-- 		theme = "ivy",
	-- 	},
	-- 	live_grep = {
	-- 		theme = "ivy",
	-- 	},
	-- 	git_branches = {
	-- 		theme = "ivy",
	-- 	},
	-- },
})

vim.keymap.set("n", ";w", ":Telescope git_branches<CR>", { silent = true })

local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
vim.keymap.set("n", ";f", builtin.buffers)

vim.keymap.set("n", ";l", builtin.find_files)
vim.keymap.set("n", ";c", function()
	builtin.diagnostics({ severity_limit = vim.diagnostic.severity.ERROR })
end)
vim.keymap.set("n", ";g", builtin.live_grep)

require("trouble").setup({
	win = {
		size = 5,
	},
	filter = {
		severity = {
			min = vim.diagnostic.severity.ERROR,
			max = vim.diagnostic.severity.ERROR,
		},
	},
	update_in_insert = true,
})

-- vim.keymap.set("n", ";t", "<CMD>Trouble diagnostics toggle<CR>")
-------------------------------------------todo setup--------------------------------------------

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", ";t", "<CMD>TodoTelescope<CR>")

-------------------------------------------autopairs setup--------------------------------------------
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

require("nvim-ts-autotag").setup({
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = false, -- Auto close on trailing </
	},
})

-------------------------------------------surround setup--------------------------------------------
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

-------------------------------------------file manager setup--------------------------------------------
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
})

vim.keymap.set("n", "-", ":Oil<CR>", { silent = true })

-------------------------------------------cpp setup--------------------------------------------
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

local once = true

local function set_leet_keymaps()
	if not once then
		return
	end
	once = false
	vim.keymap.set("n", "<leader>lr", ":Leet random<CR>")
	vim.keymap.set("n", "<leader>lq", ":Leet console<CR>")
	vim.keymap.set("n", "<leader>le", ":Leet run<CR>")
	vim.keymap.set("n", "<leader>lw", ":Leet desc<CR>")
	vim.keymap.set("n", "<leader>lf", ":Leet list<CR>")
	vim.keymap.set("n", "<leader>ld", ":Leet tabs<CR>")
	vim.keymap.set("n", "<leader>ls", ":Leet submit<CR>")
	vim.keymap.set("n", "<leader>ll", ":Leet lang<CR>")
end

local function set_competi_keymaps()
	if not once then
		return
	end
	once = false
	vim.keymap.set("n", "<leader>le", ":CompetiTest run<CR>")
	vim.keymap.set("n", "<leader>lw", ":CompetiTest receive problem<CR>")
	vim.keymap.set("n", "<leader>lc", ":CompetiTest receive contest<CR>")
	vim.keymap.set("n", "<leader>lq", ":CompetiTest show_ui<CR>")
end

-- Auto-detect if a LeetCode buffer is active and change keymaps
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0) -- Get current buffer name
		if bufname:match("leetcode.nvim") then
			set_leet_keymaps() -- Apply LeetCode keymaps
		else
			set_competi_keymaps() -- Apply CompetiTest keymaps
		end
	end,
})

-------------------------------------------mark setup--------------------------------------------
require("projectmarks").setup({
	shadafile = "nvim.shada",
	mappings = true,
	abbreviations = false,
	message = "",
})

-------------------------------------------theme setup--------------------------------------------

require("everforest").setup({
	background = "hard",
})

require("vscode").setup({
	style = "dark",
})

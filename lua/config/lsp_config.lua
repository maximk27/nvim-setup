function lsp_setup_config()
	require("mason").setup({})

	-- python
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

	-- lua
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})

	-- rust
	vim.lsp.config("rust-analyzer", {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
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

	-- md
	vim.lsp.config("marksman", {})

	-- bash
	vim.lsp.config("bashls", {
		cmd = { "bash-language-server", "start" },
		filetypes = { "bash", "sh", "zsh" },
		-- root_dir = root_dir_func({ ".git" }),
	})

	-- go
	vim.lsp.config("gopls", {})

	local ls_to_setup = {
		"pyright",
		"clangd",
		"lua_ls",
		"cmake",
		"rust-analyzer",
		"gopls",
		"bashls",
		"marksman",
	}

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

			-- open buffer in side bar
			vim.keymap.set("n", "<C-w>k", function()
				vim.cmd("vsplit")
				vim.cmd("lua vim.lsp.buf.definition()")
			end, opts)

			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>cexpr []<cr><cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", ";r", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			-- vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "ge", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			vim.keymap.set("n", "<C-j>", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
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

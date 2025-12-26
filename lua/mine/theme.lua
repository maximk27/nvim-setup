-- change theme light/dark
vim.g.transparent_enabled = false

-- if exists fg, then preserve it when changing
local function setBG(group, bg_color)
	local current_hl = vim.api.nvim_get_hl_by_name(group, true)
	local fg_color = current_hl.foreground or "NONE"
	vim.api.nvim_set_hl(0, group, { fg = fg_color, bg = bg_color })
end

local function themeChanges()
	vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", fg = "NONE" })

	-- print("theme changed!")
	local theme
	if vim.opt.background:get() == "light" then
		-- set light
		vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary", { fg = "#FF00FF" })
		vim.api.nvim_set_hl(0, "Identifier", { fg = "#495057" })
		vim.api.nvim_set_hl(0, "Visual", { bg = "#D0E0E3", blend = 50 })
		vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#D0E0E3", blend = 50 })
		vim.api.nvim_set_hl(0, "Normal", { bg = "#F7F7F7", fg = "#495057" })
		vim.api.nvim_set_hl(0, "MatchParen", { fg = "#D2691E" })

		vim.api.nvim_set_hl(0, "leetcode_dyn_p", { fg = "#000000" })
		vim.api.nvim_set_hl(0, "leetcode_dyn_pre", { fg = "#000000" })
		vim.api.nvim_set_hl(0, "leetcode_ok", { fg = "#77B254" })
		vim.api.nvim_set_hl(0, "leetcode_case_ok", { fg = "#77B254" })
		vim.api.nvim_set_hl(0, "leetcode_case_focus_ok", { bg = "#77B254", fg = "#000000" })

		-- local normal = "#F7F7F7"
		local normal = "#FFFFFF"
		vim.api.nvim_set_hl(0, "Normal", { bg = normal, fg = "#000000" })
		setBG("SignColumn", normal)
		setBG("LineNr", normal)
		setBG("NormalNC", normal)

		vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = normal, fg = "#cc0000" })
		vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = normal, fg = "#e0af00" })
		setBG("DiagnosticSignHint", normal)

		local line = "#E7E7E7"
		setBG("CursorLineNr", line)
		setBG("CursorLine", line)
		setBG("TelescopeSelection", line)
		theme = "iceberg_light"
	else
		-- set dark
		vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary", { fg = "#FF66CC" })
		vim.api.nvim_set_hl(0, "Identifier", { fg = "#FFFFFF" })
		vim.api.nvim_set_hl(0, "Visual", { bg = "#335E5E", blend = 80 })
		vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#335E5E", blend = 80 })

		-- local normal = "#2A2B2F"
		local normal = "#212229"
		-- local normal = "#1A1B1F"

		-- vim.api.nvim_set_hl(0, "Normal", { bg = normal, fg = "#FFFFFF" })
		setBG("Normal", normal)
		setBG("SignColumn", normal)
		setBG("LineNr", normal)
		setBG("NormalNC", normal)

		vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = normal, fg = "#ff5f5f" })
		vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = normal, fg = "#e0af00" })
		setBG("DiagnosticSignInfo", normal)
		setBG("DiagnosticSignHint", normal)

		vim.api.nvim_set_hl(0, "Search", { bg = "#FFD700", fg = "#000000", bold = true }) -- Normal search highlight
		vim.api.nvim_set_hl(0, "IncSearch", { bg = "#ffb86c", fg = "#282a36", bold = true }) -- While typing in search mode

		vim.api.nvim_set_hl(0, "MatchParen", { fg = "#FFD700", bg = "#3F3F3F", bold = true })

		vim.api.nvim_set_hl(0, "leetcode_dyn_p", { fg = "#B0B0B0" })
		vim.api.nvim_set_hl(0, "leetcode_dyn_pre", { fg = "#B0B0B0" })
		vim.api.nvim_set_hl(0, "leetcode_ok", { fg = "#228B22" })
		vim.api.nvim_set_hl(0, "leetcode_case_ok", { fg = "#228B22" })
		vim.api.nvim_set_hl(0, "leetcode_case_focus_ok", { bg = "#228B22", fg = "#FFFFFF" })

		-- local line = "#2f323b"
		local line = "#30313b"
		setBG("CursorLine", line)
		setBG("CursorLineNr", line)

		setBG("TelescopeSelection", "#3a3d45")
		theme = "iceberg_dark"
	end

	vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
	vim.api.nvim_set_hl(0, "@parameter", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "@variable.parameter", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
	vim.api.nvim_set_hl(0, "@member", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "@property", { link = "Identifier" })

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

	-- set cursor to default terminal
	vim.cmd("highlight Cursor guifg=NONE guibg=NONE")

	-- Remove italic, bold, underlinefrom all highlight groups
	for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
		local highlight = vim.api.nvim_get_hl_by_name(group, true)
		if highlight then
			highlight.italic = nil
			highlight.bold = nil
			highlight.underline = nil
			vim.api.nvim_set_hl(0, group, highlight)
		end
	end
end

function toggleLightDark()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
	themeChanges()
end

vim.api.nvim_create_autocmd("Colorscheme", {
	callback = themeChanges,
})

vim.keymap.set("n", "<leader>wr", toggleLightDark)

-- setup phoenix
vim.cmd.colorscheme("phoenix")
-- vim.cmd("PhoenixPurple")

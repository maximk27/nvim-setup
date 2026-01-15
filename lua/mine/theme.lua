-- change theme light/dark

------------------------------------------lualine--------------------------------------------------
function lualine_setup()
	local theme
	if vim.o.background == "dark" then
		theme = "iceberg_dark"
	else
		theme = "iceberg_light"
	end

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
--------------------------------- overrides ---------------------------------
local function setBG(group, bg_color)
	local current_hl = vim.api.nvim_get_hl_by_name(group, true)
	local fg_color = current_hl.foreground or "NONE"
	vim.api.nvim_set_hl(0, group, { fg = fg_color, bg = bg_color })
end

local function dark()
	-- if exists fg, then preserve it when changing

	vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", fg = "NONE" })

	vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary", { fg = "#FF66CC" })
	vim.api.nvim_set_hl(0, "Identifier", { fg = "#999999" })
	vim.api.nvim_set_hl(0, "Visual", { bg = "#335E5E", blend = 80 })
	vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#335E5E", blend = 80 })

	local normal = "#212229"
	setBG("Normal", normal)

	local line = "#30313b"
	setBG("CursorLine", line)
	setBG("CursorLineNr", line)

	-- set comment
	local col = "#34C22C"
	vim.api.nvim_set_hl(0, "@comment", { bg = nil, fg = col })

	vim.api.nvim_set_hl(0, "MatchParen", { fg = "#FFD700", bg = "#282a36", bold = true })
end

local function light()
	vim.api.nvim_set_hl(0, "MatchParen", {
		fg = "#FFFFFF",
		bg = "#FFD700",
		bold = true,
	})

	local line = "#E8E8E8"
	setBG("CursorLine", line)
	setBG("CursorLineNr", line)

	-- set comment
	local col = "#3C763D"
	vim.api.nvim_set_hl(0, "@comment", { bg = nil, fg = col })
end

function adjust_colors()
	if vim.o.background == "dark" then
		dark()
	else
		light()
	end

	lualine_setup()

	setBG("SignColumn", nil)
	setBG("LineNr", nil)
	setBG("NormalNC", nil)
	vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = nil, fg = "#ff5f5f" })
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = nil, fg = "#e0af00" })
	setBG("DiagnosticSignInfo", nil)
	setBG("DiagnosticSignHint", nil)
	setBG("NormalFloat", nil)

	vim.api.nvim_set_hl(0, "Search", { bg = "#FFD700", fg = "#000000", bold = true }) -- Normal search highlight
	vim.api.nvim_set_hl(0, "IncSearch", { bg = "#ffb86c", fg = "#282a36", bold = true }) -- While typing in search mode

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

vim.api.nvim_create_autocmd("colorscheme", {
	pattern = "*",
	callback = adjust_colors,
})

vim.keymap.set("n", "<leader>=", function()
	if vim.o.background == "dark" then
		vim.cmd.colorscheme("paper")
	else
		vim.cmd.colorscheme("phoenix")
	end
end)

vim.g.PaperColor_Theme_Options = {
	language = {
		python = {
			highlight_builtins = 0,
		},
		cpp = {
			highlight_standard_library = 0,
		},
		c = {
			highlight_builtins = 0,
		},
	},
}

vim.cmd.colorscheme("phoenix")

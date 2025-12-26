-- change theme light/dark
vim.cmd.colorscheme("phoenix")
--
-- if exists fg, then preserve it when changing
local function setBG(group, bg_color)
	local current_hl = vim.api.nvim_get_hl_by_name(group, true)
	local fg_color = current_hl.foreground or "NONE"
	vim.api.nvim_set_hl(0, group, { fg = fg_color, bg = bg_color })
end

vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", fg = "NONE" })

vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary", { fg = "#FF66CC" })
vim.api.nvim_set_hl(0, "Identifier", { fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#335E5E", blend = 80 })
vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#335E5E", blend = 80 })

local normal = "#212229"
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

local line = "#30313b"
setBG("CursorLine", line)
setBG("CursorLineNr", line)

vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
vim.api.nvim_set_hl(0, "@parameter", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@variable.parameter", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
vim.api.nvim_set_hl(0, "@member", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@property", { link = "Identifier" })

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

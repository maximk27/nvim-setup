-- use 2 indent for web
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"cmake",
	},
	command = "setlocal tabstop=2 shiftwidth=2",
})

-- indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.cindent = true
		vim.opt_local.cinoptions = "l1,(s"
		vim.opt_local.cinwords = "if,else,switch,case,for,while,do"
	end,
})

local header_template = "#pragma once"
local launch_json_template = [[
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run launch.json",
      "type": "cppdbg",
      "request": "launch",
      "program": "${workspaceFolder}/<executable>",
      "args": [],
      "cwd": "${workspaceFolder}/<where_to_run>",
      "stopAtEntry": false,
      "externalConsole": false,
      "MIMode": "gdb",
      "miDebuggerPath": "/usr/bin/gdb"
    }
  ]
}
]]

local language_templates = {
	{ "*.h", header_template },
	{ "*.hpp", header_template },
	{ "*launch.json", launch_json_template },
}

for i = 1, #language_templates do
	local pair = language_templates[i]
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
		pattern = pair[1],
		callback = function()
			local template_lines = vim.split(pair[2], "\n")
			local line_count = vim.api.nvim_buf_line_count(0)
			-- trigger only if empty
			if line_count == 1 then
				vim.api.nvim_buf_set_lines(0, 0, 0, false, template_lines)
			end
		end,
	})
end

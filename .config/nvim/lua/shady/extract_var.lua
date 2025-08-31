local M = {}

local function current_indent_at(row)
	local l = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
	local indent = l:match("^%s*") or ""
	return indent
end

local function make_assignment_line(ft, varname, expr, indent)
	indent = indent or ""
	local multiline = expr:find("\n") ~= nil

	if ft == "lua" then
		return indent .. ("local %s = %s"):format(varname, expr)
	elseif ft == "javascript" or ft == "typescript" or ft == "tsx" or ft == "jsx" then
		if multiline then
			expr = "(" .. expr .. ")"
		end
		return indent .. ("const %s = %s;"):format(varname, expr)
	elseif ft == "python" then
		if multiline then
			expr = "(" .. expr .. ")"
		end
		return indent .. ("%s = %s"):format(varname, expr)
	elseif ft == "php" then
		if not varname:match("^%$") then
			varname = "$" .. varname
		end
		return indent .. ("%s = %s;"):format(varname, expr), varname
	elseif ft == "go" then
		-- Conservative: 'var name = expr' (works both at top and inside func)
		return indent .. ("var %s = %s"):format(varname, expr)
	elseif ft == "rust" then
		if multiline then
			expr = "(" .. expr .. ")"
		end
		return indent .. ("let %s = %s;"):format(varname, expr)
	else
		-- Generic (may need manual tweak for typed languages)
		return indent .. ("%s = %s"):format(varname, expr)
	end
end

local selected_text = function()
	local mode = vim.api.nvim_get_mode().mode
	local opts = {}
	-- \22 is an escaped version of <c-v>
	if mode == "v" or mode == "V" or mode == "\22" then
		opts.type = mode
	end
	return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), opts)
end

local function get_statement_node(node)
	while node do
		local t = node:type()
		if t:match("statement") or t:match("declaration") or t == "return_statement" then
			return node
		end
		node = node:parent()
	end
	return nil
end

--- Insert a prepared declaration above the correct statement
--- @param decl string|string[]  -- full declaration (string, possibly multiline, or list of lines)
local function insert_declaration(decl)
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()
	local stmt = get_statement_node(node) or node
	local start_row = stmt:range() -- row, col, end_row, end_col

	-- normalize into a list of strings (lines)
	local decl_lines = {}
	if type(decl) == "string" then
		for line in decl:gmatch("[^\r\n]+") do
			table.insert(decl_lines, line)
		end
	else
		decl_lines = decl
	end

	vim.api.nvim_buf_set_lines(0, start_row, start_row, false, decl_lines)
	vim.cmd(string.format("normal! %dGV=%dG", start_row+1, start_row + #decl_lines))
end

function M.extract_variable()
	local expr = table.concat(selected_text(), "\n")

	-- var name
	local ok_ui, name = pcall(vim.ui.input, { prompt = "Variable name: " })
	if not ok_ui then
		name = vim.fn.input("Variable name: ")
	end
	if not name or name == "" then
		return
	end

	local ft = vim.bo.filetype
	local assignment, rendered_name = make_assignment_line(ft, name, expr, "")

	local s = vim.fn.getpos("v")
	local e = vim.fn.getpos(".")
	vim.api.nvim_buf_set_text(0, s[2] - 1, s[3] - 1, e[2] - 1, e[3], { rendered_name or name })
	vim.cmd("normal! ")

	insert_declaration(assignment)
end
return M

-- Eviline config for lualine with lazy.nvim
-- Author: shadmansaleh
-- Credit: glepnir

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")

		-- Color table for highlights
		local colors = {
			bg = "#202328",
			fg = "#bbc2cf",
			yellow = "#ECBE7B",
			cyan = "#008080",
			darkblue = "#081633",
			green = "#98be65",
			orange = "#FF8800",
			violet = "#a9a1e1",
			magenta = "#c678dd",
			blue = "#51afef",
			red = "#ec5f67",
		}

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local config = {
			options = {
				section_separators = { left = "", right = "" },
				-- section_separators = { left = '', right = '' },
				component_separators = { left = "", right = "" },
				-- component_separators = { left = '', right = '' },
				theme = {
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		}

		-- Helper functions to insert components
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		local function selectionCount()
			local isVisualMode = vim.fn.mode():find("[Vv]")
			if not isVisualMode then
				return ""
			end
			local starts = vim.fn.line("v")
			local ends = vim.fn.line(".")
			local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
			return tostring(lines) .. "L " .. tostring(vim.fn.wordcount().visual_chars) .. "C"
		end

		local function isRecording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end -- not recording
			return "recording @" .. reg
		end

		local function location()
			return "Ln %l, Col %c"
		end

		local function progress()
			local currentLine = vim.fn.line(".")
			local totalLines = vim.fn.line("$")
			local percent = math.floor((currentLine / totalLines) * 100)
			return string.format("%d/%d (%d%%%%)", currentLine, totalLines, percent)
		end

		-- Add components to the left
		ins_left({
			function()
				return "▊"
			end,
			color = { fg = colors.blue },
			padding = { left = 0, right = 1 },
		})

		ins_left({
			function()
				return ""
			end,
			color = function()
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[""] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[""] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({ "branch", icon = "", color = { fg = colors.violet, gui = "bold" } })
		ins_left({
			"filetype",
			colored = true, -- Displays filetype icon in color if set to true
			icon_only = true, -- Display only an icon for filetype
			icon = { align = "right" }, -- Display filetype icon on the right hand side
			-- icon =    {'X', align='right'}
			-- Icon string ^ in table is ignored in filetype component
			padding = { left = 1, right = 0 }, -- Adds padding to the left and right of components.
			-- Padding can be specified to left or right independently, e.g.:
			--   padding = { left = left_padding, right = right_padding }
		})
		ins_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = colors.magenta, gui = "bold" },
			file_status = true, -- Displays file status (readonly status, modified status)
			newfile_status = false, -- Display new file status (new file means no write after created)
			path = 1, -- 0: Just the filename
			shorting_target = 40, -- Shortens path to leave 40 spaces in the window
			symbols = {
				modified = "[+]", -- Text to show when the file is modified.
				readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
				unnamed = "[No Name]", -- Text to show for unnamed buffers.
				newfile = "[New]", -- Text to show for newly created file before first write
			},
		})
		ins_left({
			"diff",
			symbols = { added = " ", modified = " ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})
		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				error = { fg = colors.red },
				warn = { fg = colors.yellow },
				info = { fg = colors.cyan },
			},
		})

		-- Add mid-section
		ins_left({
			function()
				return "%="
			end,
		})

		-- Add components to the right
		ins_right({
			function()
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				local clients = vim.lsp.get_clients()
				if next(clients) ~= nil then
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
				end
			end,
			icon = " ",
			cond = function()
				local clients = vim.lsp.get_clients()
				if next(clients) ~= nil then
					for _, client in ipairs(clients) do
						local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return true
						end
					end
				end
			end,
		})

		ins_right({ "searchcount", maxcount = 999, timeout = 500 })
		ins_right({ isRecording })
		ins_right({
			"o:encoding",
			fmt = string.upper,
			cond = conditions.hide_in_width,
			color = { fg = colors.green },
		})
		ins_right({ location, color = { gui = "bold" } })
		ins_right({ selectionCount })
		ins_right({ progress, icon = "", color = { fg = colors.yellow, gui = "bold" } })
		ins_right({
			"filesize",
			icon = "",
			cond = conditions.buffer_not_empty,
			color = { fg = colors.cyan, gui = "bold" },
		})
		ins_right({
			function()
				return "▊"
			end,
			color = { fg = colors.blue },
			padding = { left = 1 },
		})

		-- Initialize lualine
		lualine.setup(config)
	end,
}

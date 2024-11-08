return {
	"L3MON4D3/LuaSnip",
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	-- build = "make install_jsregexp",
	event = "InsertEnter",
	config = function()
		local ls = require("luasnip")

		vim.keymap.set({ "i" }, "<C-L>", function()
			ls.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-K>", function()
			ls.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-J>", function()
			ls.jump(-1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true })

		-- ls.add_snippets({
		-- 	php = {
		-- 		ls.snippet("hello", ls.text_node("Hello ${1|world}!")),
		-- 		-- ls.parser.parse_snippet({ trig = "req", name = "require", dscr = "require a module" }, 'local ${2:${1|vim.fn.expand("%:t:r")}} = require("${1|vim.fn.expand("%:t:r")}")'),
		-- 		-- ls.parser.parse_snippet({ trig = "fun", name = "function", dscr = "create a function" }, 'function ${1|vim.fn.expand("%:t:r")}(${2|args})\n\t${0}\nend'),
		-- 		-- ls.parser.parse_snippet({ trig = "if", name = "if", dscr = "if statement" }, 'if ${1|condition} then\n\t${0}\nend'),
		-- 		-- ls.parser.parse_snippet({ trig = "for", name = "for", dscr = "for loop" }, 'for ${1|i}, ${2|v} in ipairs(${3|table}) do\n\t${0}\nend'),
		-- 		-- ls.parser.parse_snippet({ trig = "forp", name = "for pairs", dscr = "for loop with pairs" }, 'for ${1|k}, ${2|v} in pairs(${3|table}) do\n\t${0}\nend'),
		-- 		-- ls.parser.parse_snippet({ trig = "fori", name = "for ipairs", dscr = "for loop with ipairs" }, 'for ${1|i}, ${2|v} in ipairs(${3|table}) do\n\t${0}\nend'),
		-- 		-- ls.parser.parse_snippet({ trig = "while", name = "while", dscr = "while loop" }, 'while ${1|condition} do\n\t${0}\nend'),
		-- 		-- ls.parser.parse_snippet({ trig = "repeat", name = "repeat", dscr = "repeat loop" }, 'repeat\n\t${0}\nuntil ${1|condition}'),
		-- 		-- ls.parser.parse_snippet({ trig = "print", name = "print", dscr = "print to stdout" }, 'print(${1|args})'),
		-- 		-- ls.parser.parse_snippet({ trig = "log", name = "log", dscr = "log to stdout" }, 'print(vim.inspect(${1|args}))'),
		-- 	},
		-- })

		for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snips/*.lua", true)) do
			loadfile(ft_path)()
		end
	end,
}

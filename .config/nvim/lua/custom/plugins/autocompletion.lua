local kind_icons = {
	Text = "",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰇽",
	Variable = "󰂡",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
	Namespace = "󰌗",
	Deprecated = "󰸽",
	Loading = "󰒡",
}

local function setHighlightGroups()
	vim.api.nvim_set_hl(0, "BlinkCompletionWindow", { fg = "#C5CDD9", bg = "#22252A" })
	vim.api.nvim_set_hl(0, "BlinkCompletionWindowBorder", { fg = "#282C34", bg = "#22252A" })
	vim.api.nvim_set_hl(0, "BlinkCompletionSelected", { bg = "#282C34", fg = "NONE" })

	vim.api.nvim_set_hl(0, "BlinkCompletionItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
	vim.api.nvim_set_hl(0, "BlinkCompletionItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "BlinkCompletionItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "BlinkCompletionItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

	vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = "#EED8DA", bg = "#B5585F" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = "#C3E88D", bg = "#9FBD73" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = "#EADFF0", bg = "#A377BF" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = "#EADFF0", bg = "#A377BF" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

	vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
	vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })
end
return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "default" },

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			documentation = { auto_show = true },
			signature = { enabled = true },
			menu = {
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = kind_icons[ctx.kind]
								if icon == nil then
									local label = ctx.label:match("^(%w+)")
									icon = kind_icons[label] or ""
								end
								if icon ~= "" then
									return " " .. icon .. " "
								end
								return icon
							end,
						},
					},
				},
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	config = function(_, opts)
		local blink = require("blink.cmp")
		setHighlightGroups()

		blink.setup(opts)
	end,

	opts_extend = { "sources.default" },
}

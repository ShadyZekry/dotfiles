return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_SplitWidth = 35
		vim.g.undotree_HighlightChangedText = 1
	end,
}

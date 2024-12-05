return {
	"ThePrimeagen/harpoon",
	config = function()
		require("harpoon").setup({
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
		})

		local ui = require("harpoon.ui")
		vim.keymap.set("n", "<c-h>", ui.toggle_quick_menu, { desc = "Toggle Harpoon Menu" })
		vim.keymap.set("n", "<c-j>", ui.nav_next, { desc = "Navigate to next harpoon mark" })
		vim.keymap.set("n", "<c-k>", ui.nav_prev, { desc = "Navigate to prev harpoon mark" })
		vim.keymap.set(
			"n",
			"<leader>h",
			require("harpoon.mark").add_file,
			{ desc = "Add a harpoon mark to current buffer" }
		)
	end,
}

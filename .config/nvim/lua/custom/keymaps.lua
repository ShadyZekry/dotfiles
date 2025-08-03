require("shady.gitblame")

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--  quickfix list
vim.keymap.set("n", "<space>n", "<cmd>cnext<CR>", { desc = "Move to the next location in quickfix list" })
vim.keymap.set("n", "<space>p", "<cmd>cprevious<CR>", { desc = "Move to the previous location in quickfix list" })

vim.keymap.set(
	"n",
	"<leader>cp",
	"<cmd>let @+ = expand('%') . '#L' . line('.') . ':' . col('.')<CR>",
	{ desc = "Copy line path to clipboard" }
)

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.api.nvim_create_user_command("SnakeToPascal", function()
	local word = vim.fn.expand("<cword>") -- Get the word under the cursor
	local pascal_case = word:gsub("_(%a)", function(c)
		return c:upper()
	end):gsub("^%l", string.upper) -- Convert to PascalCase
	vim.cmd('normal! "_ciw' .. pascal_case .. "b") -- Replace the word with PascalCase
end, { desc = "Convert word under cursor from snake_case to PascalCase" })

vim.api.nvim_create_user_command("PascalToSnake", function()
	local word = vim.fn.expand("<cword>") -- Get the word under the cursor
	local pascal_case = word:gsub("([A-Z])", function(c)
		return "_" .. c:lower()
	end):sub(2) -- Convert to PascalCase
	vim.cmd('normal! "_ciw' .. pascal_case .. "b") -- Replace the word with PascalCase
end, { desc = "Convert word under cursor from PascalCase to snake_case" })

vim.keymap.set("n", "<C-g>", toggle_blame, { noremap = true, silent = true, desc = "Toggle Git Blame" })

-- vim.keymap.set(
-- 	"n",
-- 	"<leader>td",
-- 	create_todo_floating_window,
-- 	{ noremap = true, silent = true, desc = "Open TODO window" }
-- )

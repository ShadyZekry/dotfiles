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
vim.keymap.set("n", "<leader>n", "<cmd>cnext<CR>", { desc = "Move to the next location in quickfix list" })
vim.keymap.set("n", "<leader>p", "<cmd>cprevious<CR>", { desc = "Move to the previous location in quickfix list" })

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

-- Namespace for virtual text
local ns_id = vim.api.nvim_create_namespace("git_blame")

-- Helper function for relative time (same as before)
local function get_relative_time(timestamp)
	local current_time = os.time()
	local commit_time = tonumber(timestamp)
	local diff_seconds = current_time - commit_time

	local minutes = math.floor(diff_seconds / 60)
	if minutes < 60 then
		return minutes == 1 and "1 minute ago" or minutes .. " minutes ago"
	end
	local hours = math.floor(diff_seconds / 3600)
	if hours < 24 then
		return hours == 1 and "1 hour ago" or hours .. " hours ago"
	end
	local days = math.floor(diff_seconds / 86400)
	if days < 30 then
		return days == 1 and "1 day ago" or days .. " days ago"
	end
	local months = math.floor(diff_seconds / 2592000)
	if months < 12 then
		return months == 1 and "1 month ago" or months .. " months ago"
	end
	local years = math.floor(diff_seconds / 31536000)
	return years == 1 and "1 year ago" or years .. " years ago"
end

-- Get blame info
local function get_blame_info()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" or not vim.fn.filereadable(filepath) then
		return nil
	end

	local blame =
		vim.fn.systemlist({ "git", "blame", "-L", current_line .. "," .. current_line, "--line-porcelain", filepath })
	if vim.v.shell_error == 0 then
		local committer = blame[6]:match("committer (.*)") or "Unknown"
		local timestamp = blame[8]:match("committer%-time (.*)") or os.time()
		local summary = blame[10]:match("summary (.*)") or "No summary"

		return string.format("  %s 󰃭  %s   %s", committer, get_relative_time(timestamp), summary)
	end
	return nil
end

-- Toggle blame display
local augroup = vim.api.nvim_create_augroup("GitBlameVirtualText", { clear = true })
local blame_enabled = false
local function toggle_blame()
	blame_enabled = not blame_enabled

	if not blame_enabled then
		vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
		print("Git blame disabled")
		return
	end

	-- Update blame on cursor movement when enabled
	local function update_blame()
		if not blame_enabled then
			return
		end

		vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		local blame_info = get_blame_info()
		if blame_info then
			local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-based for API
			vim.api.nvim_buf_set_extmark(0, ns_id, current_line, 0, {
				virt_text = { { blame_info, "Comment" } },
				virt_text_pos = "eol",
				hl_mode = "combine",
				priority = 100,
			})
		end
	end

	-- Initial update
	update_blame()

	-- Autocommand for cursor movement
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = augroup,
		buffer = 0,
		callback = update_blame,
	})
	print("Git blame enabled")
end

-- Keybinding to toggle
vim.keymap.set("n", "<C-z>", toggle_blame, { noremap = true, silent = true, desc = "Toggle Git Blame" })

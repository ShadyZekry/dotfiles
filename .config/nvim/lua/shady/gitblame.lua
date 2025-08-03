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
		local author = blame[2]:match("author (.*)") or "Unknown"
		local timestamp = blame[4]:match("author%-time (.*)") or os.time()
		local summary = blame[10]:match("summary (.*)") or "No summary"

		return string.format("  %s 󰃭  %s   %s", author, get_relative_time(timestamp), summary)
	end
	return nil
end

-- Toggle blame display
local augroup = vim.api.nvim_create_augroup("GitBlameVirtualText", { clear = true })
local blame_enabled = false
function toggle_blame()
	blame_enabled = not blame_enabled

	if not blame_enabled then
		vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
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
end

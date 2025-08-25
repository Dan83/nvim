require("core.options")
require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.neotree"),
	require("plugins.colortheme"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocompletation"),
	require("plugins.autoformatting"),
	require("plugins.gitsigns"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.comment"),
	require("plugins.floaterm"),
	-- require("plugins.neoai"),
	require("plugins.rust-tools"),
	-- require("plugins.gemini"),
})

vim.cmd([[colorscheme tokyonight]])

vim.api.nvim_create_user_command("ClippyQF", function()
	local output = vim.fn.systemlist("cargo clippy --message-format short 2>&1")
	local qf_list = {}

	for _, line in ipairs(output) do
		local filename, lnum, col, message = string.match(line, "([^:]+):(%d+):(%d+):%s*(.*)")
		if filename and lnum and col and message then
			table.insert(qf_list, {
				filename = filename,
				lnum = tonumber(lnum),
				col = tonumber(col),
				text = message,
			})
		end
	end

	vim.fn.setqflist({}, "r") -- pulisce la lista
	if #qf_list > 0 then
		vim.fn.setqflist(qf_list, "r")
		vim.cmd("copen")
	else
		print("✅ Nessun errore da cargo clippy.")
	end
end, {})

-- vim.opt.makeprg = "cargo clippy"
-- vim.opt.errorformat = "%Eerror[%n]: %m,%C%#--> %f:%l:%c,%Z%m"

-- Easily comment visual regions/lines
return {
	"numToStr/Comment.nvim",
	keys = {
		{
			"<C-/>",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			desc = "Toggle comment line",
			mode = "n",
		},
		{
			"<C-_>",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			desc = "Toggle comment line",
			mode = "n",
		},
		{
			"<C-/>",
			"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
			desc = "Toggle comment line",
			mode = "v",
		},
		{
			"<C-_>",
			"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
			desc = "Toggle comment line",
			mode = "v",
		},
	},
	opts = {},
}

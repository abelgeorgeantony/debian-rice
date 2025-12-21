return {
	"rmagatti/goto-preview",
	dependencies = { "rmagatti/logger.nvim" },
	event = "BufEnter",
	config = true, -- Uses default config
	keys = {
		{
			"gp", -- Keybinding: g + p (Go Peek)
			"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
			desc = "Peek Definition",
		},
		{
			"gq", -- Keybinding: g + q (Close Peek)
			"<cmd>lua require('goto-preview').close_all_win()<CR>",
			desc = "Close Peek Window",
		},
	},
}

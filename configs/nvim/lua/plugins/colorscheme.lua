return {
	{
		"kuri-sun/yoda.nvim",
	},
	{
		"wurli/cobalt.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"github-main-user/lytmode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local c = require("lytmode.colors").get_colors()
			require("lytmode").setup({
				-- Enable transparent background
				transparent = false,

				-- Enable italic comment
				italic_comments = true,

				-- Enable italic inlay type hints
				italic_inlayhints = true,

				-- Underline `@markup.link.*` variants
				underline_links = true,

				-- Disable nvim-tree background color
				disable_nvimtree_bg = true,

				-- Apply theme colors to terminal
				terminal_colors = true,

				-- Override colors (see ./lua/lytmode/colors.lua)
				color_overrides = {
					lytLineNumber = "#FFFFFF",
				},

				-- Override highlight groups (see ./lua/lytmode/theme.lua)
				group_overrides = {
					-- this supports the same val table as vim.api.nvim_set_hl
					-- use colors from this colorscheme by requiring lytmode.colors!
					Cursor = { fg = c.lytDarkBlue, bg = c.lytLightGreen, bold = true },
				},
			})
		end,
	},
}

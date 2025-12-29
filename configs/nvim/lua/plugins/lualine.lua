return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto", -- Automatically matches your colorscheme
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" }, -- Clean "flat" look
		},
		sections = {
			-- Left side
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },

			-- Right side
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}

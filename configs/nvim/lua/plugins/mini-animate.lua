return {
	"nvim-mini/mini.animate",
	version = "*", -- Use the stable release
	event = "VeryLazy", -- Load immediately after startup
	opts = {
		-- Cursor movement animation
		cursor = { enable = true },

		-- Scrolling animation
		-- NOTE: If you find scrolling "laggy" or if it conflicts with
		-- other scroll plugins, change this to `enable = false`
		scroll = { enable = false },

		-- Window resize animation
		resize = { enable = true },

		-- Window open/close animations
		open = { enable = true },
		close = { enable = true },
	},
}

return {
	"nvim-mini/mini.indentscope",
	version = "*", -- Use the stable release
	event = { "BufReadPre", "BufNewFile" }, -- Load when opening a file
	opts = {
		-- The symbol to use for the indent line
		symbol = "│",
		-- Animation options (can be disabled by setting delay = 0)
		draw = {
			delay = 100,
			animation = function()
				return 20
			end, -- Constant animation speed
		},
		-- Mappings to jump to the scope border
		mappings = {
			object_scope = "ii",
			object_scope_with_border = "ai",
			goto_top = "[i",
			goto_bottom = "]i",
		},
	},
	-- "init" allows us to execute code before the plugin loads.
	-- This is useful to disable the plugin for certain filetypes (like dashboards)
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}

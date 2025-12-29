return {
	"nvim-mini/mini.pairs",
	version = "*",
	event = "InsertEnter", -- Only load when you start typing
	opts = {
		-- In which modes should this work?
		modes = { insert = true, command = false, terminal = false },

		-- Add the < > pair (not enabled by default)
		mappings = {
			["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
			[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

			-- Note: The defaults for (, [, {, ", ' are already enabled.
			-- You don't need to list them here unless you want to change them.
		},
	},
}

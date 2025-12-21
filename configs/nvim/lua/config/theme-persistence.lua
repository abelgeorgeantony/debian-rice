local theme_cache = vim.fn.stdpath("data") .. "/last_theme.txt"

-- 1. Function to Load the saved theme on startup
local function load_theme()
	local f = io.open(theme_cache, "r")
	if f then
		local theme = f:read("*all")
		f:close()
		-- Clean up whitespace (newlines)
		theme = string.gsub(theme, "%s+", "")
		if theme ~= "" then
			pcall(vim.cmd.colorscheme, theme)
		end
	end
end

-- 2. Function to Save the theme whenever it changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Don't save if it's the default definition or during startup checks
		if vim.g.colors_name then
			local f = io.open(theme_cache, "w")
			if f then
				f:write(vim.g.colors_name)
				f:close()
			end
		end
	end,
})

-- Load immediately when this file is required
load_theme()

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- Load this when opening a file
	opts = {
		-- Define which formatters to use for each filetype
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			graphql = { "prettier" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			go = { "gofumpt" },
			-- Rust: We usually rely on the LSP (rust-analyzer) for this,
			-- so we don't list a specific tool here and let lsp_fallback handle it.
		},
		-- Enable Format on Save
		format_on_save = {
			timeout_ms = 2500, -- Give it 2.5 seconds before giving up
			lsp_fallback = true, -- If no formatter is found, ask the LSP to do it
		},
	},
}

return {
	-- Main Plugin: LSP Config
	"neovim/nvim-lspconfig",
	tag = "v1.0.0",
	dependencies = {
		-- 1. Mason (The Installer)
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		{
			"williamboman/mason-lspconfig.nvim",
			tag = "v1.31.0",
		},
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- 2. Autocompletion (The Engine)
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp", -- Source: LSP
		"hrsh7th/cmp-buffer", -- Source: Text in buffer
		"hrsh7th/cmp-path", -- Source: File system paths

		-- 3. Snippets (The Templates)
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets", -- Collection of snippets
	},
	config = function()
		-- IMPORT PLUGINS
		local cmptool = require("cmp")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- 1. SETUP MASON (The Installer)
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Auto-install these tools
		mason_tool_installer.setup({
			-- Disable the integration to prevent the crash
			integrations = {
				["mason-lspconfig"] = false,
			},
			ensure_installed = {
				-- LSPs (The "Brains")
				"lua-language-server",
				"pyright", -- Python
				"typescript-language-server", -- JS/TS
				"clangd", -- C/C++
				"gopls", -- Go
				"rust-analyzer", -- Rust

				-- Formatters (The "Beautifiers")
				"stylua", -- Lua
				"prettier", -- Web (HTML, CSS, JSON, JS, TS, Markdown)
				"black", -- Python
				"isort", -- Python Imports
				"clang-format", -- C/C++
				"gofumpt", -- Go (Stricter gofmt)
			},
		})

		-- 2. SETUP LSP CONFIG (The Connector)
		mason_lspconfig.setup({
			-- Function to run for every installed LSP
			handlers = {
				function(server_name)
					local capabilities = require("cmp_nvim_lsp").default_capabilities()
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		})

		-- 3. SETUP AUTOCOMPLETION (The UI)
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load() -- Load friendly-snippets

		cmptool.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmptool.config.window.bordered(),
				documentation = cmptool.config.window.bordered(),
			},
			mapping = cmptool.mapping.preset.insert({
				["<C-n>"] = cmptool.mapping.select_next_item(), -- Next suggestion
				["<C-p>"] = cmptool.mapping.select_prev_item(), -- Previous suggestion
				["<C-Space>"] = cmptool.mapping.complete(), -- Force show menu
				["<CR>"] = cmptool.mapping.confirm({ select = true }), -- Enter to confirm
			}),
			sources = cmptool.config.sources({
				{ name = "nvim_lsp" }, -- Prioritize LSP
				{ name = "luasnip" }, -- Then snippets
				{ name = "buffer" }, -- Then text in file
				{ name = "path" }, -- Then file paths
			}),
		})

		-- 4. KEYBINDINGS (The Controls)
		-- This creates a "listener" that adds keys only when an LSP attaches to a buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }

				-- Press 'K' to see documentation
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- Press 'gd' to Go to Definition
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				-- Press '<leader>rn' to Rename variable everywhere
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				-- Press '<leader>ca' for Code Actions (quick fixes)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			end,
		})
	end,
}

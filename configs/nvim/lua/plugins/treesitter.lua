return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.9.2",
  build = ":TSUpdate", -- Command to run after installation
  opts = {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }, -- Languages to install
    highlight = {
      enable = true, -- Enable syntax highlighting
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true }, -- Enable indentation
  },
  config = function(_, opts)
    -- Call the setup function with the options
    require("nvim-treesitter.configs").setup(opts)
  end,
}


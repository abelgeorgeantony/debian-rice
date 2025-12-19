return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- dependencies: needed for the plugin to work (icon provider + treesitter)
  dependencies = { 
    'nvim-treesitter/nvim-treesitter', 
    'nvim-tree/nvim-web-devicons' -- This is the standard icon provider
  }, 
  -- opts = {} is equivalent to calling setup({}) with default settings
  opts = {}, 
}

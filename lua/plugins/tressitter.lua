return {
  {
    "p00f/nvim-ts-rainbow",
    config = function()
      require("nvim-treesitter.configs").setup {
        rainbow = {
          enable = true,
          extended_mode = true, -- Highlight also non-bracket delimiters like html tags
          max_file_lines = nil, -- Disable for files with more than n lines
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua", "javascript", "typescript", "python", "go", "html", "css",
          "bash", "json", "yaml", "markdown", "c", "cpp"
        },                                           -- Add your preferred languages
        highlight = {
          enable = true,                             -- Enable syntax highlighting
          additional_vim_regex_highlighting = false, -- Disable standard regex-based highlighting
        },
        indent = {
          enable = true, -- Enable tree-sitter-based indentation
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to the text object
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      }
    end,
  }
}

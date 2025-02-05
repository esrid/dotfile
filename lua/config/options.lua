-- Set the leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Basic settings
vim.opt.number = true         -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers
vim.opt.cursorline = true     -- Highlight the current line
vim.opt.autoindent = true     -- Enable auto-indentation
vim.opt.smartindent = true    -- Smarter indentation
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.tabstop = 2           -- Number of spaces for a tab
vim.opt.shiftwidth = 2        -- Number of spaces for auto-indent
-- vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.incsearch = true      -- Incremental search
vim.opt.ignorecase = true     -- Ignore case in search
vim.opt.smartcase = true      -- Override ignorecase if

vim.opt.swapfile = false
vim.opt.backup = false


vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'cc', '"*y"', { noremap = true, silent = true })

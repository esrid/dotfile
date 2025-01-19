return {
  "neovim/nvim-lspconfig",
  config = function()
    require('telescope').load_extension('ui-select')

    local builtin = require("telescope.builtin")

    require("telescope").load_extension("neoclip")

    vim.keymap.set(
      "n",
      "<leader>y",
      ":Telescope neoclip<CR>",
      { noremap = true, silent = true, desc = "View yank history" }
    )

    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)          -- Go to definition
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)     -- Go to type definition
      vim.keymap.set("n", "gr", builtin.lsp_references, opts)          -- Show references with Telescope
      vim.keymap.set("n", "rn", vim.lsp.buf.rename, opts)              -- Rename symbol
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions

      vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_prev, opts) -- Go to previous diagnostic
      vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_next, opts) -- Go to next diagnostic

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = false })
      end, opts)

      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end

      -- Add organize imports for Go files
      if client.name == "gopls" then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" } },
              apply = true,
            })
          end,
        })
      end
    end

    -- Lua Language Server setup
    require("lspconfig").lua_ls.setup({
      on_attach = on_attach, -- Attach keybindings and formatting on save
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
          end
        end

        -- Apply default Lua settings
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT", -- Neovim uses LuaJIT
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    -- Go Language Server setup
    require('lspconfig').clangd.setup {}

    require("lspconfig").gopls.setup({
      on_attach = on_attach, -- Attach keybindings and formatting on save
    })
  end,
}

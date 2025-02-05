return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Charge les extensions Telescope
    require('telescope').load_extension('ui-select')
    require("telescope").load_extension("neoclip")

    local builtin = require("telescope.builtin")

    vim.keymap.set(
      "n",
      "<leader>y",
      ":Telescope neoclip<CR>",
      { noremap = true, silent = true, desc = "View yank history" }
    )

    -- Fonction `on_attach` pour définir les raccourcis clavier LSP
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gr", builtin.lsp_references, opts)
      vim.keymap.set("n", "rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_next, opts)

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = false })
      end, opts)

      -- Formatage automatique avant la sauvegarde
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end
    end

    -- Configuration de `nvim-cmp` pour l'autocomplétion
    local cmp = require 'cmp'

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }),
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })

    -- Capabilities pour activer l'autocomplétion
    local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

    -- 📌 Configuration des serveurs LSP
    local lspconfig = require 'lspconfig'

    -- 🔹 Lua Language Server
    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = {
            globals = { 'vim' },
            disable = { 'lowercase-global' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          hint = { enable = true, arrayIndex = "Disable" },
        },
      },
    }

    -- 🔹 Go Language Server (gopls)
    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
            unusedwrite = true,
          },
          codelenses = {
            generate = true,
            test = true,
            tidy = true,
          },
        },
      }
    }

    -- 🔹 Python Language Server (pyright)
    lspconfig.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    }

    -- 🔹 Clangd (C/C++)
    lspconfig.clangd.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
}

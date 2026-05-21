return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme nightfox]])
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<leader>t", "<cmd>Neotree toggle left<cr>" },
      { "<leader>b", "<cmd>Neotree toggle buffers right<cr>" },
    },
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true
        }
      }
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "c3",
        "css",
        "eex",
        "elixir",
        "erlang",
        "heex",
        "html",
        "javascript",
        "lua",
        "python",
        "rust",
        "sql",
        "typescript",
      },
      sync_install = false,
      autotag = {
        enable = true,
        filetypes = { 'html', 'xml', 'heex', 'leex', 'eex' }
      },
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false
      }
    },
    config = function(_, opts)
      -- Add C3 parser configuration before setting up treesitter
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.c3 = {
        install_info = {
          url = "https://github.com/c3lang/tree-sitter-c3",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "main",
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
        filetype = "c3",
      }

      parser_config.lilypond = {
        install_info = {
          url = "/home/tristan/workspace/tree-sitter-lilypond/",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "lilypond",
      }

      require('nvim-treesitter.configs').setup(opts)
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>o", "<cmd>Telescope find_files<cr>" },
      { "<leader>a", "<cmd>Telescope live_grep<cr>" },
    },
    config = true
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy"
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = true
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig"
    },
    opts = function()
      local servers = {
        "expert",
        "ts_ls",
        "lua_ls",
        "pyright",
        "cssls",
        "jsonls",
        "yamlls",
      }

      local formatters_and_linters = {
        "prettier", -- JS/TS/JSON/YAML formatter
        "black",    -- Python formatter
        "isort",    -- Python import sorter
        "eslint_d", -- JS/TS linter (fast daemon version)
        "flake8",   -- Python linter
      }
      -- Combine servers and tools for Mason installation
      local all_tools = {}
      vim.list_extend(all_tools, servers)
      vim.list_extend(all_tools, formatters_and_linters)

      return {
        ensure_installed = servers,
        automatic_enable = servers,
      }
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Install additional formatters and linters via Mason
      local mason_registry = require("mason-registry")
      local formatters_and_linters = {
        "prettier", "black", "isort", "eslint_d", "flake8"
      }

      for _, tool in ipairs(formatters_and_linters) do
        local package = mason_registry.get_package(tool)
        if not package:is_installed() then
          package:install()
        end
      end

      -- Shared on_attach function for all LSP servers
      local on_attach = function(client, bufnr)
        -- Enable native LSP completion (Neovim 0.11+)
        if client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        -- Enable auto-format on save for supported servers
        if client:supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ timeout_ms = 2000 })
            end,
          })
        end
      end

      -- Configure standard LSP servers with shared on_attach
      local basic_servers = { "lua_ls", "cssls", "jsonls", "yamlls" }
      for _, server_name in ipairs(basic_servers) do
        vim.lsp.config(server_name, {
          on_attach = on_attach,
        })
        vim.lsp.enable(server_name)
      end

      -- TypeScript/JavaScript enhanced configuration
      vim.lsp.config("ts_ls", {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          -- TypeScript-specific keymaps
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>to", function()
            vim.lsp.buf.execute_command({
              command = "_typescript.organizeImports",
              arguments = { vim.api.nvim_buf_get_name(bufnr) }
            })
          end, opts)
          vim.keymap.set("n", "<leader>tr", function()
            vim.lsp.buf.execute_command({
              command = "_typescript.removeUnused",
              arguments = { vim.api.nvim_buf_get_name(bufnr) }
            })
          end, opts)
        end,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            }
          }
        }
      })

      -- Python enhanced configuration
      vim.lsp.config("pyright", {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          -- Python-specific keymaps
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>pt", function()
            vim.cmd("terminal python -m pytest")
          end, opts)
        end,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
            }
          }
        }
      })

      -- Configure Expert LSP with custom Elixir-specific functionality
      vim.lsp.config("expert", {
        on_attach = function(client, bufnr)
          -- Enable native LSP completion
          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
          end

          -- Disable LSP formatting for Expert (use mix format instead)
          client.server_capabilities.documentFormattingProvider = false

          -- Enable mix format on save for Elixir files
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              -- Check if we're in a Mix project
              if vim.fs.root(vim.api.nvim_buf_get_name(bufnr), { "mix.exs" }) then
                -- Get buffer content, format it, and replace buffer content
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                local content = table.concat(lines, '\n')

                -- Write content to temp file, format it, read it back
                local temp_file = vim.fn.tempname() .. '.ex'
                vim.fn.writefile(lines, temp_file)
                vim.fn.system("mix format " .. vim.fn.shellescape(temp_file))

                -- Read formatted content and update buffer
                local formatted_lines = vim.fn.readfile(temp_file)
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)

                -- Clean up temp file
                vim.fn.delete(temp_file)
              end
            end,
          })

          -- Elixir-specific keymaps
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>et", function()
            vim.cmd("terminal mix test")
          end, opts)
        end,
      })
    end
  },
}

return {
  {"EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme nightfox]])
    end
  },
  {"nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      {"<leader>t", "<cmd>Neotree toggle left<cr>"},
      {"<leader>b", "<cmd>Neotree toggle buffers right<cr>"},
    }
  },
  {"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bash",
          "c",
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
      })
    end
  },
  {"nvim-telescope/telescope.nvim",
    keys = {
      {"<leader>o", "<cmd>Telescope find_files<cr>"},
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
  {"folke/which-key.nvim",
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
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = true
  },
  {"hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    event = 'InsertEnter',
    opts = function()
      local cmp = require('cmp')
      return {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }
        })
      }
    end
  },
  {"mason-org/mason-lspconfig.nvim",
    dependencies = {
      {"mason-org/mason.nvim", opts = {}},
      "neovim/nvim-lspconfig"
    },
    config = function()
      -- for the list of LSP servers see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      local servers = {
        "elixirls",
        "ts_ls",
        "lua_ls",
        "pyright",
        "cssls",
      }

      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_enable = servers
      })
    end
  },
  {"ravitemer/mcphub.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require("mcphub").setup({
        cmd = 'node',
        cmdArgs = {'/home/tristan/sources/mcp-hub/src/utils/cli.js'}
      })
    end
  },
  {'olimorris/codecompanion.nvim',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('codecompanion').setup({
        strategies = { chat = { adapter = 'ollama' } },
        adapters = {
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              schema = { model = 'deepseek-r1:14b' }
            })
          end
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_results_in_chat = true,
              make_vars = true,
              make_slash_commands = true
            }
          }
        }
      })
    end
  },
}

return {
  {"EdenEast/nightfox.nvim"},
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
        highlight = {
          enable = true
        },
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
  {"neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
    end,
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      { "hrsh7th/cmp-nvim-lsp", opts = {} },
      {
        "williamboman/mason.nvim",
        cmd = {
          "Mason",
          "MasonInstall",
          "MasonUninstall",
          "MasonUninstallAll",
          "MasonLog",
        }, -- Package Manager
        dependencies = {
          { "williamboman/mason-lspconfig.nvim" },
          { "stevearc/dressing.nvim" },
        },
        config = function()
          local mason = require("mason")
          local mason_lspconfig = require("mason-lspconfig")
          local lspconfig = require("lspconfig")

          require("lspconfig.ui.windows").default_options.border = "rounded"


          mason.setup({
            ui = {
              -- Whether to automatically check for new versions when opening the :Mason window.
              check_outdated_packages_on_open = false,
              border = "single",
              icons = {
                package_installed = "",
                package_pending = "",
                package_uninstalled = "󰚌",
              },
            },
          })

          mason_lspconfig.setup_handlers({
            function(server_name)
              if server_name ~= "jdtls" then
                local opts = {}

                local require_ok, server = pcall(require, "plugins.lsp.settings." .. server_name)
                if require_ok then
                  opts = vim.tbl_deep_extend("force", server, opts)
                end

                lspconfig[server_name].setup(opts)
              end
            end,
          })
        end,
      },
    },
  }
}

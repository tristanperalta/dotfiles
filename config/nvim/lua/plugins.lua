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
  {"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    opts =  {
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
    },
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end
  },
  {"nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {"<leader>o", "<cmd>Telescope find_files<cr>"},
      {"<leader>a", "<cmd>Telescope live_grep<cr>"},
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
  {'saghen/blink.cmp',
    -- use a release tag to download pre-built binaries
    version = '1.*',
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {"mason-org/mason-lspconfig.nvim",
    dependencies = {
      {"mason-org/mason.nvim", opts = {}},
      "neovim/nvim-lspconfig"
    },
    opts = function()
      local servers = {
        "elixirls",
        "ts_ls",
        "lua_ls",
        "pyright",
        "cssls",
      }
      return {
        ensure_installed = servers,
        automatic_enable = servers,
      }
    end
  }
}

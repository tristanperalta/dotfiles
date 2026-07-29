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
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local TS = require('nvim-treesitter')

      -- Detect legacy master branch (still installed before first :Lazy sync).
      -- Skip main-branch setup; user should run :Lazy sync to pull main.
      if type(TS.install) ~= 'function' then
        vim.notify(
          'nvim-treesitter: legacy `master` branch still installed. Run :Lazy sync to switch to `main`.',
          vim.log.levels.WARN
        )
        return
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          local parsers = require('nvim-treesitter.parsers')
          parsers.c3 = {
            install_info = {
              url = 'https://github.com/c3lang/tree-sitter-c3',
              branch = 'main',
              queries = 'queries',
            },
          }
          -- Locally checked-out grammar; skip when it isn't present on this machine.
          local lilypond = vim.fs.normalize('~/workspace/tree-sitter-lilypond')
          if vim.uv.fs_stat(lilypond) then
            parsers.lilypond = {
              install_info = {
                path = lilypond,
                queries = 'queries',
              },
            }
          end
        end,
      })

      TS.setup()

      local ensure_installed = {
        'bash', 'c', 'c3', 'css', 'eex', 'elixir', 'erlang', 'heex',
        'html', 'javascript', 'lua', 'python', 'rust', 'sql', 'typescript',
      }

      local installed = TS.get_installed and TS.get_installed('parsers') or {}
      local have = {}
      for _, p in ipairs(installed) do have[p] = true end
      local missing = vim.tbl_filter(function(p) return not have[p] end, ensure_installed)
      if #missing > 0 then TS.install(missing) end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = ensure_installed,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
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

      return {
        ensure_installed = servers,
        automatic_enable = servers,
      }
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- mason-lspconfig's `automatic_enable` starts the servers; vim.lsp.config only
      -- merges settings onto the configs nvim-lspconfig already ships.
      vim.lsp.config("ts_ls", {
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

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
            }
          }
        }
      })

      -- Clients that format via an external tool rather than the LSP.
      local skip_lsp_format = { expert = true }

      -- Client-specific setup, run from the shared LspAttach below.
      local client_setup = {
        ts_ls = function(client, buf, kopts)
          local function exec(command)
            client:exec_cmd({
              command = command,
              arguments = { vim.api.nvim_buf_get_name(buf) },
            }, { bufnr = buf })
          end
          vim.keymap.set("n", "<leader>to", function() exec("_typescript.organizeImports") end, kopts)
          vim.keymap.set("n", "<leader>tr", function() exec("_typescript.removeUnused") end, kopts)
        end,

        pyright = function(_, _, kopts)
          vim.keymap.set("n", "<leader>pt", function()
            vim.cmd("terminal python -m pytest")
          end, kopts)
        end,

        expert = function(_, buf, kopts)
          -- Format Elixir with `mix format` instead of the LSP.
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buf,
            callback = function()
              if not vim.fs.root(vim.api.nvim_buf_get_name(buf), { "mix.exs" }) then
                return
              end

              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local temp_file = vim.fn.tempname() .. '.ex'
              vim.fn.writefile(lines, temp_file)
              vim.fn.system("mix format " .. vim.fn.shellescape(temp_file))
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(temp_file))
              vim.fn.delete(temp_file)
            end,
          })

          vim.keymap.set("n", "<leader>et", function()
            vim.cmd("terminal mix test")
          end, kopts)
        end,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          local buf = args.buf

          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
          end

          if skip_lsp_format[client.name] then
            client.server_capabilities.documentFormattingProvider = false
          elseif client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = buf,
              callback = function()
                vim.lsp.buf.format({ timeout_ms = 2000 })
              end,
            })
          end

          local setup = client_setup[client.name]
          if setup then
            setup(client, buf, { buffer = buf, silent = true })
          end
        end,
      })
    end
  },
}

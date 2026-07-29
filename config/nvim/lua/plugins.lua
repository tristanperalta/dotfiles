-- Plugins, managed by the built-in vim.pack (Neovim 0.12+).
-- Exact revisions live in nvim-pack-lock.json; update with :PackUpdate.

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Must be registered before the first vim.pack.add() or the install hook never fires.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind ~= 'delete' then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      pcall(function() require('nvim-treesitter').update() end)
    end
  end,
})

vim.pack.add({
  gh('EdenEast/nightfox.nvim'),

  -- Libraries, before their dependents.
  gh('nvim-lua/plenary.nvim'),
  gh('MunifTanjim/nui.nvim'),
  gh('nvim-tree/nvim-web-devicons'),

  { src = gh('nvim-neo-tree/neo-tree.nvim'), version = 'v3.x' },
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  gh('nvim-telescope/telescope.nvim'),
  gh('windwp/nvim-autopairs'),
  gh('nvim-lualine/lualine.nvim'),
  gh('kylechui/nvim-surround'),
  gh('folke/which-key.nvim'),
  gh('christoomey/vim-tmux-navigator'),
  gh('akinsho/bufferline.nvim'),

  -- mason.nvim must precede mason-lspconfig.nvim.
  gh('mason-org/mason.nvim'),
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason-lspconfig.nvim'),
})

-- Colorscheme ---------------------------------------------------------------

vim.cmd.colorscheme('nightfox')

-- Neo-tree ------------------------------------------------------------------

require('neo-tree').setup({
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
  },
})

vim.keymap.set('n', '<leader>t', '<cmd>Neotree toggle left<cr>', { desc = 'Toggle file tree' })
vim.keymap.set('n', '<leader>b', '<cmd>Neotree toggle buffers right<cr>', { desc = 'Toggle buffer list' })

-- Telescope -----------------------------------------------------------------

require('telescope').setup()

vim.keymap.set('n', '<leader>o', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>a', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })

-- Editing and UI ------------------------------------------------------------

require('nvim-autopairs').setup()
require('lualine').setup()
require('bufferline').setup()

-- nvim-surround, which-key and vim-tmux-navigator self-initialize via their
-- plugin/ files, so they need no setup() call here.

vim.keymap.set('n', '<c-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Navigate left' })
vim.keymap.set('n', '<c-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Navigate down' })
vim.keymap.set('n', '<c-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Navigate up' })
vim.keymap.set('n', '<c-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Navigate right' })
vim.keymap.set('n', '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', { desc = 'Navigate previous' })

-- Treesitter ----------------------------------------------------------------

local TS = require('nvim-treesitter')

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

-- LSP -----------------------------------------------------------------------

local servers = {
  'expert',
  'ts_ls',
  'lua_ls',
  'pyright',
  'cssls',
  'jsonls',
  'yamlls',
}

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
  automatic_enable = servers,
})

-- mason-lspconfig's `automatic_enable` starts the servers; vim.lsp.config only
-- merges settings onto the configs nvim-lspconfig already ships.
vim.lsp.config('ts_ls', {
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

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
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
    vim.keymap.set('n', '<leader>to', function() exec('_typescript.organizeImports') end, kopts)
    vim.keymap.set('n', '<leader>tr', function() exec('_typescript.removeUnused') end, kopts)
  end,

  pyright = function(_, _, kopts)
    vim.keymap.set('n', '<leader>pt', function()
      vim.cmd('terminal python -m pytest')
    end, kopts)
  end,

  expert = function(_, buf, kopts)
    -- Format Elixir with `mix format` instead of the LSP.
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = buf,
      callback = function()
        if not vim.fs.root(vim.api.nvim_buf_get_name(buf), { 'mix.exs' }) then
          return
        end

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local temp_file = vim.fn.tempname() .. '.ex'
        vim.fn.writefile(lines, temp_file)
        vim.fn.system('mix format ' .. vim.fn.shellescape(temp_file))
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(temp_file))
        vim.fn.delete(temp_file)
      end,
    })

    vim.keymap.set('n', '<leader>et', function()
      vim.cmd('terminal mix test')
    end, kopts)
  end,
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local buf = args.buf

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end

    if skip_lsp_format[client.name] then
      client.server_capabilities.documentFormattingProvider = false
    elseif client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
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

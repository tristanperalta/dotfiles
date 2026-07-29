-- Set before plugins load so plugin-defined mappings resolve correctly.
vim.g.mapleader = "-"
vim.g.maplocalleader = "--"

-- Plugins are managed by the built-in vim.pack; see lua/plugins.lua.
require("plugins")

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { desc = "Update plugins managed by vim.pack" })

-- Options
local options = {
  backup = false,
  number = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  mouse = "a",
  hlsearch = true,
  swapfile = false,
  history = 1000,
  completeopt = { "menuone", "noselect", "popup" },
  timeoutlen = 300,
  list = true,
  listchars = vim.opt.listchars:append({ eol = '↴', trail = '⋅', extends = '#'}),
  termguicolors = true
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Keymaps
local opts = { noremap = true, silent = false }

vim.keymap.set("n", "/", "/\\v", opts)
vim.keymap.set("v", "/", "/\\v", opts)

vim.keymap.set("", "<C-s>", ":w<cr>", opts)

vim.keymap.set("", "<leader><space>", ":nohl<cr>", opts)

-- buffer navigation
vim.keymap.set("", "<C-n>", ":bnext<cr>", opts)
vim.keymap.set("", "<C-p>", ":bprev<cr>", opts)
vim.keymap.set("", "<leader>d", ":bdel<cr>", opts)

-- LSP keymaps (applied globally)
-- Nvim maps gra/grn/grr/gri/grt/grx, K, gO and [d/]d by default; only the gaps are set here.
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ timeout_ms = 2000 }) end, { desc = 'Format buffer' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

vim.keymap.set('i', '<C-space>', function() vim.lsp.completion.get() end,
  { desc = 'Trigger LSP completion' })

-- Telescope LSP keymaps
vim.keymap.set('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>lS', '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', { desc = 'References' })
vim.keymap.set('n', '<leader>ld', '<cmd>Telescope diagnostics<cr>', { desc = 'Diagnostics' })

-- Enhanced diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = 'if_many',
  },
  float = {
    source = true,
    border = 'rounded',
  },
  -- The built-in [d/]d don't open a float the way the old goto_prev/goto_next did.
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor' })
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
  severity_sort = true,
  update_in_insert = false,
})

vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

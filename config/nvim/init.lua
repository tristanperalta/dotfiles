-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "-"
vim.g.maplocalleader = "--"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

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
  completeopt = { "menu", "menuone", "noselect" },
  timeoutlen = 300,
  list = true,
  listchars = vim.opt.listchars:append({ eol = '↴', trail = '⋅', extends = '#'}),
  termguicolors = true
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Keymaps
vim.g.mapleader = "-"

local keymap = vim.api.nvim_set_keymap
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
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ timeout_ms = 2000 }) end, { desc = 'Format buffer' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

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
    source = 'always',
    border = 'rounded',
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

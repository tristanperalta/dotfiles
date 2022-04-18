vim.g.mapleader = "-"

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "/", "/\\v", opts)
keymap("v", "/", "/\\v", opts)

-- buffer navigation
keymap("", "<C-n>", ":bnext<cr>", opts)
keymap("", "<C-p>", ":bprev<cr>", opts)
keymap("", "<leader>d", ":bdel<cr>", opts)

keymap("", "<C-s>", ":w<cr>", opts)


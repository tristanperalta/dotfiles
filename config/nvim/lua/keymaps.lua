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


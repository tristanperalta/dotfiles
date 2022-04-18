vim.g.mapleader = "-"

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = false }

keymap("n", "/", "/\\v", opts)
keymap("v", "/", "/\\v", opts)

keymap("", "<C-s>", ":w<cr>", opts)

keymap("", "<leader><space>", ":nohl<cr>", opts)

-- buffer navigation
keymap("", "<C-n>", ":bnext<cr>", opts)
keymap("", "<C-p>", ":bprev<cr>", opts)
keymap("", "<leader>d", ":bdel<cr>", opts)

-- telescope
keymap("n", "<leader>o", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>a", "<cmd>Telescope live_grep<cr>", opts)

-- nvim tree
keymap("n", "<leader>t", ":NvimTreeToggle<cr>", opts)

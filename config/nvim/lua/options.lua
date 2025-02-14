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

vim.cmd('colorscheme nightfox') 

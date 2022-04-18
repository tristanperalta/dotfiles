local options = {
  backup = false,
  number = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  smartindent = true,
  mouse = "a",
  hlsearch = true,
  swapfile = false,
  history = 1000
}

for k, v in pairs(options) do
  vim.opt[k] = v
end


require("mason").setup({})

-- list of available servers here 
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local servers = {
  "elixirls",
  "bashls",
  "cssls",
  "tsserver",
  "lua_ls",
  "pyright",
  "rust_analyzer"
}

require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true
})

local status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  return
end

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("lsp.handlers").on_attach,
    capabilities = require("lsp.handlers").capabilities
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "lsp.settings" .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end

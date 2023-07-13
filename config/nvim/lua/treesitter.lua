local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

treesitter.setup {
  ensure_installed = {"c", "lua", "elixir", "css", "typescript", "bash", "eex", "rust", "javascript", "python"},
  sync_install = false,
  autotag = { 
    enable = true,
    filetypes = { 'html', 'xml', 'heex', 'leex', 'eex' }
  },
  highlight = {
    enable = true
  },
  indent = { enable = true },
  context_commentstring = { 
    enable = true,
    enable_autocmd = false
  }
}

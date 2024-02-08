local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

treesitter.setup {
  ensure_installed = {
    "bash",
    "c",
    "css",
    "eex",
    "elixir",
    "erlang",
    "heex",
    "html",
    "javascript",
    "lua",
    "python",
    "rust",
    "typescript",
  },
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

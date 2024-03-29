local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return
end

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.rustywind.with({
      filetypes = { "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "html", "heex", "leex", "eex" }
    })
  }
}

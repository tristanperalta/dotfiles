local status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
  return
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  preselect = cmp.PreselectMode.Item,
  mappings = {
    ["C-o"] = cmp.mapping.select_next_item()
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }
  }),
  experimental = {
    ghost_text = true
  }
}


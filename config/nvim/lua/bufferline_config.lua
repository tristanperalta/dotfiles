local status_ok, bufferline = pcall(require, 'bufferline')
if not status_ok then
 return
end

bufferline.setup {
  options = {
    mode = "buffers",
    numbers = "none",
    close_command = "bdelete! %d",
    middle_mouse_command = "bdelete! %d",
    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    separator_style= 'slant'
  }
}

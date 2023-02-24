local tangle = require("markdown-literate.tangle")

local M = {}

M.remove_tangled = function()
  tangle.remove_tangled_files()
end

M.tangle = function()
  tangle.remove_tangled_files()
  tangle.tangle_file()
end

-- TODO: Ensure that LSP connects to the tmp buffer (is it doing it based on filename?)
M.edit_block = function()
  local original_buffer = vim.api.nvim_get_current_buf()
  local code = tangle.get_cursor_code_block()

  local edit_buffer = vim.api.nvim_call_function("bufnr", { '/tmp/[Block Edit]' })
  if edit_buffer ~= -1 then
    vim.api.nvim_buf_set_option(edit_buffer, "modifiable", true)
  else
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, '/tmp/[Block Edit]')
    edit_buffer = buf
  end
  tangle.set_edit_buffer_options(edit_buffer, code, original_buffer)
end

return M

-- TODO: implement a setup module to bind keymaps for the users configuration

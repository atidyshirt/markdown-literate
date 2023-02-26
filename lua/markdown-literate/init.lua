local tangle = require("markdown-literate.tangle")
local helpers = require("markdown-literate.helpers")

local M = {}

M.tangle = function()
  tangle.remove_tangled_files()
  tangle.tangle_file()
end

M.remove_tangled = function()
  tangle.remove_tangled_files()
end

M.edit_block = function()
  local original_buffer = vim.api.nvim_get_current_buf()
  local code = tangle.get_cursor_code_block()
  local edit_buffer = vim.api.nvim_call_function("bufnr", { '/tmp/[Block Edit]' })
  if edit_buffer == -1 then
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, '/tmp/[Block Edit]')
    edit_buffer = buf
  end
  vim.api.nvim_buf_set_option(edit_buffer, "modifiable", true)
  tangle.set_edit_buffer_options(edit_buffer, code, original_buffer, M.options.window_options)
end

local defaults = {
  window_options = {
    relative = "cursor",
    style = "minimal",
    border = "single",
    width = 80,
    height = 25,
    zindex = 10,
    bufpos = {0, 30},
    focusable = true,
    noautocmd = true
  },
  keybinds = {
    edit_block = "<leader>te",
    tangle_file = "<leader>tf",
    tangle_remove = "<leader>tu",
  }
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  helpers.map(M.options.keybinds.edit_block, ":lua require('markdown-literate').edit_block()<CR>", { silent = true })
  helpers.map(M.options.keybinds.tangle_file, ":lua require('markdown-literate').tangle()<CR>")
  helpers.map(M.options.keybinds.tangle_remove, ":lua require('markdown-literate').remove_tangled()<CR>")
end

M.setup()
return M

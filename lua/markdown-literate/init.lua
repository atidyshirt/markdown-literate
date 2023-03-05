local tangle = require("markdown-literate.tangle")
local helpers = require("markdown-literate.helpers")

local M = {}

M.tangle_workspace = function()
  local buffers = tangle.recursively_find_markdown_buffers()
  for _, buffer in ipairs(buffers) do
    tangle.remove_tangled_files(buffer)
  end
  for _, buffer in ipairs(buffers) do
    tangle.tangle_file(buffer)
  end
end

M.tangle = function()
    local buffer = vim.api.nvim_get_current_buf()
    tangle.remove_tangled_files(buffer)
    tangle.tangle_file(buffer)
end

M.remove_tangled = function()
  local buffer = vim.api.nvim_get_current_buf()
  tangle.remove_tangled_files(buffer)
end

M.edit_block = function()
  local success, _ = pcall(
    function()
      local original_buffer = vim.api.nvim_get_current_buf()
      local code = tangle.get_cursor_code_block(original_buffer)
      local edit_buffer = vim.api.nvim_call_function("bufnr", { '/tmp/[Block Edit]' })
      if edit_buffer == -1 then
        local buf = vim.api.nvim_create_buf(false, false)
        vim.api.nvim_buf_set_name(buf, '/tmp/[Block Edit]')
        edit_buffer = buf
      end
      vim.api.nvim_buf_set_option(edit_buffer, "modifiable", true)
      tangle.set_edit_buffer_options(edit_buffer, code, original_buffer, M.options.window_options)
    end
  )
  if not success then
    return
  end
end

local defaults = {
  window_options = {
    relative = "cursor",
    style = "minimal",
    border = "single",
    width = 80,
    height = 25,
    zindex = 10,
    bufpos = { 0, 30 },
    focusable = true,
    noautocmd = true
  },
  keybinds = {
    edit_block = "<leader>te",
    tangle_file = "<leader>tf",
    tangle_workspace = "<leader>tw",
    tangle_remove = "<leader>tu",
  }
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  helpers.map(M.options.keybinds.edit_block, ":lua require('markdown-literate').edit_block()<CR>", { silent = true })
  helpers.map(M.options.keybinds.tangle_file, ":lua require('markdown-literate').tangle()<CR>")
  helpers.map(M.options.keybinds.tangle_workspace, ":lua require('markdown-literate').tangle_workspace()<CR>")
  helpers.map(M.options.keybinds.tangle_remove, ":lua require('markdown-literate').remove_tangled()<CR>")
end

M.setup()
return M

local api = vim.api
local messages = require("markdown-literate.messages")

local Helpers = {}

Helpers.get_node_text = function(buffer, node)
  return vim.treesitter.query.get_node_text(node, buffer)
end

Helpers.get_fullpath = function(path)
  return vim.fn.resolve(api.nvim_eval('expand("%:p:h")') .. "/" .. path)
end

Helpers.get_root = function(buffer)
  local ts_parser = vim.treesitter.get_parser(buffer, "markdown")
  local root = ts_parser:parse()[1]:root()
  return root
end

Helpers.get_cursor_code_block = function(buffer, node)
  if node == nil then
    return messages.error_no_code_blocks()
  end
  if node:type() == "code_fence_content" then
    return Helpers.get_node_text(buffer, node)
  else
    return Helpers.get_cursor_code_block(node:parent())
  end
end

Helpers.get_cursor_info_string = function(buffer, node)
  if node == nil then
    return ""
  end
  if node:type() == "fenced_code_block" then
    return Helpers.get_node_text(buffer, node:child(1))
  else
    return Helpers.get_cursor_info_string(buffer, node:parent())
  end
end

Helpers.remove_files = function(filepath)
  os.remove(filepath)
end

Helpers.process_filepath = function(filepath)
  if string.sub(filepath, 1, 2) == "./" then
    filepath = string.sub(filepath, 3)
  end
  return filepath
end

Helpers.create_file = function(filepath)
  os.execute(string.format('mkdir -p "$(dirname %s)"', filepath))
  os.execute(string.format("touch %s", filepath))
end

Helpers.tangle_code_blocks = function(code_block)
  code_block.file:write(code_block.code .. "\n\n")
end

Helpers.cursorToTop = function()
  local init = api.nvim_win_get_cursor(0)
  api.nvim_win_set_cursor(0, { 1, 0 })
  local first = api.nvim_get_current_line()
  return init, first
end

Helpers.process_language_from_info_string = function(info_string)
  return string.gsub(info_string, "%s*(%w+).*", "%1")
end

Helpers.process_filepath_from_info_string = function(info_string)
  return string.gsub(info_string, ".*%s*{%s*tangle:%s+([%w|.|/|_]+)%s*}.*$", "%1")
end

Helpers.map = function(keybind, command, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap("n", keybind, command, options)
end

Helpers.open_file_return_buffer_id = function(filename)
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {}
  for line in io.lines(filename) do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.cmd("edit! " .. vim.fn.fnameescape(filename))
  return buf
end

return Helpers

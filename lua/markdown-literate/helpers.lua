local api = vim.api

local Helpers = {}

Helpers.get_node_text = function (node)
  return vim.treesitter.query.get_node_text(
    node, vim.api.nvim_get_current_buf()
  )
end

Helpers.get_fullpath = function(path)
  return api.nvim_eval('expand("%:p:h")') .. "/" .. path
end

Helpers.get_root = function ()
    local buffer = vim.api.nvim_get_current_buf()
    local ts_parser = vim.treesitter.get_parser(buffer, "markdown")
    local root = ts_parser:parse()[1]:root()
    return root
end

Helpers.remove_files = function (filepath)
  os.execute(string.format('rm -r %s', filepath))
end


Helpers.create_file = function (filepath)
  os.execute(string.format('mkdir -p "$(dirname %s)"', filepath))
  os.execute(string.format('touch %s', filepath))
end

Helpers.tangle_code_blocks = function (code_block)
  os.execute(string.format("echo '%s\n' >> %s", code_block.code, code_block.filepath))
end

Helpers.cursorToTop = function ()
  local init = api.nvim_win_get_cursor(0)
  api.nvim_win_set_cursor(0, {1, 0})
  local first = api.nvim_get_current_line()
  return init, first
end

Helpers.tangleEntireFile = function (firstline)
  return string.match(firstline, '<.-- tangle: .* -->')
end

return Helpers

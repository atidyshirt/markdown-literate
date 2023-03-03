local helpers = require("markdown-literate.helpers")
local messages = require("markdown-literate.messages")
local utils = require("nvim-treesitter.ts_utils")

local Tangle = {}

local function lines(str)
  local result = {}
  for line in (str .. '\n'):gmatch '([^\n]*)\n' do
    table.insert(result, line)
  end
  return result
end

Tangle.recursively_find_markdown_buffers = function ()
  local files = vim.fn.globpath(vim.fn.getcwd(), '**/*.md', true, true)
  local buf_ids = {}
  for _, file in ipairs(files) do
    local buf_id = helpers.open_file_return_buffer_id(file)
    if buf_id >= 0 then
      table.insert(buf_ids, buf_id)
    end
  end
  return buf_ids
end

Tangle.get_cursor_code_block = function (buffer)
  local code_block = {
    info_string = helpers.get_cursor_info_string(
      buffer,
      utils.get_node_at_cursor(0, true)
    ),
    code_block = lines(
      helpers.get_cursor_code_block(
        buffer,
        utils.get_node_at_cursor(0, true)
      )
    ),
    language = helpers.process_language_from_info_string(
      helpers.get_cursor_info_string(
        buffer,
        utils.get_node_at_cursor(0, true)
      )
    ),
    start_line = utils.get_node_at_cursor(0, true):start(),
    end_line = utils.get_node_at_cursor(0, true):end_()
  }
  return code_block
end

Tangle.set_edit_buffer_options = function (edit_buffer, code, original_buffer, window_options)
  vim.api.nvim_buf_set_option(edit_buffer, 'filetype', code.language)
  vim.api.nvim_buf_set_option(edit_buffer, 'swapfile', false)
  vim.api.nvim_buf_set_lines(edit_buffer, 0, -1, true, code.code_block)
  vim.api.nvim_open_win(edit_buffer, true, window_options)
  vim.api.nvim_command(
    string.format(
      'autocmd! * <buffer=%s>', edit_buffer
    )
  )
  vim.api.nvim_command(
    string.format(
      [[
      autocmd BufWritePost <buffer=%s> 
      :silent! execute 'lua vim.api.nvim_buf_set_lines(%s, %s, %s, true, vim.api.nvim_buf_get_lines(%s, 0, -1, true))' 
      | :silent! bdelete"
      ]],
      edit_buffer, original_buffer, code.start_line, code.end_line, edit_buffer
    )
  )
end

Tangle.get_code_blocks = function (buffer)
  local current_code_block = {}
  local all_code_blocks = {}
  local root = helpers.get_root(buffer)
  local query = vim.treesitter.parse_query('markdown',
    [[(
      (info_string)? @code_block
      (code_fence_content) @info_string
    )]])
  for _, node, _ in query:iter_captures(root, 0) do
    if node:type() == "code_fence_content" then
      current_code_block.code = helpers.get_node_text(buffer, node)
      table.insert(all_code_blocks, current_code_block)
      current_code_block = {}
    end
    if node:type() == "info_string" then
      local info_string = helpers.get_node_text(buffer, node)
      current_code_block.language = helpers.process_language_from_info_string(info_string)
      current_code_block.filepath = helpers.process_filepath_from_info_string(info_string)
    end
  end
  return all_code_blocks
end

Tangle.remove_tangled_files = function(buffer)
  local all_code_blocks = Tangle.get_code_blocks(buffer)
  for _, code_block in pairs(all_code_blocks) do
    if code_block.filepath and code_block.filepath ~= code_block.language then
      code_block.filepath = helpers.process_filepath(buffer, code_block.filepath)
      helpers.remove_files(
          code_block.filepath
      )
    end
  end
end

Tangle.tangle_file = function(buffer)
  local all_code_blocks = Tangle.get_code_blocks(buffer)
  for _, code_block in pairs(all_code_blocks) do
    code_block.filepath = helpers.process_filepath(buffer, code_block.filepath)
    helpers.create_file(
      code_block.filepath
    )
    code_block.file = io.open(code_block.filepath, "a")
  end
  local counter = 0
  for _, code_block in pairs(all_code_blocks) do
    if code_block.filepath and code_block.filepath ~= code_block.language then
      helpers.tangle_code_blocks(code_block)
      messages.store_message_info(code_block)
      counter = counter + 1
    end
  end
  for _, code_block in pairs(all_code_blocks) do
    code_block.file:close()
  end
  if counter == 0 then
    messages.display_undefined_message()
  else
    messages.display_final_messages()
  end
  messages.store = {}
end

return Tangle

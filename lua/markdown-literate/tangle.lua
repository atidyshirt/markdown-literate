local helpers = require("markdown-literate.helpers")
local messages = require("markdown-literate.messages")

local Tangle = {}

Tangle.get_code_blocks = function ()
  local current_code_block = {}
  local all_code_blocks = {}
  local root = helpers.get_root()
  local query = vim.treesitter.parse_query('markdown',
    [[(
      (info_string)? @code_block
      (code_fence_content) @info_string
    )]])
  for _, node, _ in query:iter_captures(root, 0) do
    if node:type() == "code_fence_content" then
      current_code_block.code = helpers.get_node_text(node)
      table.insert(all_code_blocks, current_code_block)
      current_code_block = {}
    end
    if node:type() == "info_string" then
      local info_string = helpers.get_node_text(node)
      current_code_block.language = string.gsub(info_string, '(%w[%w|.]+)%s*.*', '%1')
      current_code_block.filepath = string.gsub(info_string, '.*%s*{%s*tangle:%s+([%w|.|/|_]+)%s*}.*$', '%1')
    end
  end
  return all_code_blocks
end

Tangle.remove_tangled_files = function()
  local all_code_blocks = Tangle.get_code_blocks()
  for _, code_block in pairs(all_code_blocks) do
    if code_block.filepath and code_block.filepath ~= code_block.language then
      helpers.remove_files(
        code_block.filepath
      )
    end
  end
end

Tangle.tangle_file = function()
  local all_code_blocks = Tangle.get_code_blocks()
  local counter = 0
  for _, code_block in pairs(all_code_blocks) do
    if code_block.filepath and code_block.filepath ~= code_block.language then
      helpers.create_file(
        code_block.filepath
      )
      helpers.tangle_code_blocks(code_block)
      messages.store_message_info(code_block)
      counter = counter + 1
    end
  end
  if counter == 0 then
    messages.display_undefined_message()
  else
    messages.display_final_messages()
  end
  messages.store = {}
end

return Tangle

local tangle = require("markdown-literate.tangle")

local M = {}

M.remove_tangled = function()
  tangle.remove_tangled_files()
end

M.tangle = function()
  tangle.remove_tangled_files()
  tangle.tangle_file()
end

return M

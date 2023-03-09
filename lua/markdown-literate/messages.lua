local Messages = {}

Messages.store = {}

Messages.error_no_code_blocks = function()
	vim.api.nvim_command("echohl WarningMsg")
	vim.api.nvim_command('echon "ERROR: Couldn\'t edit code block. Cursor must be inside a code block!"')
	vim.api.nvim_command("echohl Normal")
end

Messages.display_undefined_message = function()
	vim.api.nvim_command("echohl WarningMsg")
	vim.api.nvim_command(
		string.format('echon "ERROR: Couldn\'t tangle code blocks. No tangled code blocks in %s!"', vim.fn.expand("%"))
	)
	vim.api.nvim_command("echohl Normal")
end

Messages.display_success_message = function(message)
	vim.api.nvim_command(
		'unsilent echon "Tangled '
			.. message.num_code_blocks
			.. " code "
			.. (message.num_code_blocks > 1 and "blocks" or "block")
			.. ' to `"'
	)
	vim.api.nvim_command("echohl Identifier")
	vim.api.nvim_command('unsilent echon "' .. message.filepath .. '"')
	vim.api.nvim_command("echohl Normal")
	vim.api.nvim_command('unsilent echon "`\n"')
end

Messages.display_final_messages = function()
	for _, m in pairs(Messages.store) do
		Messages.display_success_message(m)
	end
	return true
end

Messages.store_message_info = function(code_block)
	local in_store = false
	if code_block.filepath then
		for _, m in pairs(Messages.store) do
			if m.filepath == code_block.filepath then
				m.num_code_blocks = m.num_code_blocks + 1
				in_store = true
			end
		end
		if in_store ~= true then
			table.insert(Messages.store, {
				num_code_blocks = 1,
				filepath = code_block.filepath,
			})
		end
	end
end

return Messages

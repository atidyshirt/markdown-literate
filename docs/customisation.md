## Customisation

To overwrite/customise the window decorations for the edit buffer, or to change
the default keymaps, you can use the following syntax when instantiating the
lua plugin with `packer.nvim`.

Here is an example of a custom config that uses the default configuration, to
change these settings, just override the provided configuration variables. If
you would like more functionality to change, please submit a PR or raise an issue
to let me know!

```lua
use({
	"atidyshirt/markdown-literate",
	config = function()
		require("markdown-literate").setup({
			window_options = {
				relative = "cursor",
				style = "minimal",
				border = "single",
				width = 80,
				height = 25,
				zindex = 10,
				bufpos = { 0, 30 },
				focusable = true,
				noautocmd = true,
			},
			keybinds = {
				edit_block = "<leader>te",
				tangle_file = "<leader>tf",
				tangle_workspace = "<leader>tw",
				tangle_remove = "<leader>tu",
			},
		})
	end,
})
```

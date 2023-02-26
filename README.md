# markdown-literate

**EARLY STAGES PLUGIN:** please use with care, as this is very early stages and should not be used for everyday workflow just yet.

**Scope for this project:**

This plugin in combination with the [marksman](https://github.com/artempyanykh/marksman) plugin for [Neovim LSP](https://github.com/neovim/nvim-lspconfig)
is intended to be a full experience to be able to write full literate programs spanning over multiple files and directories.

### Initial targets to implement

- [x] Tangle markdown codeblocks on a per-codeblock basis
    * The expected syntax for doing this is as follows: `<language> { tangle: path/to/file.lang }`.
    * The above syntax should be used at the start of the node.
- [x] Remove/untangle all tangled files in the project
    * [x] For a full project scope/directory
- [x] Edit a code block with its native LSP in a new buffer or popup window.
    * [x] Implement customised options for the user to use window decorations, window position
- [x] Setup custom keymaps for each of the events.
    * [x] Integrate a configuration for this rather then calling functions directly
- [ ] Tangle multiple markdown files that are found under a project.
    * Should find all markdown files in the directory, using some identifier as the `root` dir
- [ ] Ability to tangle an entire `*.md` file to a single document without specifying files
    * Should check if all code blocks are the same language,
    * Create a `target` directory of all source files using the `*.md` as the base name for the file

### Usage

Installing with packer.nvim and using the defualt keybindings, see [Setup and Customisation](./docs/customisation.md)
to setup your own keymaps for this plugin.

```
use {
  "atidyshirt/markdown-literate",
  config = function()
    require("markdown-literate").setup()
  end
}
```

The default keymaps are as follows:

| Keymap         | Purpose                           |
| -------------- | --------------------------------- |
| `<leader>tf`   | Tangle the current markdown file  |
| `<leader>tu`   | Undo/remove all tangled files     |
| `<leader>te`   | Edit a code block using LSP       |

### Current Issues

- Currently the first time you write to the edit buffer, you will need to force write using `:w!`, this is an issue to fix in the future.
- Currently we cannot tangle all markdown files in a directory (comming soon)
- Currently we must specify tangle locations (see the goals of this plugin)

### Documentation

- [Setup and Customisation](./docs/customisation.md)
- [Example of code block syntax]

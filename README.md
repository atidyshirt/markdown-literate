# markdown-literate

**EARLY STAGES PLUGIN:** please use with care, as this is very early stages and should not be used for everyday workflow just yet.

**Scope for this project:**

This plugin in combination with the [marksman](https://github.com/artempyanykh/marksman) plugin for [Neovim LSP](https://github.com/neovim/nvim-lspconfig)
is intended to be a full experience to be able to write full litterate programs spanning over multiple files and directories.

### Initial targets to implement

- [x] Tangle markdown codeblocks on a per-codeblock basis
    * The expected syntax for doing this is as follows: `<language> { tangle: path/to/file.lang }`.
    * The above syntax should be used at the start of the node.
- [ ] Tangle multiple markdown files that are found under a project.
- [x] Remove/untangle all tangled files in the project
    * [x] For a single markdown file
    * [ ] For a full project scope/directory
- [x] Edit a code block with its native LSP in a new buffer or popup window.
- [x] Setup custom keymaps for each of the events.
    * [ ] Integrate a configuration for this rather then calling functions directly
- [ ] Ability to tangle an entire `*.md` file to a single document.
    * Not sure exactly what the syntax may look like, but it would be nice to have the option to tangle without specifying the file for every code block.
    * Perhaps using metadata for the `*.md` file might be an option.

### Usage

Installing with packer.nvim:

```
use ('atidyshirt/markdown-literate')
```

Calling functions to tangle and remove tangled files from the directory

```
:lua require('markdown-literate').tangle() => tangles all code blocks with { tangle: file.py }
:lua require('markdown-literate').remove_tangled() => removes all tangled files from codeblocks
:lua require('markdown-literate').edit_block() => edit a specified codeblock
```

### Documentation

- [Setup and Customisation](./docs/customisation.md)

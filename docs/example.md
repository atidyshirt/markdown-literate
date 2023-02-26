# Example of Markdown Tangle Code Block Syntax

In order to tangle code blocks in a markdown file, we must supply it with a destination.
The current implementation is to attach a destination in the markdown file using the following
syntax `{ tangle: ./path/to/filename.py }`. `markdown-tangle` will evaluate and create the path
and replace the text in the location file.

Here is an example of how this works in practice, **please view this file as a raw markdown file to
see the required syntax in usage.**

```lua { tangle: ./target/plugins/init.lua }
use {
  "atidyshirt/markdown-literate",
  config = function()
    require("markdown-literate").setup()
  end
}
```

-- Toggle browser markdown preview with <leader>mp. Replaces the lang.markdown
-- extra's default <leader>cp key, which shadowed the global path-copy keymap
-- in markdown buffers.
return {
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      { "<leader>cp", false, ft = "markdown" },
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    },
  },
}

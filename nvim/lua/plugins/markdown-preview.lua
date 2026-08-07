-- Toggle browser markdown preview with <leader>mp. Replaces the lang.markdown
-- extra's default <leader>cp key, which shadowed the global path-copy keymap
-- in markdown buffers.
return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      -- By default the preview closes the moment you leave the markdown
      -- buffer (explorer, terminal, another file). Keep it open until
      -- toggled off explicitly.
      vim.g.mkdp_auto_close = 0
    end,
    keys = {
      { "<leader>cp", false, ft = "markdown" },
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    },
  },
}

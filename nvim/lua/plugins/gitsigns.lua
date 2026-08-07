-- Show git blame (author, date, commit summary) for the current line as virtual text
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  },
  keys = {
    { "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle line blame" },
  },
}

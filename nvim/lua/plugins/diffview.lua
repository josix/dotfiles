-- Full side-by-side diff view for the whole working tree.
-- <leader>gv toggles it; <leader>gd keeps LazyVim's default hunk picker.
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gv",
      function()
        local lib = require("diffview.lib")
        if lib.get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Git diff view (toggle)",
    },
    { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (diff view)" },
  },
  opts = {},
}

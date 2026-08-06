return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup()

      -- mini.map floats over the right-side Claude split; hide it while the
      -- Claude window is visible and restore it afterwards. Snacks opens the
      -- window with a scratch buffer before starting the terminal, so instead
      -- of matching individual events we re-check the whole layout (deferred,
      -- after the buffer is fully formed) on any event that can change it.
      local function claude_visible()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if
            vim.bo[buf].buftype == "terminal"
            and vim.api.nvim_buf_get_name(buf):lower():find("claude", 1, true)
          then
            return true
          end
        end
        return false
      end

      local minimap_hidden_by_claude = false
      local function sync_minimap()
        local ok, MiniMap = pcall(require, "mini.map")
        if not ok then return end
        if claude_visible() then
          if next(MiniMap.current.win_data or {}) ~= nil then
            minimap_hidden_by_claude = true
            MiniMap.close()
          end
        elseif minimap_hidden_by_claude then
          minimap_hidden_by_claude = false
          MiniMap.open()
        end
      end

      vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter", "WinNew", "WinClosed" }, {
        group = vim.api.nvim_create_augroup("ClaudeCodeMinimap", { clear = true }),
        callback = function()
          vim.schedule(sync_minimap)
        end,
      })
    end,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
    },
  },
}

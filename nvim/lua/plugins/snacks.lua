return {
  {
    "folke/snacks.nvim",
    init = function()
      -- Dim code outside the current scope by default (<leader>uD toggles).
      -- Deferred to VeryLazy: this can't run inline since setup hasn't
      -- happened yet, and config.autocmds loads too early for it too.
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          Snacks.dim()
        end,
      })
    end,
    opts = {
      picker = {
        sources = {
          files = { hidden = true, ignored = true },
          explorer = {
            hidden = true,
            ignored = true,
            -- "o" opens with the system app (VS Code) by default; open in nvim instead
            win = {
              list = {
                keys = {
                  ["o"] = "confirm",
                },
              },
            },
          },
        },
      },
    },
  },
}

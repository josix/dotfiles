return {
  {
    "folke/snacks.nvim",
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

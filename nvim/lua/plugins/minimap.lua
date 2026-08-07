-- Lightweight minimap on the right edge, like VSCode's. Toggle with <leader>mm.
return {
  {
    "nvim-mini/mini.map",
    keys = {
      { "<leader>mm", function() require("mini.map").toggle() end, desc = "Toggle minimap" },
      { "<leader>mf", function() require("mini.map").toggle_focus() end, desc = "Focus minimap" },
    },
    event = "VeryLazy",
    config = function()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
          map.gen_integration.gitsigns(),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("4x2"),
        },
        window = {
          width = 12,
          winblend = 25,
          show_integration_count = false,
        },
      })
    end,
  },
}

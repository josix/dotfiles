-- Explicit zenburn-flavored lualine theme. The default "auto" theme derives its
-- colors from zenburn's StatusLine highlights, which yields light text on the
-- pale-green segments and poor contrast.
local colors = {
  black = "#2b2b2b",
  dark = "#383838",
  gray = "#4f4f4f",
  fg = "#dcdccc",
  dim = "#9f9f8f",
  green = "#7f9f7f",
  yellow = "#f0dfaf",
  blue = "#8cd0d3",
  red = "#cc9393",
  purple = "#dc8cc3",
}

local function mode(accent)
  return {
    a = { fg = colors.black, bg = accent, gui = "bold" },
    b = { fg = colors.fg, bg = colors.gray },
    c = { fg = colors.dim, bg = colors.dark },
  }
end

local zenburn_theme = {
  normal = mode(colors.green),
  insert = mode(colors.yellow),
  visual = mode(colors.blue),
  replace = mode(colors.red),
  command = mode(colors.purple),
  terminal = mode(colors.blue),
  inactive = {
    a = { fg = colors.dim, bg = colors.dark },
    b = { fg = colors.dim, bg = colors.dark },
    c = { fg = colors.dim, bg = colors.dark },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = zenburn_theme
    end,
  },
}

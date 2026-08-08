-- Zenburn, matching the VSCode theme. Delete this file to fall back to tokyonight.
-- Zenburn paints StatusLine/StatusLineNC light green (#ccdc90/#88b090), which
-- bleeds through wherever lualine's highlights don't apply. Re-set them to
-- dark whenever the colorscheme (re)loads.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    if not (vim.g.colors_name or ""):find("zenburn") then
      return
    end
    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#dcdccc", bg = "#383838" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#9f9f8f", bg = "#2f2f2f" })
  end,
})

return {
  { "phha/zenburn.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "zenburn",
    },
  },
}

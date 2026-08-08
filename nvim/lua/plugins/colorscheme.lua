-- Zenburn, matching the VSCode theme. Delete this file to fall back to tokyonight.
-- Zenburn paints StatusLine/StatusLineNC light green (#ccdc90/#88b090), which
-- bleeds through wherever lualine's highlights don't apply, and gives the
-- LSP reference groups (symbol under cursor) a yellow background that washes
-- out the light text. Re-set them to dark whenever the colorscheme (re)loads.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    if not (vim.g.colors_name or ""):find("zenburn") then
      return
    end
    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#dcdccc", bg = "#383838" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#9f9f8f", bg = "#2f2f2f" })
    -- Muted zenburn yellow with forced dark text: a yellow bg bright enough to
    -- notice can't stay readable under zenburn's own yellowish syntax colors,
    -- so swap to dark fg (9.2:1 contrast), one step softer than IncSearch.
    local word_hl = { fg = "#2b2b2b", bg = "#e0cf9f", bold = true }
    vim.api.nvim_set_hl(0, "LspReferenceText", word_hl)
    vim.api.nvim_set_hl(0, "LspReferenceRead", word_hl)
    vim.api.nvim_set_hl(0, "LspReferenceWrite", word_hl)
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

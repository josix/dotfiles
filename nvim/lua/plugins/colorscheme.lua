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
    -- Gitsigns hunk preview (<leader>ghp): the added/removed regions inherit
    -- zenburn's Diff* backgrounds, which barely differ from the #3f3f3f
    -- editor bg. Give the line tints a clear step up and the word-level
    -- marks a much stronger one.
    vim.api.nvim_set_hl(0, "GitSignsAddPreview", { bg = "#33502f" })
    vim.api.nvim_set_hl(0, "GitSignsDeletePreview", { fg = "#cc9393", bg = "#502f2f" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLn", { fg = "#cc9393", bg = "#502f2f" })
    vim.api.nvim_set_hl(0, "GitSignsAddLnInline", { bg = "#4f7a4f", bold = true })
    vim.api.nvim_set_hl(0, "GitSignsChangeLnInline", { fg = "#1f1f1f", bg = "#7a7a45", bold = true })
    vim.api.nvim_set_hl(0, "GitSignsDeleteLnInline", { bg = "#7a4a4a", bold = true })
    vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLnInLine", { bg = "#7a4a4a", bold = true })
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

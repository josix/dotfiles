-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Auto-center after any big vertical jump (}/{, n/N, gg/G, flash, jumplist, ...)
-- Small movements (j/k, short hops) are left alone so the view stays stable.
vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("auto_center_jumps", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "n" then
      return
    end
    local line = vim.fn.line(".")
    local last = vim.w.auto_center_last_line
    vim.w.auto_center_last_line = line
    if last and math.abs(line - last) > 5 then
      vim.cmd("normal! zz")
    end
  end,
})

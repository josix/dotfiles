-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jj to leave insert mode (ported from VSCode vim.insertModeKeyBindings)
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

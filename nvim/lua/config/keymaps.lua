-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jj to leave insert mode (ported from VSCode vim.insertModeKeyBindings)
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Option+Left/Right word movement in insert mode — kitty sends Esc b / Esc f
-- (see kitty.conf alt+left/right), which nvim receives as <M-b>/<M-f>
vim.keymap.set("i", "<M-b>", "<C-o>b", { desc = "Move back one word" })
vim.keymap.set("i", "<M-f>", "<C-o>e<Right>", { desc = "Move forward one word" })

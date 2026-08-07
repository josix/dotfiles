-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jj to leave insert mode (ported from VSCode vim.insertModeKeyBindings)
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Leave terminal mode. <C-\><C-n> is risky here (a stray Ctrl+\ is SIGQUIT to
-- the shell) and snacks' double-Esc passes the first Esc to the running TUI,
-- which interrupts Claude Code — so use a key no terminal app wants.
vim.keymap.set("t", "<C-]>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- kitty's macos_option_as_alt sends Option+Delete as Alt+Backspace, which
-- nvim ignores by default — make it delete a word like everywhere else on mac
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" })
vim.keymap.set("c", "<M-BS>", "<C-w>", { desc = "Delete word backward" })

-- Copy the current file's absolute path to the system clipboard
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })
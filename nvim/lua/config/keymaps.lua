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

-- Focus mode: centered cursor + dim outside current scope (both are on by
-- default via options.lua/snacks.lua); toggle off to get a normal edit flow
Snacks.toggle({
  name = "Focus Mode",
  get = function()
    return vim.o.scrolloff == 999
  end,
  set = function(state)
    vim.o.scrolloff = state and 999 or 4
    if state then
      Snacks.dim()
    else
      Snacks.dim.disable()
    end
  end,
}):map("<leader>uo")

-- One-keystroke buffer close, Cmd+W style (kitty sends Option+w as Alt+w).
-- Snacks.bufdelete keeps the window layout intact, unlike :bdelete which
-- also closes the split
vim.keymap.set("n", "<M-w>", function()
  Snacks.bufdelete()
end, { desc = "Close buffer" })

-- Option+1..9 jumps straight to the Nth buffer as displayed in the bufferline,
-- so the number always matches what the tab bar shows
for i = 1, 9 do
  vim.keymap.set("n", "<M-" .. i .. ">", function()
    require("bufferline").go_to(i, true)
  end, { desc = "Go to buffer " .. i })
end

-- Copy the current file's absolute path to the system clipboard
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })
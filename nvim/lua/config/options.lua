-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Absolute line numbers only (LazyVim enables relativenumber by default)
vim.opt.relativenumber = false

-- Disable all snacks.nvim animations (smooth scroll, resize, etc.)
vim.g.snacks_animate = false

-- Show whitespace (ported from VSCode editor.renderWhitespace)
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Put the newest nvm-installed node on PATH: the shell lazy-loads nvm, so
-- child processes like Mason's npm installs would otherwise miss it
local nvm_node_dir = vim.fn.expand("~/.nvm/versions/node")
if vim.fn.isdirectory(nvm_node_dir) == 1 then
  local versions = vim.fn.readdir(nvm_node_dir)
  table.sort(versions, function(a, b)
    return vim.version.lt(vim.version.parse(a) or {}, vim.version.parse(b) or {})
  end)
  local newest = versions[#versions]
  if newest then
    local bin = nvm_node_dir .. "/" .. newest .. "/bin"
    if not vim.env.PATH:find(bin, 1, true) then
      vim.env.PATH = bin .. ":" .. vim.env.PATH
    end
  end
end

-- Center the cursor line after treesitter move motions (]f/[f, ]c/[c, ]a/[a, ...)
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  opts = function(_, opts)
    local move = require("nvim-treesitter-textobjects.move")
    for _, method in ipairs({ "goto_next_start", "goto_next_end", "goto_previous_start", "goto_previous_end" }) do
      local orig = move[method]
      move[method] = function(...)
        orig(...)
        vim.cmd("normal! zz")
      end
    end
    return opts
  end,
}

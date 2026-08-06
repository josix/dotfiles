return {
  -- Disable markdownlint (from the lang.markdown extra); keeps marksman LSP etc.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      if opts.linters_by_ft then
        opts.linters_by_ft.markdown = nil
      end
    end,
  },
}

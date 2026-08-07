return {
  "folke/trouble.nvim",
  init = function()
    -- Auto-open the symbols outline once the first symbol-capable LSP attaches.
    -- (Opening earlier, e.g. on VeryLazy, silently fails: no documentSymbol provider yet.)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not (client and client:supports_method("textDocument/documentSymbol")) then
          return
        end
        vim.defer_fn(function()
          require("trouble").open({ mode = "symbols", focus = false })
        end, 100)
        return true -- run once, then remove this autocmd
      end,
    })
  end,
  opts = {
    modes = {
      symbols = {
        win = { size = { width = 50 } },
      },
    },
  },
}

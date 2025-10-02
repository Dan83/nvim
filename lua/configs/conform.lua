local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    css = { "prettier" },
    html = { "prettier" },
  },

  format_on_save = function(bufnr)
    local filetype = vim.bo[bufnr].filetype
    if filetype == "python" then
      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end
    return false
  end,
}

return options

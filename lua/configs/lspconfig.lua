require("nvchad.configs.lspconfig").defaults()

-- Rende disponibili gli eseguibili installati da Mason (clangd, zls, ...)
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
if vim.uv.fs_stat(mason_bin) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local servers = { "html", "cssls", "pyright", "ruff", "zls", "clangd" }

-- clangd: abilita i diagnostici e i flag extra per C/C++
vim.lsp.config("clangd", {
  cmd = { mason_bin .. "/clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { "compile_commands.json", ".clangd", ".git" },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
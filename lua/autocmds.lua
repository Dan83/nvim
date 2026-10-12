require "nvchad.autocmds"

local function ensure_valid_cwd()
  local cwd = vim.uv.cwd()
  if cwd and cwd ~= "" and vim.uv.fs_stat(cwd) then
    return
  end

  local fallback = vim.fn.expand "~"
  if fallback and fallback ~= "" and vim.uv.fs_stat(fallback) then
    vim.cmd.cd(fallback)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = ensure_valid_cwd,
})

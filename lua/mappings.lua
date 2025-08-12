require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- map("n", "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current<CR>", { desc = "Comment toogle"})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)

-- Copilot
vim.keymap.set("i", "<C-j>", "copilot#Accept(<CR>)", { expr = true, replace_keycodes = false })
vim.keymap.set("i", "<C-k>", "copilot#Dismiss()", { expr = true, replace_keycodes = false })


vim.keymap.set("n", "\\", "<cmd>NvimTreeToggle<CR>", { desc = "Toogle tree" })

local function cargo_build_qf()
  vim.fn.setqflist({}, 'r') -- reset quickfix

  vim.fn.jobstart({ "cargo", "build", "--message-format=short" }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if not data then return end
      for _, line in ipairs(data) do
        if line ~= "" then
          -- Match tipo: file:line:col: messaggio
          local file, lnum, col, msg = line:match("([^:]+):(%d+):(%d+):%s*(.*)")
          if file and lnum and col then
            vim.fn.setqflist({}, 'a', {
              items = {
                {
                  filename = file,
                  lnum = tonumber(lnum),
                  col = tonumber(col),
                  text = msg,
                }
              }
            })
          else
            -- Se non matcha il formato, aggiungi come testo normale
            vim.fn.setqflist({}, 'a', { lines = { line } })
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if not data then return end
      for _, line in ipairs(data) do
        if line ~= "" then
          vim.fn.setqflist({}, 'a', { lines = { line } })
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.cmd("copen") -- Mostra errori solo se build fallisce
      else
        print("✅ Cargo build completato senza errori")
      end
    end,
  })
end

vim.api.nvim_create_user_command('CargoBuildQf', cargo_build_qf, {})
vim.keymap.set("n", "<C-b>", "<cmd>CargoBuildQf<CR>", { desc = "Cargo build" })

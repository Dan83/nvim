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


-- vim.keymap.set("n", "<leader>gp", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })

-- map("n", "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current<CR>", { desc = "Comment toogle"})

-- Le mappature per opencode sono già definite nel plugin
-- lua/plugins/opencode.lua. Per evitare duplicati lasciamo
-- quelle originali e non ridefiniamo le keybindings qui.

-- Mappatura "sicura" per <C-a>: carica il plugin se necessario e chiama ask()
vim.keymap.set({ "n", "x" }, "<C-a>", function()
  local ok, mod = pcall(require, "opencode")
  if not ok then
    -- Prova a caricare tramite lazy (se disponibile)
    if pcall(require, "lazy") then
      pcall(function()
        require("lazy").load({ plugins = { "opencode.nvim" } })
      end)
      ok, mod = pcall(require, "opencode")
    end
  end

  if ok and mod and type(mod.ask) == "function" then
    mod.ask("@this: ", { submit = true })
  else
    vim.notify("opencode non disponibile: assicurati che il plugin sia installato e caricato", vim.log.levels.WARN)
  end
end, { desc = "Chiedi a opencode...", noremap = true, silent = true })

-- Toggle/opencode focus: mapping in normal mode per evitare dipendenza dalla mappa del plugin
vim.keymap.set("n", "<leader>o", function()
  local ok, mod = pcall(require, "opencode")
  if not ok then
    if pcall(require, "lazy") then
      pcall(function()
        require("lazy").load({ plugins = { "opencode.nvim" } })
      end)
    end
    ok, mod = pcall(require, "opencode")
  end

  if ok and mod and type(mod.toggle) == "function" then
    mod.toggle()
  else
    vim.notify("opencode non disponibile", vim.log.levels.WARN)
  end
end, { desc = "Toggle Opencode (apri/chiudi)", noremap = true, silent = true })


-- Copilot keybindings
vim.keymap.set("i", "<M-l>", function()
  local copilot = require("copilot.suggestion")
  if copilot.is_visible() then
    copilot.accept()
  end
end, { desc = "Copilot: Accept suggestion" })
vim.keymap.set("i", "<M-]>", function()
  require("copilot.suggestion").next()
end, { desc = "Copilot: Next suggestion" })
vim.keymap.set("i", "<M-[>", function()
  require("copilot.suggestion").prev()
end, { desc = "Copilot: Previous suggestion" })
vim.keymap.set("i", "<C-]>", function()
  require("copilot.suggestion").dismiss()
end, { desc = "Copilot: Dismiss suggestion" })
vim.keymap.set("i", "<M-c>", function()
  require("copilot.panel").open()
end, { desc = "Copilot: Open panel" })

-- Copilot Chat keybindings
vim.keymap.set("n", "<leader>cc", function()
  require("CopilotChat").toggle()
end, { desc = "Copilot: Toggle chat" })
vim.keymap.set("n", "<leader>cx", function()
  require("CopilotChat").reset()
end, { desc = "Copilot: Reset chat" })
vim.keymap.set("v", "<leader>cv", function()
  local chat = require("CopilotChat")
  local select = require("CopilotChat.select")
  chat.ask("", { selection = select.visual })
end, { desc = "Copilot: Chat with visual selection" })
vim.keymap.set("n", "<leader>ci", function()
  local chat = require("CopilotChat")
  local select = require("CopilotChat.select")
  chat.ask("", {
    selection = select.buffer,
    window = {
      layout = "float",
      relative = "cursor",
      width = 1,
      height = 0.4,
      row = 1,
    },
  })
end, { desc = "Copilot: Inline chat" })
vim.keymap.set("n", "<leader>cq", function()
  local chat = require("CopilotChat")
  chat.close()
end, { desc = "Copilot: Close chat window" })
vim.keymap.set("n", "<leader>cs", function()
  vim.cmd("CopilotChatSubmit")
end, { desc = "Copilot: Submit prompt" })
vim.keymap.set("n", "<leader>cb", function()
  local chat = require("CopilotChat")
  local select = require("CopilotChat.select")
  chat.ask("", { selection = select.buffer })
end, { desc = "Copilot: Chat with buffer" })
vim.keymap.set("n", "<leader>ct", function()
  local chat = require("CopilotChat")
  local select = require("CopilotChat.select")
  chat.ask("", { selection = select.tab })
end, { desc = "Copilot: Chat with tab" })


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

-- Comandi Copilot
vim.api.nvim_create_user_command('CopilotAuth', function()
  vim.cmd("Copilot auth")
end, { desc = "Autentica Copilot con GitHub" })

vim.api.nvim_create_user_command('CopilotStatus', function()
  local copilot = require("copilot")
  local client = copilot.client
  if client then
    local status = client.is_running() and "✅ In esecuzione" or "❌ Non in esecuzione"
    print("Copilot Status: " .. status)
  else
    print("❌ Client Copilot non disponibile. Esegui :CopilotAuth per autenticarti.")
  end
end, { desc = "Verifica lo stato di Copilot" })

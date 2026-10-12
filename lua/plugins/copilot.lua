return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          markdown = true,
          help = true,
        },
        server_opts_overrides = {},
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = function()
      -- Patch per curl versioni vecchie: sostituisce --fail-with-body con --fail
      local copilot_file = vim.fn.stdpath("data") .. "/lazy/CopilotChat.nvim/lua/CopilotChat/copilot.lua"
      if vim.fn.filereadable(copilot_file) == 1 then
        local content = vim.fn.readfile(copilot_file)
        local modified = false
        for i, line in ipairs(content) do
          if line:match("--fail%-with%-body") then
            content[i] = line:gsub("--fail%-with%-body", "--fail")
            modified = true
          end
        end
        if modified then
          vim.fn.writefile(content, copilot_file)
        end
      end
    end,
    opts = {
      debug = false,
      show_help = false,
      mappings = {
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-r>",
          insert = "<C-r>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<CR>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        show_diff = {
          normal = "gd",
          insert = "gd",
        },
        cycle_modes = {
          normal = "<C-o>",
          insert = "<C-o>",
        },
        cycle_views = {
          normal = "<C-v>",
          insert = "<C-v>",
        },
      },
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Scrivi una spiegazione dettagliata del codice selezionato.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Controlla il codice selezionato per possibili bug, problemi di sicurezza, problemi di performance, problemi di stile e miglioramenti.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE_TESTS Genera test unitari per il codice selezionato.",
        },
        Refactor = {
          prompt = "/COPILOT_REFACTOR Refactorizza il codice selezionato per migliorare la leggibilità e le performance.",
        },
        Fix = {
          prompt = "/COPILOT_FIX_PROBLEMS Trova e risolvi i problemi nel codice selezionato.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE_DOCS Genera documentazione per il codice selezionato.",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      -- Inline chat con Copilot
      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      -- Inline chat con Copilot (modalità normale)
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.buffer,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", bang = true })

      -- Comando per chiudere la chat
      vim.api.nvim_create_user_command("CopilotChatClose", function()
        chat.close()
      end, {})

      -- Comando per inviare il prompt nella chat
      vim.api.nvim_create_user_command("CopilotChatSubmit", function()
        -- Invia il prompt corrente
        vim.cmd("normal! A")
        vim.cmd("startinsert")
      end, {})

      -- Autocmd per aggiungere mapping utili quando la finestra chat è attiva
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "copilot-chat",
        callback = function()
          -- Chiudi con Esc
          vim.keymap.set("n", "<Esc>", function()
            chat.close()
          end, { buffer = true, silent = true })
          vim.keymap.set("i", "<Esc>", function()
            chat.close()
          end, { buffer = true, silent = true })
          
          -- Invia prompt con Enter in modalità insert (il mapping standard dovrebbe funzionare)
          -- Il mapping submit_prompt è già configurato nelle opts
          
          -- Accetta le modifiche suggerite
          vim.keymap.set("n", "<C-y>", function()
            chat.accept()
          end, { buffer = true, silent = true, desc = "Accept diff" })
          
          -- Mostra il diff
          vim.keymap.set("n", "gd", function()
            chat.show_diff()
          end, { buffer = true, silent = true, desc = "Show diff" })
        end,
      })

      -- Chat buffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*" })

      -- Chat tab
      vim.api.nvim_create_user_command("CopilotChatTab", function(args)
        chat.ask(args.args, { selection = select.tab })
      end, { nargs = "*" })

      -- Reset chat
      vim.api.nvim_create_user_command("CopilotChatReset", function()
        chat.reset()
      end, {})

      chat.setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup({
        method = "getCompletionsCycling",
      })
    end,
  },
}

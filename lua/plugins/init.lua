return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function ()
      local mason_registry = require('mason-registry')
      local codelldb_pkg = vim.fn.expand("$MASON/packages/codelldb")
      -- local codelldb = mason_registry.get_package("codelldb")
      -- local extension_path = codelldb:get_install_path() .. "/extension/"
      local extension_path = codelldb_pkg .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path.. "lldb/lib/liblldb.so"
	    -- If you are on Linux, replace the line above with the line below:
	    -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      local cfg = require('rustaceanvim.config')

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  },

  { 
    'mfussenegger/nvim-dap',
    config = function()
			local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
		end,
  },

  {
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        silent = true,
      },
    },
    opts = {
      -- icons = { expanded = "∩â¥", collapsed = "∩âÜ", circular = "∩äÉ" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "repl", size = 0.30 },
            { id = "console", size = 0.70 },
          },
          size = 0.19,
          position = "bottom",
        },
        {
          elements = {
            { id = "scopes", size = 0.30 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks", size = 0.10 },
            { id = "watches", size = 0.30 },
          },
          size = 0.20,
          position = "right",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        -- icons = {
        --   pause = "ε½æ",
        --   play = "ε½ô",
        --   step_into = "ε½ö",
        --   step_over = "ε½û ",
        --   step_out = "ε½ò",
        --   step_back = "ε«Å ",
        --   run_last = "ε¼╖ ",
        --   terminate = "ε½ù ",
        -- },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = vim.g.border_chars,
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
    config = function(_, opts)
      -- local icons = require("core.icons").dap
      -- for name, sign in pairs(icons) do
      --   ---@diagnostic disable-next-line: cast-local-type
      --   sign = type(sign) == "table" and sign or { sign }
      --   vim.fn.sign_define("Dap" .. name, { text = sign[1] })
      -- end
      require("dapui").setup(opts)
    end,
  },
  { "nvim-neotest/nvim-nio" },

  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
    end
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },

  { 'echasnovski/mini.nvim', version = '*' },
}

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require('gruvbox').setup({ transparent_mode = true })
    end,
  },

  {
    "stevearc/oil.nvim",
    config = function()
      require('oil').setup({
        view_options = { show_hidden = true }
      })
    end,
  },

  {
    "echasnovski/mini.nvim",
    config = function()
      require('mini.pick').setup()
      
      require('mini.pairs').setup()
      
      require('mini.completion').setup({
        delay = { completion = 100, info = 100, signature = 50 },
        window = {
          info = { height = 25, width = 80, border = 'rounded' },
          signature = { height = 25, width = 80, border = 'rounded' },
        },
      })
       
      require('mini.jump').setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'python', 'lua', 'markdown', 'typst' },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require('mason').setup({
        ui = { border = 'rounded' }
      })
    end,
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'lua_ls', 'tinymist' },
        automatic_installation = true,
      })
    end,
  },
  
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-lspconfig.nvim" },
    config = function()
      require('lsp')
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox',
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_b = {'branch', 'diff', 'diagnostics'},
        },
      })
    end,
  },

  "mbbill/undotree",

  "rafamadriz/friendly-snippets",
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      -- Snippet navigation
      vim.keymap.set({'i', 's'}, '<C-l>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { desc = 'Expand/jump snippet' })

      vim.keymap.set({'i', 's'}, '<C-h>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { desc = 'Jump snippet backward' })

      vim.keymap.set('i', '<Tab>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-n>'
        elseif ls.expand_or_jumpable() then
          return '<Plug>luasnip-expand-or-jump'
        else
          return '<Tab>'
        end
      end, { expr = true })

      vim.keymap.set('i', '<S-Tab>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-p>'
        elseif ls.jumpable(-1) then
          return '<Plug>luasnip-jump-prev'
        else
          return '<S-Tab>'
        end
      end, { expr = true })

      vim.keymap.set('i', '<CR>', [[pumvisible() ? "\<C-y>" : "\<CR>"]], { expr = true })
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          typst = { 'typstfmt' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      vim.keymap.set('n', '<leader>lf', function()
        require('conform').format({ async = true, lsp_fallback = true })
      end, { desc = 'Format buffer' })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 500,
        },
      })
    end,
  },
}, {
  ui = {
    border = "rounded",
  },
})
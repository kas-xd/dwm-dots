local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup({
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_dir = lspconfig.util.root_pattern('pyproject.toml', 'setup.py', 'requirements.txt', '.git'),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        typeCheckingMode = 'basic',
      },
    },
  },
})

-- Lua
lspconfig.lua_ls.setup({
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_dir = lspconfig.util.root_pattern('.luarc.json', '.luarc.jsonc', '.stylua.toml', '.git'),
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Typst
lspconfig.tinymist.setup({
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  root_dir = lspconfig.util.root_pattern('.git'),
  settings = {
    exportPdf = 'onSave',
    formatterMode = 'typstyle',
  },
})
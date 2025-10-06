local lspconfig = require('lspconfig')

local servers = {
  pyright = {
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
  },
  
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
  
  tinymist = {
    settings = {
      exportPdf = 'onSave',
      formatterMode = 'typstyle',
    },
  },
}

for server, config in pairs(servers) do
  lspconfig[server].setup(config)
end
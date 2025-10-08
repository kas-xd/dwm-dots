pcall(function() vim.loader.enable() end)
vim.g.mapleader = ' '
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.updatetime = 200
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git','clone','--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  { 'stevearc/oil.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'echasnovski/mini.nvim', version = false },
  { 'lewis6991/gitsigns.nvim' },
  { 'mbbill/undotree' },
  { 'neovim/nvim-lspconfig', lazy = false },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim', lazy = false },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
}, { ui = { border = 'single' } })

do
  local ok, gruv = pcall(require, 'gruvbox')
  if ok then
    gruv.setup({ transparent_mode = true })
    pcall(vim.cmd.colorscheme, 'gruvbox')
  end
end

require('gitsigns').setup({
  signs = {
    add = { text = '▎' }, change = { text = '▎' }, delete = { text = '▁' },
    topdelete = { text = '▔' }, changedelete = { text = '▎' },
  },
})

require('oil').setup({ view_options = { show_hidden = true } })

require('mini.statusline').setup()
require('mini.pick').setup()
require('mini.surround').setup()
require('mini.ai').setup()
require('mini.comment').setup()
require('mini.jump').setup()
require('mini.pairs').setup()
require('mini.completion').setup({
  window = { info = { border = 'single' }, signature = { border = 'single' } },
})
pcall(require, 'mini.snippets')

vim.api.nvim_set_hl(0, 'StatusLine',   { fg = '#ebdbb2', bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#a89984', bg = '#282828' })

require('nvim-treesitter.configs').setup({
  auto_install = true,
  ensure_installed = { 'lua', 'python', 'typst' }, -- drop 'typst' if parser unavailable
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
})
pcall(function() require('nvim-treesitter.install').update({ with_sync = false })() end)

local function _t(k) return vim.api.nvim_replace_termcodes(k,true,true,true) end
vim.keymap.set('i','<Tab>',function()
  if vim.fn.pumvisible()==1 then return _t('<C-n>') end
  return _t('<Tab>')
end,{ expr=true, silent=true })
vim.keymap.set('i','<S-Tab>',function()
  if vim.fn.pumvisible()==1 then return _t('<C-p>') end
  return _t('<S-Tab>')
end,{ expr=true, silent=true })

vim.g.undotree_WindowLayout = 2
vim.keymap.set('n','<leader>u','<cmd>UndotreeToggle<CR>',{ desc='Undotree' })

vim.keymap.set('n','<leader>w','<cmd>write<CR>',{ desc='Save' })
vim.keymap.set('n','<leader>q','<cmd>quit<CR>', { desc='Quit' })
vim.keymap.set('n','<Esc>','<cmd>nohlsearch<CR>')
vim.keymap.set('n','<leader>e','<cmd>Oil<CR>', { desc='Explorer' })
vim.keymap.set('n','<leader>f','<cmd>Pick files<CR>', { desc='Files' })
vim.keymap.set('n','<leader>b','<cmd>Pick buffers<CR>', { desc='Buffers' })
vim.keymap.set('n','<leader>g','<cmd>Pick grep_live<CR>', { desc='Live Grep' })
vim.keymap.set('n','<leader>h','<cmd>Pick help<CR>', { desc='Help' })

vim.diagnostic.config({
  float = { border = 'single' },
  virtual_text = true, signs = true, underline = true,
  update_in_insert = false, severity_sort = true,
})
vim.keymap.set('n','[d', vim.diagnostic.goto_prev, { desc='Prev Diag' })
vim.keymap.set('n',']d', vim.diagnostic.goto_next, { desc='Next Diag' })
vim.keymap.set('n','<leader>dd', vim.diagnostic.open_float, { desc='Show Diag' })
vim.keymap.set('n','<leader>dl', vim.diagnostic.setloclist, { desc='Diag List' })

local capabilities
do
  local ok, mini_comp = pcall(require, 'mini.completion')
  if ok and type(mini_comp.get_lsp_capabilities) == 'function' then
    capabilities = mini_comp.get_lsp_capabilities()
  end
end

local function on_attach(_, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  local ih = vim.lsp.inlay_hint
  if type(ih) == 'table' and type(ih.enable) == 'function' then
    pcall(ih.enable, bufnr, true)   -- 0.11+
  else
    pcall(ih, bufnr, true)          -- 0.10 fallback
  end
end

vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace  = { checkThirdParty = false },
      diagnostics = { globals = { 'vim', 'require' } },
      hint = { enable = true },
    },
  },
})

vim.lsp.config('pyright', {})
vim.lsp.config('tinymist', {})

for _, name in ipairs({ 'lua_ls', 'pyright', 'tinymist' }) do
  pcall(vim.lsp.enable, name)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    local ih = vim.lsp.inlay_hint
    if type(ih) == 'table' and type(ih.enable) == 'function' then
      pcall(ih.enable, args.buf, true)
    else
      pcall(ih, args.buf, true)
    end
  end,
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'tinymist' },
  automatic_installation = true,
})

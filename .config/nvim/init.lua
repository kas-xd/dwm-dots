vim.loader.enable()
vim.g.mapleader = ' '
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 8
vim.opt.winborder = "single"
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.updatetime = 200
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

-- lazyvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'ellisonleao/gruvbox.nvim' },
  { 'stevearc/oil.nvim' },
  { 'echasnovski/mini.nvim' },
  { 'mbbill/undotree' },
  { 'neovim/nvim-lspconfig' },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'f-person/git-blame.nvim' },
}, {
  defaults = { lazy = false },
})

-- theme
require('gruvbox').setup({ transparent_mode = true })
vim.cmd.colorscheme('gruvbox')

-- git
vim.g.gitblame_enabled = 1
vim.g.gitblame_message_template = ' <author> • <date> • <summary> • <sha>'
vim.g.gitblame_date_format = '%Y-%m-%d %H:%M'
vim.g.gitblame_virtual_text_column = 0
vim.api.nvim_set_hl(0, 'GitBlameVirtualText', { link = 'Comment' })

-- mini.nvim
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
pcall(function()
  require('mini.snippets').setup()
  require('mini.icons').setup()
end)

-- oil
require('oil').setup({
  view_options = { show_hidden = true },
  columns = { 'icon' },
})

-- statusline colors
vim.api.nvim_set_hl(0, 'StatusLine',   { fg = '#ebdbb2', bg = '#3c3836' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#a89984', bg = '#282828' })

-- treesitter
require('nvim-treesitter.configs').setup({
  auto_install = true,
  ensure_installed = { 'lua', 'python', 'typst' },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
})
pcall(function() require('nvim-treesitter.install').update({ with_sync = false })() end)

-- completion keys
local function _t(k) return vim.api.nvim_replace_termcodes(k, true, true, true) end
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then return _t('<C-n>') end
  return _t('<Tab>')
end, { expr = true, silent = true })
vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then return _t('<C-p>') end
  return _t('<S-Tab>')
end, { expr = true, silent = true })

-- undotree
vim.g.undotree_WindowLayout = 2
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Undotree' })

-- keymaps
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<CR>',  { desc = 'Quit' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>',            { desc = 'Explorer' })
vim.keymap.set('n', '<leader>f', '<cmd>Pick files<CR>',     { desc = 'Files' })
vim.keymap.set('n', '<leader>b', '<cmd>Pick buffers<CR>',   { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', '<cmd>Pick grep_live<CR>', { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>h', '<cmd>Pick help<CR>',      { desc = 'Help' })

-- diagnostics
vim.diagnostic.config({
  float = { border = 'single' },
  virtual_text = true, signs = true, underline = true,
  update_in_insert = false, severity_sort = true,
})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diag' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diag' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Show Diag' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Diag List' })

-- LSP
local lsp_caps = require('mini.completion').get_lsp_capabilities()
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup({
  capabilities = lsp_caps,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      diagnostics = { globals = { 'vim', 'require' } },
      hint = { enable = true },
    },
  },
})

lspconfig.pyright.setup({ capabilities = lsp_caps })
lspconfig.tinymist.setup({ capabilities = lsp_caps })

-- LSP attach
local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc }) end
map('n', 'gd',  vim.lsp.buf.definition,         'Definition')
map('n', 'gD',  vim.lsp.buf.declaration,        'Declaration')
map('n', 'gi',  vim.lsp.buf.implementation,     'Implementation')
map('n', 'go',  vim.lsp.buf.type_definition,    'Type Def')
map('n', 'gr',  vim.lsp.buf.references,         'References')
map('n', 'K',   vim.lsp.buf.hover,              'Hover')
map('n', '<leader>rn', vim.lsp.buf.rename,      'Rename')
map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
map({ 'n', 'x' }, '<leader>o', function() vim.lsp.buf.format({ async = true }) end, 'Format')

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

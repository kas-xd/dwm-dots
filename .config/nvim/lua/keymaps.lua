-- Write/Quit
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Quit' })

-- Navigation
vim.keymap.set('n', '<leader>f', '<cmd>Pick files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', '<cmd>Pick grep_live<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>b', '<cmd>Pick buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>h', '<cmd>Pick help<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'File explorer' })
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Undo tree' })

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, { desc = 'Diagnostic list' })

-- Filetype-specific run commands
local run_commands = {
	python = 'python3 %',
	typst = 'typst compile %',
	lua = 'source %',
}

for ft, cmd in pairs(run_commands) do
	vim.api.nvim_create_autocmd('FileType', {
		pattern = ft,
		callback = function()
			local prefix = ft == 'lua' and '' or '!'
			vim.keymap.set('n', '<leader>r', ':' .. prefix .. cmd .. '<CR>', { 
				buffer = true, 
				desc = 'Run ' .. ft 
			})
		end,
	})
end
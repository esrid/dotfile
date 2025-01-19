return {
  {
  'AckslD/nvim-neoclip.lua',
  dependencies = {
    { 'nvim-telescope/telescope.nvim' },
    { 'kkharji/sqlite.lua', module = 'sqlite' }, -- Optional, for persistent history
  },
  config = function()
    require('neoclip').setup()
    require('telescope').load_extension('neoclip')
  end
},


{
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim",'nvim-telescope/telescope-ui-select.nvim' },
	config = function()
    require('telescope').load_extension('ui-select')

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader><Space>", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
	end,
}
}

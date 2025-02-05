return {
	"gbprod/yanky.nvim",
	config = function()
		require("yanky").setup()
		local telescope = require("telescope")
		pcall(telescope.load_extension, "yank_history")
		vim.keymap.set("n", "<leader>sy", "<cmd>Telescope yank_history<CR>", { desc = "[S]earch [Y]ank history" })
	end,
}

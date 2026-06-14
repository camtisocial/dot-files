return {
	"preservim/tagbar",
	config = function()
		vim.g.tagbar_foldlevel = 0
		vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>", { noremap = true, silent = true, desc = "Toggle Tagbar" })
	end,
}

return {
	"preservim/tagbar",
	config = function()
		vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>", { noremap = true, silent = true, desc = "Toggle Tagbar" })
	end,
}

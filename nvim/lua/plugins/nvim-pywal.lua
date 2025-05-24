return {
	"AlphaTechnolog/pywal.nvim",
	lazy = false, -- Load immediately
	priority = 1, -- Load before other themes
	config = function()
		require("pywal").setup()
		vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = "#de499c" })
		vim.api.nvim_set_hl(0, "UfoFoldedBg", { fg = "#de499c" })
		vim.api.nvim_set_hl(0, "UfoFoldedFg", { fg = "#de499c" })
		vim.api.nvim_set_hl(0, "UfoPreviewCursorLine", { fg = "#de499c" })
		vim.api.nvim_set_hl(0, "UfoFoldedLine", { fg = "#de499c" })
		vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { fg = "#de499c" })
	end,
} 

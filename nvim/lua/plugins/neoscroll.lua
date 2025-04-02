return {
	{"karb94/neoscroll.nvim",
	opts = {},
	config = function()
		local neoscroll = require("neoscroll")

		neoscroll.setup({})

		-- Smooth scrolling mappings with cursor centering
		vim.keymap.set("n", "<Down>", function()
			neoscroll.scroll(10, { move_cursor = false, smooth = true, duration = 150 })
		end, { noremap = true, silent = true })

		vim.keymap.set("n", "<Up>", function()
			neoscroll.scroll(-10, { move_cursor = false, smooth = true, duration = 150 })
		end, { noremap = true, silent = true })

		vim.keymap.set("v", "<Down>", function()
			neoscroll.scroll(10, { move_cursor = false, smooth = true, duration = 150 })
		end, { noremap = true, silent = true })

		vim.keymap.set("v", "<Up>", function()
			neoscroll.scroll(-10, {move_cursor = false, smooth = true, duration = 150 })
		end, { noremap = true, silent = true })

		-- Smooth half-page scrolling with cursor centering
		vim.keymap.set("n", "<C-d>", function()
			vim.cmd("normal! zz")
			neoscroll.scroll(vim.api.nvim_win_get_height(0) / 2, {move_cursor = true, smooth = true, duration = 300 })
		end, { noremap = true, silent = true })

		vim.keymap.set("n", "<C-u>", function()
			vim.cmd("normal! zz")
			neoscroll.scroll(-vim.api.nvim_win_get_height(0) / 2, {move_cursor = true, smooth = true, duration = 300 })
		end, { noremap = true, silent = true })
	end,
	hide_cursor = true,   -- Hide cursor while scrolling
	post_hook = function()
		vim.cmd("normal! zz") -- Center the cursor after scrolling
	end,
	cursor_scrolls_alone = true, -- Keep cursor in the same position when scrolling
	},
}

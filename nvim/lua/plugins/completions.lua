return {
	{ "L3MON4D3/LuaSnip" },
	{ "rafamadriz/friendly-snippets" },
	{
		"brianaung/compl.nvim",
		dependencies = {
			{ "hrsh7th/vim-vsnip" },
		},
		opts = {
			-- Default options (no need to set them again)
			completion = {
				fuzzy = false,
				timeout = 100,
			},
			info = {
				enable = true,
				timeout = 100,
			},
			snippet = {
				enable = false,
				paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
			},
		},
	},

	{ "github/copilot.vim" },
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		config = function()
			require("CopilotChat").setup({})
			vim.keymap.set("n", "<leader>c", function()
				vim.ui.input({ prompt = "Copilot Chat: " }, function(input)
					if input then
						-- Replace with the actual function to send the message to Copilot
						--require('copilot_chat').send_message(input)
						require("CopilotChat").ask(input)
					end
				end)
			end, { desc = "Send message to Copilot Chat" })

			vim.keymap.set("n", "<leader>co", function()
				require("CopilotChat").open()
			end, { desc = "Open Copilot Chat" })
		end,
	},
}

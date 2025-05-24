return {
	-- Mason: install LSP servers
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- 🔧 <== this provides `cmp_nvim_lsp`
			"L3MON4D3/LuaSnip", -- snippet engine
			"saadparwaiz1/cmp_luasnip", -- LuaSnip completion source
			"hrsh7th/cmp-buffer", -- buffer completion
			"hrsh7th/cmp-path", -- file path completion
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					-- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif require("luasnip").expand_or_jumpable() then
							require("luasnip").expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- Mason-LSPConfig: auto-configure LSP servers
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"html",
					"eslint",
					"ts_ls",
					"rust_analyzer",
					"biome",
					"mdx_analyzer",
					"ast_grep",
				},
			})
		end,
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- List of servers to apply the same config to
			local servers = {
				"lua_ls",
				"clangd",
				"html",
				"eslint",
				"ts_ls",
				"rust_analyzer",
				"biome",
				"mdx_analyzer",
				"ast_grep",
			}

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end

			-- Basic LSP keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},

	-- Flutter tools
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional UI
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			require("flutter-tools").setup({
				flutter_path = "/opt/flutter/bin/flutter", -- adjust if needed
				widget_guides = {
					enabled = true,
				},
				closing_tags = {
					highlight = "Comment",
					prefix = "// ",
					enabled = true,
				},
				lsp = {
					color = { enabled = true },
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
					},
					capabilities = require("cmp_nvim_lsp").default_capabilities(), -- also apply here!
				},
				dev_log = {
					enabled = true,
					open_cmd = "tabedit",
				},
				debugger = {
					enabled = true,
					run_via_dap = true,
				},
				color = {
					enabled = true,
					background = true,
				},
				cmd = {
					"/opt/flutter/bin/dart",
					"language-server",
					"--protocol=lsp",
				},
			})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets", -- ✅ this includes dart/flutter snippets
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load() -- ✅ loads VS Code snippets
		end,
	},
}

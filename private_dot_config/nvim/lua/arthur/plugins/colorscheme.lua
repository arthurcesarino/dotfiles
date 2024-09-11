-- ~/.config/nvim/lua/plugins/catppuccin.lua

return {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = {
		flavour = "mocha", -- You can choose between 'latte', 'frappe', 'macchiato', or 'mocha'
		term_colors = true,
		transparent_background = true,
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			lsp_trouble = true,
			cmp = true,
			gitsigns = true,
			telescope = true,
			nvimtree = {
				enabled = true,
				show_root = true,
				transparent_panel = false,
			},
			which_key = true,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = false,
			},
			dashboard = true,
			neogit = true,
			barbar = true,
			markdown = true,
			lightspeed = true,
			hop = true,
			notify = true,
			symbols_outline = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd("colorscheme catppuccin")
	end,
}

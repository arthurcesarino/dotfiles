return {
	"numToStr/FTerm.nvim",
	opts = {
		border = "rounded",
		dimensions = {
			height = 0.85,
			width = 0.85,
		},
		blend = 0,
	},
	config = true,
	keys = {
		{ "<leader>ot", '<CMD>lua require("FTerm").toggle()<CR>', mode = "n", desc = "Toggle FTerm" },
	},
}

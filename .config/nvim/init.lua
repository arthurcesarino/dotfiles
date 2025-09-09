require("arthur.core")
require("arthur.lazy")

-- Add this in your init.lua or core config file
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.tf", "*.hcl" },
	command = "set filetype=terraform",
})

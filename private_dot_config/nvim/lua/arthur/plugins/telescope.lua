return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-project.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		-- Telescope Setup
		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected item to quickfix list
					},
				},
			},
			extensions = {
				-- Configure the project extension
				project = {
					base_dirs = {
						{ "~/Documents/", max_depth = 3 }, -- Directory with your projects
					},
					hidden_files = true, -- Show hidden files in project directories
				},
			},
		})

		-- Load Telescope extensions
		telescope.load_extension("fzf") -- Enable FZF for better file searching
		telescope.load_extension("project") -- Enable project management

		-- Keymap Configuration for Telescope
		local keymap = vim.keymap -- for conciseness

		-- Fuzzy find files in current working directory
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })

		-- Find recent files
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })

		-- Fuzzy search for a string in current working directory
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })

		-- Find the string under the cursor in the current working directory
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

		-- Use Telescope to find TODO comments in the project (requires todo-comments.nvim)
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })

		-- Use Telescope Project to list and switch projects
		keymap.set("n", "<leader>pp", "<cmd>Telescope project<cr>", { desc = "Find project" })
	end,
}

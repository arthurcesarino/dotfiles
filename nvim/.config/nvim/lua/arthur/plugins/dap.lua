return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui", -- UI for DAP
		"nvim-telescope/telescope-dap.nvim", -- Telescope integration
		"theHamsta/nvim-dap-virtual-text", -- Virtual text for variables
		"nvim-neotest/nvim-nio", -- Virtual text for variables
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup DAP UI
		dapui.setup()

		-- Setup C++ DAP with cpptools
		dap.adapters.cppdbg = {
			id = "cppdbg",
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
		}

		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtEntry = true,
			},
		}

		-- Auto open/close DAP UI on debug start/exit
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Keybindings
		local keymap = vim.keymap

		keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
		keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue Debugging" })
		keymap.set("n", "<leader>ds", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step Over" })
		keymap.set("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step Into" })
		keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step Out" })
		keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })
		keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run Last Debugging Session" })
		keymap.set("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle Debug UI" })
	end,
}

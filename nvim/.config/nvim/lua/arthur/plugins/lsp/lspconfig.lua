return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		-- Core requires
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Mason bootstrap
		require("mason").setup()
		local mason_lspconfig = require("mason-lspconfig")

		-- Capabilities for nvim-cmp completion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Keymaps when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local km = vim.keymap
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				km.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				km.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				km.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "Code action"
				km.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Rename"
				km.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Buffer diagnostics"
				km.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Line diagnostics"
				km.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Prev diagnostic"
				km.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Next diagnostic"
				km.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Hover"
				km.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				km.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Mason-LSPConfig with handlers (modern API)
		mason_lspconfig.setup({
			-- Optional: pre-install some servers you use often
			ensure_installed = { "lua_ls", "terraformls", "tflint", "clangd" },
			handlers = {
				-- Default handler (applies to every server)
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,

				-- lua_ls (Neovim Lua)
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								completion = { callSnippet = "Replace" },
								workspace = {
									checkThirdParty = false,
								},
							},
						},
					})
				end,

				-- Terraform Language Server
				["terraformls"] = function()
					lspconfig.terraformls.setup({
						capabilities = capabilities,
						filetypes = { "terraform", "hcl" },
						root_dir = util.root_pattern(".terraform", ".git", "main.tf"),
					})
				end,

				-- TFLint
				["tflint"] = function()
					lspconfig.tflint.setup({
						capabilities = capabilities,
					})
				end,

				-- clangd (C/C++)
				["clangd"] = function()
					lspconfig.clangd.setup({
						capabilities = capabilities,
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--completion-style=detailed",
							"--cross-file-rename",
						},
						filetypes = { "c", "cpp", "objc", "objcpp" },
						root_dir = util.root_pattern(".clangd", ".git", "compile_commands.json"),
					})
				end,
			},
		})
	end,
}

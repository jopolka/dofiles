------------------------
-- Treesitter
------------------------
lvim.builtin.treesitter.ensure_installed = {
	"go",
	"gomod",
	"php",
}

------------------------
-- Plugins
------------------------
lvim.plugins = {
	"olexsmir/gopher.nvim",
	"leoluz/nvim-dap-go",
	"nvim-neotest/nvim-nio",
	"nvim-neotest/neotest",
	{
		"fredrikaverpil/neotest-golang",
		keys = {
			{
				"<leader>t",
				"",
				desc = "+test",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File (Neotest)",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files (Neotest)",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest (Neotest)",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last (Neotest)",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary (Neotest)",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output (Neotest)",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel (Neotest)",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop (Neotest)",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch (Neotest)",
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"GeorgesAlkhouri/nvim-aider",
		cmd = {
			"AiderTerminalToggle",
			"AiderHealth",
		},
		keys = {
			{ "<leader>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
			{ "<leader>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
			{ "<leader>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
			{ "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
			{ "<leader>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
			{ "<leader>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
			{ "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
		},
		dependencies = {
			"folke/snacks.nvim",
			--- The below dependencies are optional
			"catppuccin/nvim",
			"nvim-tree/nvim-tree.lua",
			--- Neo-tree integration
			{
				"nvim-neo-tree/neo-tree.nvim",
				opts = function(_, opts)
					-- Example mapping configuration (already set by default)
					-- opts.window = {
					--   mappings = {
					--     ["+"] = { "nvim_aider_add", desc = "add to aider" },
					--     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
					--   }
					-- }
					require("nvim_aider.neo_tree").setup(opts)
				end,
			},
		},
		config = true,
	},
}

------------------------
-- Formatting
------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "goimports", filetypes = { "go" } },
	{ command = "gofumpt", filetypes = { "go" } },
	{ command = "phpcsfixer", filetypes = { "php" } },
})

lvim.format_on_save.enabled = true
-- lvim.format_on_save = {
--   pattern = { "*.go", "*.php" },
-- }

------------------------
-- Linting
------------------------
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "phpcs", filetypes = { "php" } },
	{
		command = "golangci-lint",
		filetypes = { "go" },
	},
})

------------------------

-- Dap
------------------------
local dap_ok, dapgo = pcall(require, "dap-go")
if not dap_ok then
	return
end

dapgo.setup()

local dap = require("dap")
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { mason_path .. "packages/php-debug-adapter/extension/out/phpDebug.js" },
}
dap.configurations.php = {
	{
		name = "Listen for Xdebug",
		type = "php",
		request = "launch",
		port = 9003,
	},
	{
		name = "Debug currently open script",
		type = "php",
		request = "launch",
		port = 9003,
		cwd = "${fileDirname}",
		program = "${file}",
		runtimeExecutable = "php",
	},
}

------------------------
-- LSP
------------------------
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

local lsp_manager = require("lvim.lsp.manager")
-- lsp_manager.setup("golangci_lint_ls", {
--   on_init = require("lvim.lsp").common_on_init,
--   capabilities = require("lvim.lsp").common_capabilities(),
--   init_options = {
--     command = { 'golangci-lint', 'run', '--output.json.path=stdout', '--show-stats=false' },
--   },
-- })

lsp_manager.setup("gopls", {
	on_attach = function(client, bufnr)
		require("lvim.lsp").common_on_attach(client, bufnr)
		local _, _ = pcall(vim.lsp.codelens.refresh)
		local map = function(mode, lhs, rhs, desc)
			if desc then
				desc = desc
			end

			vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
		end
		map("n", "<leader>Ci", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
		map("n", "<leader>Ct", "<cmd>GoMod tidy<cr>", "Tidy")
		map("n", "<leader>Ca", "<cmd>GoTestAdd<Cr>", "Add Test")
		map("n", "<leader>CA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
		map("n", "<leader>Ce", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
		map("n", "<leader>Cg", "<cmd>GoGenerate<Cr>", "Go Generate")
		map("n", "<leader>Cf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
		map("n", "<leader>Cc", "<cmd>GoCmt<Cr>", "Generate Comment")
		map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
	end,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = require("lvim.lsp").common_capabilities(),
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			codelenses = {
				generate = false,
				gc_details = true,
				test = true,
				tidy = true,
			},
		},
	},
})

lsp_manager.setup("intelephense")

local status_ok, gopher = pcall(require, "gopher")
if not status_ok then
	return
end

gopher.setup({
	commands = {
		go = "go",
		gomodifytags = "gomodifytags",
		gotests = "gotests",
		impl = "impl",
		iferr = "iferr",
	},
})

------------------------
-- VIM
------------------------
vim.opt.listchars = {
	tab = "▸ ",
	nbsp = "␣",
	trail = "•",
	extends = "▶",
	precedes = "◀",
	eol = "¬",
}

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.go" },
--   command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4"
-- })

-- Claude Code integration
-- Requires: `npm install -g @anthropic-ai/claude-code`

return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = "VeryLazy",
		opts = {
			terminal = {
				provider = "native",
				split_side = "right", -- "left" or "right"
				split_width_percentage = 0.40, -- 40% of editor width
				auto_close = true,
			},
			track_selection = true,
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
			},
		},
		keys = {
			-- Using ,c prefix to match your existing ,a (LSP) and ,t (tree) conventions
			{ ",cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
			{ ",cn", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last Claude session" },
			{ ",cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code window" },

			-- Accept/deny diffs proposed by Claude
			{ ",ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
			{ ",cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },

			-- Send visual selection to Claude with file context
			{
				",cs",
				"<cmd>ClaudeCodeSend<cr>",
				mode = { "v" },
				desc = "Send selection to Claude",
			},

			-- Add current buffer to Claude context
			{ ",cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude context" },
		},
	},
}

-- Claude Code integration
-- Requires: `npm install -g @anthropic-ai/claude-code`

return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = "VeryLazy",
		opts = {
			terminal = {
				provider = "snacks",
				split_side = "right",
				split_width_percentage = 0.40,
				auto_close = true,
			},
			track_selection = true,
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
			},
		},
		keys = {
			-- ,C prefix (capital C) avoids conflicts with NERDCommenter (,c*) and LSP (,a*)
			{ ",Cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
			{ ",Cn", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last Claude session" },
			{ ",Cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume a Claude session" },
			{ ",Cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code window" },

			-- Accept/deny diffs proposed by Claude
			{ ",Ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
			{ ",Cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },

			-- Send visual selection to Claude with file context
			{
				",Cs",
				"<cmd>ClaudeCodeSend<cr>",
				mode = { "v" },
				desc = "Send selection to Claude",
			},

			-- Add current buffer to Claude context
			{ ",Cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude context" },
		},
	},
}

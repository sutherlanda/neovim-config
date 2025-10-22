-- lua/plugins/misc.lua
return {
	-- Temporarily disabled to debug filetype detection issue
	-- {
	--   "tpope/vim-sensible",
	--   lazy = false,
	-- },
	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},
	{
		"preservim/nerdcommenter",
		event = "VeryLazy",
	},
	{
		"airblade/vim-rooter",
		event = "VeryLazy",
		config = function()
			vim.g.rooter_patterns = { ".git", ".git/", "shell.sh", "shell.nix" }
			vim.g.rooter_silent_chdir = 1
		end,
	},
	{
		"sansyrox/vim-python-virtualenv",
		ft = "python",
	},
}

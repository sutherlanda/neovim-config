local M = {}

-- List of available themes
M.themes = {
	"tokyonight",
	"tokyonight-night",
	"tokyonight-storm",
	"tokyonight-day",
	"catppuccin",
	"catppuccin-latte",
	"catppuccin-frappe",
	"catppuccin-macchiato",
	"catppuccin-mocha",
	"kanagawa",
	"kanagawa-wave",
	"kanagawa-dragon",
	"rose-pine",
	"rose-pine-main",
	"rose-pine-moon",
	"rose-pine-dawn",
	"github_dark",
	"github_dark_dimmed",
	"github_light",
}

-- Function to switch theme
M.switch_theme = function(theme)
	vim.cmd.colorscheme(theme)
	-- Optionally save to a file to persist across sessions
	local config_path = vim.fn.stdpath("config") .. "/lua/config/current_theme.lua"
	local file = io.open(config_path, "w")
	if file then
		file:write(string.format('return "%s"', theme))
		file:close()
	end
	vim.notify("Theme changed to: " .. theme, vim.log.levels.INFO)
end

-- Telescope picker for themes
M.pick_theme = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Select Theme",
			finder = finders.new_table({
				results = M.themes,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					M.switch_theme(selection[1])
				end)
				return true
			end,
		})
		:find()
end

return M

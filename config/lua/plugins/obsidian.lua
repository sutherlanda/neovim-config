return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- Use latest release
		lazy = true,
		ft = "markdown", -- Only load for markdown files
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp", -- You already have this from completion.lua
			"nvim-telescope/telescope.nvim", -- You already have this
		},
		config = function()
			require("obsidian").setup({
				-- Specify your vault directory
				-- Update this path to where you want your novel/notes
				workspaces = {
					{
						name = "novel",
						path = "~/Documents/novel-vault", -- Change this to your preferred location
					},
					{
						name = "personal",
						path = "~/Documents/notes", -- Optional: add other vaults
					},
				},

				-- Optional: Set a default vault
				-- If you only use one vault, you can uncomment this:
				-- daily_notes = {
				--   folder = "daily",
				--   date_format = "%Y-%m-%d",
				-- },

				-- Completion settings
				completion = {
					nvim_cmp = true,
					min_chars = 2,
				},

				-- Notes settings
				notes_subdir = "notes",
				new_notes_location = "notes_subdir",

				-- Note ID generation (for unique note names)
				note_id_func = function(title)
					-- If title is given, use it as the note ID
					-- This makes it easier to have human-readable filenames
					if title ~= nil then
						return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						-- If no title, generate a unique ID with timestamp
						return tostring(os.time())
					end
				end,

				-- Frontmatter settings (for metadata in notes)
				note_frontmatter_func = function(note)
					local out = {
						id = note.id,
						aliases = note.aliases,
						tags = note.tags,
						created = os.date("%Y-%m-%d %H:%M:%S"),
					}

					-- Add title if it's different from ID
					if note.title and note.id ~= note.title then
						out.title = note.title
					end

					return out
				end,

				-- Follow URL with gx
				follow_url_func = function(url)
					vim.fn.jobstart({ "xdg-open", url }) -- Linux
					-- vim.fn.jobstart({"open", url}) -- macOS
					-- vim.cmd("!start " .. url) -- Windows
				end,

				-- UI settings
				ui = {
					enable = true,
					update_debounce = 200,
					checkboxes = {
						[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
						["x"] = { char = "", hl_group = "ObsidianDone" },
						[">"] = { char = "", hl_group = "ObsidianRightArrow" },
						["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
					},
					external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
					reference_text = { hl_group = "ObsidianRefText" },
					highlight_text = { hl_group = "ObsidianHighlightText" },
					tags = { hl_group = "ObsidianTag" },
				},

				-- Attachments (images, files)
				attachments = {
					img_folder = "attachments",
				},

				-- Templates
				templates = {
					subdir = "templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M",
				},

				-- Disable certain features if you don't need them
				disable_frontmatter = false,

				-- Mappings (these will only work in markdown files)
				mappings = {
					-- "Obsidian follow"
					["gf"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true },
					},
					-- Toggle checkbox
					["<leader>ch"] = {
						action = function()
							return require("obsidian").util.toggle_checkbox()
						end,
						opts = { buffer = true },
					},
				},
			})

			-- Additional keybindings (global, not just in markdown files)
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }

			-- Note: These align with your existing leader key (,) pattern

			-- Quick notes
			map("n", "<leader>on", "<cmd>ObsidianNew<cr>", vim.tbl_extend("force", opts, { desc = "New note" }))
			map(
				"n",
				"<leader>oq",
				"<cmd>ObsidianQuickSwitch<cr>",
				vim.tbl_extend("force", opts, { desc = "Quick switch notes" })
			)
			map("n", "<leader>of", "<cmd>ObsidianSearch<cr>", vim.tbl_extend("force", opts, { desc = "Search notes" }))

			-- Today's daily note
			map(
				"n",
				"<leader>ot",
				"<cmd>ObsidianToday<cr>",
				vim.tbl_extend("force", opts, { desc = "Open today's note" })
			)

			-- Links
			map("n", "<leader>ol", "<cmd>ObsidianLink<cr>", vim.tbl_extend("force", opts, { desc = "Insert link" }))
			map(
				"n",
				"<leader>oL",
				"<cmd>ObsidianLinkNew<cr>",
				vim.tbl_extend("force", opts, { desc = "Create link to new note" })
			)
			map("v", "<leader>ol", "<cmd>ObsidianLink<cr>", vim.tbl_extend("force", opts, { desc = "Link selection" }))
			map(
				"v",
				"<leader>oL",
				"<cmd>ObsidianLinkNew<cr>",
				vim.tbl_extend("force", opts, { desc = "Link selection to new note" })
			)

			-- Backlinks
			map(
				"n",
				"<leader>ob",
				"<cmd>ObsidianBacklinks<cr>",
				vim.tbl_extend("force", opts, { desc = "Show backlinks" })
			)

			-- Tags
			map("n", "<leader>og", "<cmd>ObsidianTags<cr>", vim.tbl_extend("force", opts, { desc = "Search tags" }))

			-- Templates
			map(
				"n",
				"<leader>oT",
				"<cmd>ObsidianTemplate<cr>",
				vim.tbl_extend("force", opts, { desc = "Insert template" })
			)

			-- Open in Obsidian app (if installed)
			map(
				"n",
				"<leader>oo",
				"<cmd>ObsidianOpen<cr>",
				vim.tbl_extend("force", opts, { desc = "Open in Obsidian app" })
			)

			-- Workspace switching (if you have multiple vaults)
			map(
				"n",
				"<leader>ow",
				"<cmd>ObsidianWorkspace<cr>",
				vim.tbl_extend("force", opts, { desc = "Switch workspace" })
			)
		end,
	},
}

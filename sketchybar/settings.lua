local colors = require("colors")
local icons = require("icons")

return {
	paddings = 3,
	group_paddings = 5,
	modes = {
		main = {
			icon = icons.rebel,
			color = colors.rainbow[1],
		},
		service = {
			icon = icons.nuke,
			color = 0xffff9e64,
		},
	},
	bar = {
		height = 36,
		padding = {
			x = 10,
			y = 0,
		},
		background = colors.transparent,
	},
	items = {
		height = 26,
		gap = 5,
		padding = {
			right = 16,
			left = 12,
			top = 0,
			bottom = 0,
		},
		default_color = function()
			return colors.grey
		end,
		highlight_color = function()
			return colors.yellow
		end,
		colors = {
			background = colors.transparent,
		},
		corner_radius = 6,
	},

	icons = "sketchybar-app-font:Regular:16.0", -- alternatively available: NerdFont

	font = {
		text = "JetBrainsMono Nerd Font",
		numbers = "JetBrainsMono Nerd Font",
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
		},
	},
}

-- Shared helpers, exposed as the global `Craftzdog` (see init.lua).
return {
	editor = require("craftzdog.utils.editor"),
	git = require("craftzdog.utils.git"),
	icons = require("craftzdog.utils.icons"),
	lualine = require("craftzdog.utils.lualine"),
	tabline = require("craftzdog.utils.tabline"),
}

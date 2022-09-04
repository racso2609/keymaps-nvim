local M = {}
local keymap = vim.keymap.set

M.setup = function(shortcuts)
	for _, activator in ipairs(shortcuts) do
		local wikiInfo = {}
		for _, prefix in ipairs(activator.keymaps) do
			wikiInfo[prefix.prefix] = { name = prefix.name }
			for _, command in ipairs(prefix.commands) do
				local lhs = activator.activator .. prefix.prefix .. command.key
				local rhs = command.command

				local mode
				if command.mode == "all" then
					mode = ""
				elseif command.mode then
					mode = command.mode
				else
					mode = "n"
				end

				keymap(mode, lhs, rhs, command.options)
				wikiInfo[prefix.prefix][command.key] = { name = command.name }
			end
		end

		local status, wk = pcall(require, "which-key")
		if status then
			wk.register(wikiInfo, { prefix = activator.activator })
		end
	end
end

print("Plugin start")
return M

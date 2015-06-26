local Command = require("Command")
local Server = require("Server")

Command:register{
	name = "help",
	permission = "foxbukkit.help",
	args = {
		{
			name = "command",
			type = "string",
			required = false
		}
	},
	run = function(self, ply, args)
		if args.command then
			local info = Command:getInfo(args.command)
			if not info or not ply:hasPermission(info:get("permission")) then
				ply:sendError("Command not found")
				return
			end
			ply:sendReply(info:get("help") or "No help text available")
			ply:sendReply(info:get("usage") or "No usage text available")
			return
		end

		local displayedCmds = {}
		local it = Command:getCommands():entrySet():iterator()
		while it:hasNext() do
			local entry = it:next()
			local cmd = entry:getKey()
			local info = entry:getValue()
			if ply:hasPermission(info:get("permission")) then
				table.insert(displayedCmds, "/" .. cmd)
			end
		end
		ply:sendReply("Commands: " .. table.concat(displayedCmds, ", "))
	end
}
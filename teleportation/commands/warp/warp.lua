local Command = require("Command")
local Warp = require("Warp")

Command:register{
	name = "warp",
	action = {
		format = "%s warped to %s"
	},
	arguments = {
		{
			name = "name",
			type = "string",
			required = false
		}
	},
	run = function(self, ply, args)
		if not args.name then
			--TODO: LIST
			return
		end
		local warp = Warp:get(args.name)
		if not warp then
			ply:sendError("Warp not found")
			return
		end
		if not warp:isAllowed(ply) then
			ply:sendError("Permission denied")
			return
		end
		ply:teleport(warp.location)
		self:sendActionReply(ply, nil, {}, warp.name)
	end
}

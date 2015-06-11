local Command = require("Command")
local Warp = require("Warp")

Command:register{
	name = "mkwarp",
	action = {
		format = "%s created warp %s"
	},
	arguments = {
		{
			name = "name",
			type = "string"
		}
	},
	run = function(self, ply, args)
		local warp = Warp:get(args.name)
		if warp then
			ply:sendError("Warp already exists")
			return
		end
		warp = Warp:make(args.name, ply)
		warp:save()
		self:sendActionReply(ply, nil, {}, args.name)
	end
}

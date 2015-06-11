local Command = require("Command")
local Locationstack = require("Locationstack")
require("Homepoint")

Command:register{
	name = "home",
	action = {
		format = "%s went to %s home point %s",
		isProperty = true
	},
	arguments = {
		{
			name = "name",
			type = "string",
			required = false,
			default = "default"
		}
	},
	run = function(self, ply, args)
		local home = ply:getHome(args.name)
		if not home then
			ply:sendError("Home not found")
			return
		end
		Locationstack:add(ply)
		ply:teleport(home)
		self:sendActionReply(ply, ply, {}, args.name)
	end
}

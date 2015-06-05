local Command = require("Command")
require("Homepoint")

Command:register{
	name = "sethome",
	action = {
		format = "%s set %s home point %s",
		isProperty = true
	},
	arguments = {
		{
			name = "name",
			type = "string"
		}
	},
	run = function(self, ply, args)
		ply:setHome(args.name, ply:getLocation())
		self:sendActionReply(ply, ply, {}, args.name)
	end
}
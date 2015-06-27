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
			type = "string",
			required = false,
			default = "default"
		}
	},
	run = function(self, ply, args, flags)
		local overrides = {}
		if(flags:contains("d")) then
			overrides.format = "%s deleted %s home point %s"
			ply:setHome(args.name, nil)
		else
			ply:setHome(args.name, ply:getLocation())
		end
		self:sendActionReply(ply, ply, overrides, args.name)
	end
}
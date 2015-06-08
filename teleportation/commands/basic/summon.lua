local Command = require("Command")
local Permission = require("Permission")

Command:register{
	name = "summon",
	action = {
		format = "%s summoned %s",
		isProperty = false
	},
	arguments = {
		{
			name = "target",
			type = "players",
			required = true,
			immunityRequirement = Permission.Immunity.GREATER
		}
	},
	run = function(self, ply, args, flags)
		for _, target in next, args.target do
			target:teleport(ply.__entity)
		end
		self:sendActionReply(ply, args.target, {})
	end
}

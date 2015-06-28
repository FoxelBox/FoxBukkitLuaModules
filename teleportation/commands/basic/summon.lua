local Command = require("Command")
local Permission = require("Permission")
local Locationstack = require("Locationstack")

Command:register{
	name = "summon",
	action = {
		format = "%s summoned %s",
		isProperty = false
	},
	permissionOther = false,
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
			Locationstack:add(target)
			target:teleport(ply)
		end
		self:sendActionReply(ply, args.target, {})
	end
}

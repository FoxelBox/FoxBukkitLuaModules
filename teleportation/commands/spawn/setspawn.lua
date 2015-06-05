local Command = require("Command")
local Permission = require("Permission")
local Spawnpoint = require("Spawnpoint")

Command:register{
	name = "setspawn",
	action = {
		format = "%s set the spawnpoint of group %s",
		isProperty = false,
		broadcast = true
	},
	arguments = {
		{
			name = "group",
			type = "string"
		}
	},
	run = function(self, ply, args)
		if Permission:getGroupImmunityLevel(args.group) < ply:getImmunityLevel() then
			Spawnpoint:setGroupSpawn(ply, args.group)
			self:sendActionReply(ply, nil, {}, args.group)
		else
			ply:sendError("Permission denied")
		end
	end
}
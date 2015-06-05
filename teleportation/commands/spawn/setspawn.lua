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
		if args.group == "default" or Permission:getGroupImmunityLevel(args.group) < ply:getImmunityLevel() then
			Spawnpoint:setGroupSpawn(args.group, ply:getLocation())
			self:sendActionReply(ply, nil, {}, args.group)
		else
			ply:sendError("Permission denied")
		end
	end
}
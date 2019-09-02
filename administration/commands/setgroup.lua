local Command = require("Command")
local Server = require("Server")
local Player = require("Player")
local Permission = require("Permission")

Command:register{
	name = "setgroup",
	action = {
		format = "%s set %s group to %s",
		isProperty = true
	},
	arguments = {
		{
			name = "target",
			type = "player",
			defaultSelf = false,
			required = true,
			immunityRequirement = Permission.Immunity.GREATER
		},
		{
			name = "group",
			type = "string",
			required = true
		}
	},
	run = function(self, ply, args)
		local group = args.group
		if Permission:getGroupImmunityLevel(group) >= ply:getImmunityLevel() then
			ply:sendReply("Permission denied")
			return
		end

		Permission:setGroup(args.target, group)
		self:sendActionReply(ply, args.target, {}, group)
	end
}

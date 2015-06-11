local Command = require("Command")
local Permission = require("Permission")
local Event = require("Event")
local Player = require("Player")

local EntityTypePLAYER = bindClass("org.bukkit.entity.EntityType").PLAYER

Event:register{
	class = "org.bukkit.event.entity.EntityDamageEvent",
	priority = Event.Priority.HIGHEST,
	ignoreCancelled = true,
	run = function(self, event)
		if event:getEntityType() == EntityTypePLAYER and Player:extend(event:getEntity())._godModeEnabled then
			event:setCancelled(true)
		end
	end
}

Command:register{
	name = "god",
	action = {
		format = "%s set god mode on %s to %s",
		isProperty = false,
		broadcast = true
	},
	arguments = {
		{
			name = "enabled",
			type = "boolean",
			required = false
		},
		{
			name = "target",
			type = "player",
			defaultSelf = true,
			required = false,
			immunityRequirement = Permission.Immunity.GREATER
		}
	},
	run = function(self, ply, args)
		local enabled = args.enabled
		if enabled == nil then
			enabled = not args.target._godModeEnabled
		end
		args.target._godModeEnabled = enabled
		self:sendActionReply(ply, args.target, {}, enabled and "enabled" or "disabled")
	end
}
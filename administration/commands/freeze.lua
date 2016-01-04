local Command = require("Command")
local Server = require("Server")
local Player = require("Player")

local Event = require("Event")
Event:register{
	class = "org.bukkit.event.player.PlayerMoveEvent",
	priority = Event.Priority.HIGH,
	run = function(self, event)
		local ply = Player:extend(event:getPlayer())
		if ply.frozen then
			event:setCancelled(true)
		else
			event:setCancelled(false)
		end
	end
}



Command:register{
	name = "freeze",
	aliases = {"unfreeze"},



	action = {
		format = "%s unfroze %s",
		isProperty = false
	},

	arguments = {
		{
			name = "target",
			type = "player",
			defaultSelf = false,
			required = true
		}
	},

	run = function(self, ply, args)
		local override = {}

		if not args.target.frozen then
			override.format = "%s froze %s"
		end
		args.target.frozen = not args.target.frozen
		self:sendActionReply(ply, args.target, override, {})
	end
}


local Command = require("Command")
local Server = require("Server")
local Player = require("Player")

local Event = require("Event")
Event:register{
	class = "org.bukkit.event.player.AsyncPlayerChatEvent",
	priority = Event.Priority.HIGH,
	run = function(self, event)
		local msg = event:getMessage()
		local ply = Player:extend(event:getPlayer())
		if ply.nocaps then
			msg = string.lower(msg)
			event:setMessage(msg)
		end
	end
}

Command:register{
	name = "nocaps",



		action = {
			format = "%s enabled caps for %s",
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

	if not args.target.nocaps then
		override.format = "%s disabled caps for %s"
	end
		args.target.nocaps = not args.target.nocaps
		self:sendActionReply(ply, args.target, override, {})
	end
}

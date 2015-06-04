local Command = require("Command")
local Player = require("Player")
local Event = require("Event")

local fixedServerTime = -1

local function setPlayerFixedTime(ply, time)
	if time >= 0 then
		if time < 6 then
			time = time + 18
		else
			time = time - 6
		end
		ply:setPlayerTime(time * 1000, false)
	else
		ply:resetPlayerTime()
	end	
end

Event:register{
	class = "org.bukkit.event.player.PlayerJoinEvent",
	priority = Event.Priority.MONITOR,
	ignoreCancelled = true,
	run = function(self, event)
		setPlayerFixedTime(event:getPlayer(), fixedServerTime)
	end
}

Command:register{
	name = "time",
	arguments = {
		{
			name = "time",
			type = "number",
			aliases = {
				day = 12,
				night = 0,
				none = -1
			},
			required = false,
			default = -1
		}
	},
	run = function(self, ply, args)
		setPlayerFixedTime(ply, args.time)
	end
}

Command:register{
	name = "servertime",
	arguments = {
		{
			name = "time",
			type = "number",
			aliases = {
				day = 12,
				night = 0,
				none = -1
			},
			required = false,
			default = -1
		}
	},
	run = function(self, ply, args)
		fixedServerTime = args.time
		for _, ply in pairs(Player:getAll()) do
			setPlayerFixedTime(ply, args.time)
		end
	end
}

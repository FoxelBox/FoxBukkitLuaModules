local Command = require("Command")
local Player = require("Player")
local Event = require("Event")

local WeatherType = bindClass("org.bukkit.WeatherType")

local fixedServerWeather = nil

local function setPlayerFixedWeather(ply)
	local weather = ply._fixedWeather or fixedServerWeather
	if weather then
		ply:setPlayerWeather(weather)
	else
		ply:resetPlayerWeather()
	end	
end

Event:register{
	class = "org.bukkit.event.player.PlayerJoinEvent",
	priority = Event.Priority.MONITOR,
	ignoreCancelled = true,
	run = function(self, event)
		local ply = Player:extend(event:getPlayer())
		setPlayerFixedWeather(ply)
	end
}

Command:register{
	name = "weather",
	action = {
		format = "%s set %s weather to %s",
		isProperty = true
	},
	arguments = {
		{
			name = "weather",
			type = "enum",
			enum = WeatherType,
			required = false
		}
	},
	run = function(self, ply, args)
		local formatOverride = {}
		if not args.weather then
			ply._fixedWeather = nil
			formatOverride.format = "%s reset %s weather to server weather"
		else
			ply._fixedWeather = args.weather
		end
		setPlayerFixedWeather(ply)
		self:sendActionReply(ply, ply, formatOverride, args.weather and args.weather:name() or "")
	end
}

Command:register{
	name = "serverweather",
	action = {
		format = "%s set server weather to %s",
		broadcast = true
	},
	arguments = {
		{
			name = "weather",
			type = "enum",
			enum = WeatherType,
			required = false
		}
	},
	run = function(self, ply, args)
		fixedServerWeather = args.weather
		for _, ply in next, Player:getAll() do
			setPlayerFixedWeather(ply, args.weather)
		end
		local formatOverride = {}
		if not args.weather then
			formatOverride.format = "%s reset server weather to normal weather"
		end
		setPlayerFixedWeather(ply)
		self:sendActionReply(ply, nil, formatOverride, args.weather and args.weather:name() or "")
	end
}

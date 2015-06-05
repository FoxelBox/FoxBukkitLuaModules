local Player = require("Player")

local Homepoint = {
	getPlayerHome = function(self, ply, name)
		if not ply.homepoints then
			return
		end
		return ply.homepoints[name or "default"]
	end,

	getPlayerHomes = function(self, ply)
		return ply.homepoints or {}
	end,

	setPlayerHome = function(self, ply, name, location)
		location = location or ply:getLocation()
		ply.homepoints = ply.homepoints or {}
		ply.homepoints[name or "default"] = location
	end
}

Player:addExtensions{
	getHome = function(self, name)
		return Homepoint:getPlayerHome(self, name)
	end,

	getHomes = function(self)
		return Homepoint:getPlayerHomes(self)
	end,
	
	setHome = function(self, name, location)
		return Homepoint:setPlayerHome(self, name, location)
	end
}

return Homepoint
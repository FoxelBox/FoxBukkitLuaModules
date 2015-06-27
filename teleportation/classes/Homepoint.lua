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

	clearPlayerHomes = function(self, ply)
		ply.homepoints = nil
	end,

	setPlayerHome = function(self, ply, name, location)
		ply.homepoints = ply.homepoints or {}
		ply.homepoints[name or "default"] = location
		ply:__save()
	end
}

Player:addExtensions{
	getHome = function(self, name)
		return Homepoint:getPlayerHome(self, name)
	end,

	getHomes = function(self)
		return Homepoint:getPlayerHomes(self)
	end,

	clearHomes = function(self)
		return Homepoint:clearPlayerHomes(self)
	end,
	
	setHome = function(self, name, location)
		return Homepoint:setPlayerHome(self, name, location)
	end
}

return Homepoint
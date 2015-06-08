local Player = require('Player')

local warps = require('Persister'):get('warps')

local WarpMode = {
	PRIVATE = 1,
	PUBLIC = 2,
	PERMISSION = 3	
}

local Warp

local _warp_mt = {
	__metatable = false,

	__newindex = function()
		error("Readonly")
	end,

	isAllowed = function(self, ply)
		if self:canModify(ply) or 
			(ply:hasPermission("foxbukkit.teleportation.warp.override.teleport") and
			 ply:fitsImmunityRequirement(self.owner, Permission.Immunity.GREATER_OR_EQUAL))
		then
			return true
		end

		if self.mode == WarpMode.PUBLIC then
			return true
		elseif self.mode == WarpMode.PERMISSION then
			return ply:hasPermission(self.permission)
		elseif self.mode == WarpMode.PRIVATE then
			return self.guests[ply]
		end
	end,

	canModify = function(self, ply)
		return ply == self.owner or
				(ply:hasPermission("foxbukkit.teleportation.warp.override.modify") and
				 ply:fitsImmunityRequirement(self.owner, Permission.Immunity.GREATER))
	end,

	addGuest = function(self, ply)
		self.guests[ply] = true
	end,

	removeGuest = function(self, ply)
		self.guests[ply] = nil
	end,

	delete = function(self)
		Warp:delete(self)
	end,

	save = function()
		warps:__save()
	end
}

_warp_mt.__index = _warp_mt

Warp = {
	get = function(self, name)
		return warps[name]
	end,

	make = function(self, name, ply)
		local warp = setmetatable({
			owner = ply,
			location = ply:getLocation(),
			name = name,
			guests = {},
			permission = "",
			mode = Warp.Mode.PRIVATE
		}, _warp_mt)
		warps[name] = warp
		return warp
	end,

	add = function(self, warp)
		warps[warp.name] = warp
	end,

	delete = function(self, warp)
		if type(warp) ~= "string" then
			warp = warp.name
		end
		warps[warp] = nil
	end,

	getAll = function(self)
		return warps
	end,

	Mode = WarpMode
}

return Warp
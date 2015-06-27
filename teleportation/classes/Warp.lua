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
			return self.guests[ply:getUniqueId()]
		end
	end,

	canModify = function(self, ply)
		return ply:getUniqueId() == self.owner or
				self.ops[ply:getUniqueId()] or
				(ply:hasPermission("foxbukkit.teleportation.warp.override.modify") and
				 ply:fitsImmunityRequirement(self.owner, Permission.Immunity.GREATER))
	end,

	addOp = function(self, ply)
		self.ops[ply:getUniqueId()] = true
	end,

	removeOp = function(self, ply)
		self.ops[ply:getUniqueId()] = nil
	end,

	addGuest = function(self, ply)
		self.guests[ply:getUniqueId()] = true
	end,

	removeGuest = function(self, ply)
		self.guests[ply:getUniqueId()] = nil
	end,

	delete = function(self)
		Warp:delete(self)
	end,

	save = function()
		warps:__save()
	end
}

_warp_mt.__index = _warp_mt

for k, v in pairs(warps.__value) do
	warps.__value[k] = setmetatable(v, _warp_mt)
end

Warp = {
	get = function(self, name)
		return warps[name:lower()]
	end,

	make = function(self, name, ply)
		local warp = setmetatable({
			owner = ply:getUniqueId(),
			location = ply:getLocation(),
			name = name,
			guests = {},
			ops = {},
			permission = "",
			mode = Warp.Mode.PRIVATE
		}, _warp_mt)
		warps[name:lower()] = warp
		return warp
	end,

	add = function(self, warp)
		warps[warp.name:lower()] = warp
	end,

	delete = function(self, warp)
		if type(warp) ~= "string" then
			warp = warp.name:lower()
		end
		warps[warp] = nil
	end,

	getAll = function(self)
		return warps
	end,

	Mode = WarpMode
}

return Warp
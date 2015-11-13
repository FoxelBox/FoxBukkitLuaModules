local Command = require("Command")
local Warp = require("Warp")
local Locationstack = require("Locationstack")

Command:register{
	name = "warp",
	action = {
		format = "%s warped to %s"
	},
	arguments = {
		{
			name = "name",
			type = "string",
			required = false
		}
	},
	run = function(self, ply, args, flags)
		if not args.name then
			local warpNames = {}
			for _, warp in pairs(Warp:getAll()) do
				if warp:canModify(ply) then
					table.insert(warpNames, '\xC2\xA78@\xC2\xA7f' .. warp.name)
				elseif not warp.hidden and warp:isAllowed(ply) then
					table.insert(warpNames, warp.name)
				end
			end
			ply:sendReply("Warps for you: " .. table.concat(warpNames, ", "))
			return
		end
		local warp = Warp:get(args.name)
		if not warp then
			ply:sendError("Warp not found")
			return
		end
		if not warp:isAllowed(ply) then
			ply:sendError("Permission denied")
			return
		end

		local doLightning = flags:contains("l")
		if doLightning then
			harmlessLightning(ply:getLocation())
		end

		Locationstack:add(ply)
		ply:teleport(warp.location)

		if doLightning then
			harmlessLightning(ply:getLocation())
		end

		self:sendActionReply(ply, nil, {}, warp.name)
	end
}

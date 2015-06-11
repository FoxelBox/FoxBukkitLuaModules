local Command = require("Command")
local Locationstack = require("Locationstack")

Command:register{
	name = "back",
	arguments = {},
	run = function(self, ply, args, flags)
		local oldLocation = Locationstack:pop(ply)
		if oldLocation then
			ply:teleport(oldLocation)
			ply:sendReply("Went back")
			return
		end
		ply:sendError("No location on stack")
	end
}
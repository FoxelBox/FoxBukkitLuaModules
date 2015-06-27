local Command = require("Command")
local Player = require("Player")
local Permission = require("Permission")

local table_concat = table.concat

Command:register{
	name = "cexec",
	run = function(self, ply, args)
		local targets = Player:find(self.makePlayerFindConstraint({
			immunityRequirement = Permission.Immunity.GREATER
		}, args[1], ply, self))
		if #targets < 1 then
			ply:sendError("No appropriate target found")
			return
		end
		local args = table_concat(args, " ", 2)
		for _, target in next, targets do
			target:chat(args)
		end
		ply:sendReply("Cexec dispatched")
	end
}
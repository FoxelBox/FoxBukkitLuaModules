local Command = require("Command")
local Server = require("Server")

local table_concat = table.concat

Command:register{
	name = "at",
	run = function(self, ply, args)
		local time = args[1]
		local args = table_concat(args, " ", 2)
		Server:runOnMainThread(function()
			ply:chat(args)
		end, time * 20)
	end
}
local Command = require("Command")
local Server = require("Server")

local table_concat = table.concat

Command:register{
	name = "rcon",
	run = function(self, ply, args)
		Server:runConsoleCommand(table_concat(args, " ", 1))
		ply:sendReply("Command sent to console")
	end
}
local Command = require("Command")
local Permission = require("Permission")
local Locationstack = require("Locationstack")
local Chat = require("Chat")
local Player = require("Player")
local Questioner = require("Questioner")

Command:register{
	name = "tpa",
	action = {
		format = "%s teleported to %s",
		isProperty = false
	},
	permissionOther = false,
	arguments = {
		{
			name = "target",
			type = "player",
			required = true
		}
	},
	run = function(self, ply, args, flags)
		local cmd = self

		if flags:contains("f") then
			ply:forgetConfirmation("tpa_" .. args.target:getUniqueId():toString())
			return
		end

		local question = args.target:askConfirmation("tpa_" .. ply:getUniqueId():toString(), function()
			Locationstack:add(ply)
			ply:teleport(args.target)
			cmd:sendActionReply(ply, args.target, {})
		end, function()
			cmd:sendActionReply(args.target, ply, {
				format = "%s denied %s teleport request",
				isProperty = true
			})
		end)

		if question then
			self:sendActionReply(ply, args.target, {
				format = "%s asked to teleport to %s"
			})
			args.target:sendReply(question.message)
		end
	end
}

local Player = require("Player")
local Event = require("Event")
local Chat = require("Chat")

local table_insert = table.insert
local table_concat = table.concat

Event:registerReadOnlyPlayerJoin(function(ply)
	local admintools = {}
	local played = ""
	if not ply.hasPlayedBefore then
		player = " has not played before."
	end
	table_insert(admintools, "<color name=\"dark_purple\">(FBAT)</color> " .. ply:getDisplayName() .. played)
	table_insert(admintools, Chat:makeButton("/who " .. ply:getName(), "Who", "aqua", true, false))
	table_insert(admintools, Chat:makeButton("/ipinfo " .. ply:getName(), "IP", "aqua", true, false))
	table_insert(admintools, Chat:makeButton("/mute " .. ply:getName(), "Mute", "gold", true, false))
	table_insert(admintools, Chat:makeButton("/ban " .. ply:getName() .. " ", "Ban", "red", false, false))
	Chat:sendLocalToPermission(table_concat(admintools, " "), "foxbukkit.opchat", nil)
end)
local Player = require("Player")
local Event = require("Event")
local Chat = require("Chat")

local table_insert = table.insert
local table_concat = table.concat

Event:registerReadOnlyPlayerJoin(function(ply)
	local admintools = {}
	table_insert(admintools, "<color name=\"dark_purple\">(FBAT)</color> " .. ply:getDisplayName())
	table_insert(admintools, Chat:makeButton("/ipinfo " .. ply:getName(), "IP", "aqua", true, false))
	table_insert(admintools, Chat:makeButton("/mute " .. ply:getName(), "Mute", "gold", true, false))
	table_insert(admintools, Chat:makeButton("/ban " .. ply:getName() .. " ", "Ban", "red", false, false))
	Chat:sendLocalToPermission(table_concat(admintools, " "), "foxbukkit.opchat", nil)
end)
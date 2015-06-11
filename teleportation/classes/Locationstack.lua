local table_insert = table.insert
local table_remove = table.remove

return {
	add = function(self, ply, location)
		if not ply._locationstack then
			ply._locationstack = {}
		end
		table_insert(ply._locationstack, location or ply:getLocation())
	end,

	pop = function(self, ply)
		if not ply._locationstack then
			return
		end
		return table_remove(ply._locationstack)
	end
}
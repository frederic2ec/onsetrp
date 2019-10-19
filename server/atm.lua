AtmObjectsCached = { }
AtmTable = { }

AddEvent("database:connected", function()
	mariadb_query(sql, "SELECT * FROM atm;", OnAtmLoaded)
end)

function OnAtmLoaded()
	for i=1,mariadb_get_row_count() do
		local result = mariadb_get_assoc(i)

		local id = math.tointeger(result["id"])
		local modelid = math.tointeger(result["modelid"])
		local x = tonumber(result["x"])
		local y = tonumber(result["y"])
		local z = tonumber(result["z"])
		local rx = tonumber(result["rx"])
		local ry = tonumber(result["ry"])
		local rz = tonumber(result["rz"])

		CreateAtm(id, modelid, x, y, z, rx, ry, rz)
	end

	print("Loaded "..#AtmTable.." ATMs")
end

AddEvent("OnPlayerLoggedIn", function(player)
	CallRemoteEvent(player, "atmSetup", AtmObjectsCached)
end)

function CreateAtm(id, modelid, x, y, z, rx, ry, rz)
	AtmTable[id] = { }
	AtmTable[id].object = CreateObject(modelid, x, y, z, rx, ry, rz)		
	AtmTable[id].text3d = CreateText3D("ATM\nPress E", 18, x, y, z + 200, 0, 0, 0)

	table.insert(AtmObjectsCached, AtmTable[id].object)
end

AddRemoteEvent("atmInteract", function(player, atmobject)
    local atm = GetAtmByObject(atmobject)
	if atm then
		local x, y, z = GetObjectLocation(atm.object)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 200 then
            CallRemoteEvent(player, "openAtm")
		end
	end
end)

function GetAtmByObject(atmobject)
	for _,v in pairs(AtmTable) do
		if v.object == atmobject then
			return v
		end
	end
	return nil
end

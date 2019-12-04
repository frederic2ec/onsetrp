local GasStationids = {}

AddRemoteEvent("gasStationSetup", function(gasStationObject)
    GasStationids = gasStationObject
end)

function OnKeyPress(key)
    if key == "E" then
        local NearestGasStation = GetNearestGasStation()
        local NearestVehicle = getNearestVehicle()
        if NearestGasStation ~= 0 and NearestVehicle ~= 0 then
            AddPlayerChat("called")
            CallRemoteEvent("StartRefuel", NearestVehicle)   
        end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function GetNearestGasStation()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
        
		if dist < 400.0 then
            for k,i in pairs(GasStationids) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end
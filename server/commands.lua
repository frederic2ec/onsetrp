-- Spawn vehicle command
function cmd_v(player, model)
	-- If the player did not pass any command parameter tell them how to use this chat command
	if (model == nil) then
		return AddPlayerChat(player, "Usage: /v <model number>")
	end

	model = tonumber(model)

	-- Check for valid vehicle model.
	if (model == nil or model < 1 or model > 23) then
		return AddPlayerChat(player, "Vehicle model "..model.." does not exist.")
	end

	-- Get the current player location, used to spawn the vehicle.
	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	-- Spawn the vehicle. 
	local vehicle = CreateVehicle(model, x, y, z, h)
	if (vehicle == false) then
		return AddPlayerChat(player, "Failed to spawn your vehicle")
	end

	-- Set the vehicle license plate and attach nitro
	SetVehicleLicensePlate(vehicle, "O N S E T")
	AttachVehicleNitro(vehicle, true)

	-- Never respawn player vehicles if it is left unoccupied
	SetVehicleRespawnParams(vehicle, false)

	if (model == 8) then
		-- Ambulance
		SetVehicleColor(vehicle, RGB(0.0, 60.0, 240.0))
		SetVehicleLicensePlate(vehicle, "EMS-02")
	end

	-- Finally set the player on the vehicles driver seat
	SetPlayerInVehicle(player, vehicle)

	AddPlayerChat(player, "Vehicle spawned! (New ID: "..vehicle..")")
end
AddCommand("v", cmd_v)

function cmd_vcolor(player, r, g, b)
	if (r == nil or g == nil or b == nil) then
		return AddPlayerChat(player, "Usage: /vcolor <r> <g> <b>")
	end

	local vehicle = GetPlayerVehicle(player)

	if (vehicle == 0) then
		return AddPlayerChat(player, "You must be in a vehicle")
	end

	if (GetPlayerVehicleSeat(player) ~= 1) then
		return AddPlayerChat(player, "You must be the driver of the vehicle")
	end

	SetVehicleColor(vehicle, RGB(r, g, b))
	AddPlayerChat(player, "New vehicle color set (HEX: "..GetVehicleColor(vehicle)..")")
end
AddCommand("vcolor", cmd_vcolor)

function cmd_spec(player, disable)
	local _disable = false
	if disable ~= nil then
		_disable = true
	end
	_disable = not _disable
	SetPlayerSpectate(player, _disable)
end
AddCommand("spec", cmd_spec)
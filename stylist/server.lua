local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

StylistNPCObjectsCached = { }
StylistNPCTable = { }
-- StylistNPCTable = {
-- 	{
-- 		location = { 180845, 182506, 1290, 180}
-- 	}
-- }

local PLAYER_SPAWN_POINT = { x = 204094, y = 180846, z = 1500 }

-- Event ----------------------------------------------------

AddEvent("OnPackageStart", function()
	for k,v in pairs(StylistNPCTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D(_("stylist").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(StylistNPCObjectsCached, v.npc)
	end
end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "stylistSetup", StylistNPCObjectsCached)
end)

AddRemoteEvent("stylistInteract", function(player, stylistobject)
    local stylist = GetStylistByObject(stylistobject)
	if stylist then
		local x, y, z = GetNPCLocation(stylist.npc)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150 then
			for k,v in pairs(StylistNPCTable) do
				if stylistobject == v.npc then
					CallRemoteEvent(player, "openStylist")
				end
			end  
		end
	end
end)

AddRemoteEvent("RotatePlayer", function(player, heading)
	SetPlayerHeading(player, heading)
end)

AddRemoteEvent("startModify", function(player, isCreation)
	local isCreation = isCreation or false

	if isCreation then
		SetPlayerDimension(player, player)
	end

	SetPlayerName(player,PlayerData[player].accountid)

	SetPlayerBusy(player)

	local currentClothes = { skins = PlayerData[player].clothing[6], hair = PlayerData[player].clothing[1], haircolors = PlayerData[player].clothing[2], tops = PlayerData[player].clothing[3], trousers = PlayerData[player].clothing[4], shoes = PlayerData[player].clothing[5] }
	CallRemoteEvent(player, "openModify", hairsModel, shirtsModel, pantsModel, shoesModel, hairsColor, currentClothes, isCreation)
end)

AddRemoteEvent("ModifyEvent", function(player, hairsChoice, shirtsChoice, pantsChoice, shoesChoice, colorChoice, skinChoice)
	local colorChoice = colorChoice or PlayerData[player].clothing[5]
	local skinChoice = skinChoice or PlayerData[player].clothing[6]

	local clothesRequest = "[\""..hairsChoice.."\",\""..colorChoice.."\",\""..shirtsChoice.."\",\""..pantsChoice.."\",\""..shoesChoice.."\",\""..skinChoice.."\"]"
	
	if PlayerData[player].created == 0 then
		PlayerData[player].created = 1
	else
		if GetPlayerCash(player) < 200 then
			return CallRemoteEvent(player, "MakeNotification", _("not_enought_cash"), "linear-gradient(to right, #ff5f6d, #ffc371)")
		else
			RemovePlayerCash(player, 200)
			CallRemoteEvent(player, "MakeNotification", _("clothes_changed"), "linear-gradient(to right, #00b09b, #96c93d)")
		end
	end

	local query = mariadb_prepare(sql, "UPDATE accounts SET clothing = '?', created = 1 WHERE id = ? LIMIT 1;",
		clothesRequest,
		player
	)
        
	mariadb_query(sql, query)
	
	PlayerData[player].clothing = {}
	table.insert(PlayerData[player].clothing, hairsChoice)
    table.insert(PlayerData[player].clothing, colorChoice)
    table.insert(PlayerData[player].clothing, shirtsChoice)
    table.insert(PlayerData[player].clothing, pantsChoice)
    table.insert(PlayerData[player].clothing, shoesChoice)
	table.insert(PlayerData[player].clothing, skinChoice)

	SetPlayerDimension(player, 0)
	SetPlayerNotBusy(player)

	for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
		if IsPlayerStreamedIn(player, v) then
			ChangeOtherPlayerClothes(v, player)
		end
    end

	UpdateClothes(player)
	SetPlayerLocation(player, PLAYER_SPAWN_POINT.x, PLAYER_SPAWN_POINT.y, PLAYER_SPAWN_POINT.z)
	SetPlayerName(player,PlayerData[player].accountid)
	SavePlayerAccount(player)
end)

-- Function ----------------------------------------------------

function GetStylistByObject(stylistobject)
	for k,v in pairs(StylistNPCTable) do
		if v.npc == stylistobject then
			return v
		end
	end
	return nil
end

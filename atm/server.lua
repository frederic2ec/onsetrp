local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AtmObjectsCached = { }
AtmTable = {
	{
		modelid = 33,
		location = {
			{ 212950, 190500, 1250 },
			{ 213419, 190723, 1250 },
			{ 212908, 189890, 1250 },
			{ 116650, 163194, 2980 },
			{ 129240, 77945, 1500 },
			{ -15000, -2385, 2000 },
			{ 43900, 133143, 1500 },
			{ 42246, 137850, 1500 },
			{ -168797, -39550, 1050 }
	 	},
		object = {}
	}
 }

 AddEvent("OnPackageStart", function()
	for k,v in pairs(AtmTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D(_("atm").."\n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(AtmObjectsCached, v.object[i])
		end
	end
	-- ATM in the gas station of the town
	CreateObject(494, -168797, -39550, 1050)

end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "atmSetup", AtmObjectsCached)
end)

AddRemoteEvent("atmInteract", function(player, atmobject)
    local atm, atmid = GetAtmByObject(atmobject)
	if atm then
		local x, y, z = GetPickupLocation(atm.object[atmid])
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250 then
			local bank = PlayerData[player].bank_balance
			local cash = GetPlayerCash(player)
			local playersIds = GetAllPlayers()
			playersNames = {}
			for k,v in pairs(playersIds) do
				playersNames[tostring(k)] = GetPlayerName(k)
			end
			CallRemoteEvent(player, "openAtm", bank, cash, playersNames)
		end
	end
end)

function GetAtmByObject(atmobject)
	for k,v in pairs(AtmTable) do
		for i,j in pairs(v.object) do
			if j == atmobject then
				return v,i
			end
		end
	end
	return nil
end

function withdrawAtm(player, amount)
	if tonumber(amount) <= 0 then return end
	if tonumber(amount) > PlayerData[player].bank_balance then
        CallRemoteEvent(player, "MakeNotification", _("withdraw_error"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        PlayerData[player].bank_balance = PlayerData[player].bank_balance - amount
        AddPlayerCash(player, amount)
        CallRemoteEvent(player, "MakeNotification",_("withdraw_success", amount, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
    end
end
AddRemoteEvent("withdrawAtm", withdrawAtm)

function depositAtm(player, amount)
	if tonumber(amount) <= 0 then return end
    if tonumber(amount) > GetPlayerCash(player) then
        CallRemoteEvent(player, "MakeNotification", _("deposit_error"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        RemovePlayerCash(player, amount)
        PlayerData[player].bank_balance = PlayerData[player].bank_balance + amount
        CallRemoteEvent(player, "MakeNotification", _("deposit_success", amount, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
    end
end
AddRemoteEvent("depositAtm", depositAtm)


AddRemoteEvent("transferAtm", function(player, amount, toplayer)
	if tonumber(amount) <= 0 then return end
	if tonumber(amount) > PlayerData[player].bank_balance then
        CallRemoteEvent(player, "MakeNotification", _("transfer_error"), "linear-gradient(to right, #ff5f6d, #ffc371)")
	else
        PlayerData[player].bank_balance = PlayerData[player].bank_balance - amount
        PlayerData[tonumber(toplayer)].bank_balance = PlayerData[tonumber(toplayer)].bank_balance  + amount
        CallRemoteEvent(player, "MakeNotification", _("transfer_success", amount, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
    end
end)

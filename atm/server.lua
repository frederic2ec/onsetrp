local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AtmObjectsCached = { }
AtmTable = {
	{
		modelid = 494,
		location = { 129221, 78053, 1478, 0, 90, 0 }
	}
 }

 AddEvent("OnPackageStart", function()
	for k,v in pairs(AtmTable) do
		v.object = CreateObject(v.modelid, v.location[1], v.location[2], v.location[3], v.location[4], v.location[5], v.location[6])
		CreateText3D(_("atm").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 200, 0, 0, 0)

		table.insert(AtmObjectsCached, v.object)
	end
end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "atmSetup", AtmObjectsCached)
end)

AddRemoteEvent("atmInteract", function(player, atmobject)
    local atm = GetAtmByObject(atmobject)
	if atm then
		local x, y, z = GetObjectLocation(atm.object)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 200 then
			getAtmData(player)
			CallRemoteEvent(player, "openAtm")
		end
	end
end)

function GetAtmByObject(atmobject)
	for k,v in pairs(AtmTable) do
		if v.object == atmobject then
			return v
		end
	end
	return nil
end

function getAtmData(player)
    bank = PlayerData[player].bank_balance
    cash = PlayerData[player].cash

    CallRemoteEvent(player, "updateAtm", bank, cash)
end
AddRemoteEvent("getAtmData", getAtmData)

function withdrawAtm(player, amount)
    if tonumber(amount) > PlayerData[player].bank_balance then
        AddPlayerChat(player, _("withdraw_error"))
    else
        PlayerData[player].bank_balance = PlayerData[player].bank_balance - amount
        PlayerData[player].cash = PlayerData[player].cash + amount
        AddPlayerChat(player, _("withdraw_success", amount).._("currency"))
        getAtmData(player)
    end
end
AddRemoteEvent("withdrawAtm", withdrawAtm)

function depositAtm(player, amount)
    if tonumber(amount) > PlayerData[player].cash then
        AddPlayerChat(player, _("deposit_error"))
    else
        PlayerData[player].cash = PlayerData[player].cash - amount
        PlayerData[player].bank_balance = PlayerData[player].bank_balance + amount
        AddPlayerChat(player, _("deposit_success", amount).._("currency"))

        getAtmData(player)
    end
end
AddRemoteEvent("depositAtm", depositAtm)

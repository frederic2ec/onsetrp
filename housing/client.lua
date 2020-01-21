local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local house
local houseBuy
local houseMenu

AddEvent("OnTranslationReady", function()
    houseBuy = Dialog.create(_("house_menu"), _("price").." {price}".._("currency"), _("buy"),  _("cancel"))
    houseMenu = Dialog.create(_("house_menu"), nil, _("set_spawn") , _("unlock_lock"), _("sell"), _("cancel") )
end)

AddEvent("OnKeyPress", function(key)
    if key == HOUSING_MENU_KEY and not GetPlayerBusy() then
        local NearestDoor = getNearestDoor()
        
        if NearestDoor ~= 0 then
            CallRemoteEvent("interactHouse", NearestDoor)
        end
    end
end)


function getNearestDoor()
    local x, y, z = GetPlayerLocation()

    for k,v in pairs(GetStreamedDoors()) do
        local x2, y2, z2 = GetDoorLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			return v
		end
    end
    return 0
end

AddRemoteEvent("OpenHouseBuy", function(houseid, price)
    house = houseid
    Dialog.setVariable(houseBuy, "price", price)
    Dialog.show(houseBuy)
end)

AddRemoteEvent("OpenHouseMenu", function(houseid, price) 
    house = houseid
    Dialog.setVariable(houseMenu, "price", math.ceil(price * 0.25))
    Dialog.show(houseMenu)
end)


AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == houseBuy then
        if button == 1 then
            CallRemoteEvent("BuyHouse", house)        
        end
    end

    if dialog == houseMenu then
        if button == 1 then
            CallRemoteEvent("SetHouseSpawn", house)
        end
        if button == 2 then
            CallRemoteEvent("UnlockHouse", house)
        end
        if button == 3 then
            CallRemoteEvent("SellHouse", house)
        end
    end
end)



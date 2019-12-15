local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gpsMenu
local currentWaypoint

local place = {
    gun_store = {},
    general_store = {},
    car_dealer = {},
    garage = {},
    atm = {},
    coke_field = {},
    coke_processing = {},
    weed_field = {},
    weed_processing = {},
    meth_field = {},
    meth_processing = {},
    
}

AddEvent("OnTranslationReady", function()
    gpsMenu = Dialog.create("GPS", nil, "Delete waypoint", "Set Waypoint", "Cancel")
    Dialog.addSelect(teleportPlaceMenu, 1, _("place"), 8)
end)

--[[ AddEvent("OnKeyPress", function( key )
    if key == "G" then
        Dialog.show(gpsMenu)
    end
end) ]]

AddRemoteEvent("ClientCreateWaypoint", function(name, x, y, z)
    if currentWaypoint ~= nil then
        DestroyWaypoint(currentWaypoint)
    end
    currentWaypoint = CreateWaypoint(tonumber(x), tonumber(y), tonumber(z), tostring(name))    
end)

AddRemoteEvent("ClientDestroyCurrentWaypoint", function()
    DestroyWaypoint(currentWaypoint)
end)


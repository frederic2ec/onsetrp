local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local bus_stops_ids = {}

local transportMenu

AddRemoteEvent("busStopSetup", function(busStopObject)
    bus_stops_ids = busStopObject    
end)

function OnKeyPress(key)
    if key == "E" and not GetPlayerBusy() then
        
        local NearestBusStop = GetNearestBusStop()
        if NearestBusStop ~= 0 then
            CallRemoteEvent("TransportMenuSGetListe")            
        end
        
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function GetNearestBusStop()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
        
		if dist < 400.0 then
            for k,i in pairs(bus_stops_ids) do                
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

AddEvent("OnTranslationReady", function()
    transportMenu = Dialog.create(_("transport_menu"), nil, _("transport_ok"), _("cancel"))
    Dialog.addSelect(transportMenu, 1, _("transport_stop_available"), 8)
end)

AddRemoteEvent("TransportMenuCOpenMenu", function(transportMenuListe)
    
    local transportListe = {}
    for k,v in pairs(transportMenuListe) do
        transportListe[k] = v.label.. " - "..v.distance.." m - "..v.amount.." $"
    end
    Dialog.setSelectLabeledOptions(transportMenu, 1, 1, transportListe)

    Dialog.show(transportMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }

    if dialog == transportMenu then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("transport_choose_stop"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else                
                CallRemoteEvent("TransportMenuSTeleportPlayer", args[1])
            end
        end
    end
end)

AddRemoteEvent("TransportMenuCPresentToastSuccess", function(transportMenuListe)
    MakeNotification(_("transport_bus_incoming"), "linear-gradient(to right, #00b09b, #96c93d)")
end)

AddRemoteEvent("TransportMenuCPresentNotEnoughMoney", function(transportMenuListe)
    MakeNotification(_("transport_not_enough_money"), "linear-gradient(to right, #ff5f6d, #ffc371)")
end)

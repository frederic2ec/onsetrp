local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local deliveryNPC
local deliveryNpcMenu
local deliveryMenu

AddRemoteEvent("SetupDelivery", function(deliverynpc) 
    deliveryNPC = deliverynpc
end)

AddEvent("OnTranslationReady", function()
    deliveryNpcMenu = Dialog.create("Delivery Menu", nil, "Start/Stop Delivery" ,_("cancel"))
    deliveryMenu = Dialog.create("Delivery Menu", nil, "Next delivery", "Finish delivery", _("cancel"))
end)

AddEvent("OnKeyPress", function( key )
    if key == "E" then
        local x, y, z = GetPlayerLocation()
        local x2, y2, z2 = GetNPCLocation(deliveryNPC)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			Dialog.show(deliveryNpcMenu)
		end
    end
    if key == "F3" then
        CallRemoteEvent("OpenDeliveryMenu")
    end
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
	if dialog == deliveryNpcMenu then
		if button == 1 then
            CallRemoteEvent("StartStopDelivery")
        end
    end
    if dialog == deliveryMenu then
        if button == 1 then
            CallRemoteEvent("NextDelivery")
        end
    end
end)

AddRemoteEvent("DeliveryMenu", function()
    Dialog.show(deliveryMenu)
end)

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

local gatherIds = {}
local processIds = {}
local sellNpcsIds = {}

local sellNpcMenu

AddRemoteEvent("gathering:setup", function(gatherObject, processObject, sellZoneNpcs)
    gatherIds = gatherObject
	processIds = processObject
	sellNpcsIds = sellZoneNpcs
end)

AddEvent("OnTranslationReady", function()
	-- SELLER MENU
	sellNpcMenu = Dialog.create(_("gathering_supplier"), nil, _("gathering_sell_my_goods"), _("cancel"))
end)

function OnKeyPress(key)
	if key == INTERACT_KEY and not IsPlayerInVehicle() then
        local NearestGatherZone = GetNearestGatherZone()
		local NearestProcessZone = GetNearestProcessZone()
		local NearestSellNpc = IsNearbyNpc(GetPlayerId(), sellNpcsIds) -- → c_police
		
        if NearestGatherZone ~= 0 and NearestProcessZone == 0 then                      
            CallRemoteEvent( "gathering:gather:start", NearestGatherZone)   
        end
        if NearestProcessZone ~= 0 then
            CallRemoteEvent( "gathering:process:start", NearestProcessZone)  
		end
		if NearestSellNpc ~= nil and NearestSellNpc ~= false then
			Dialog.show(sellNpcMenu)			
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == sellNpcMenu then
		if button == 1 then
			local NearestSellNpc = IsNearbyNpc(GetPlayerId(), sellNpcsIds) -- → c_police
            CallRemoteEvent("gathering:sell:start", NearestSellNpc)
		end
	end
end)

function GetNearestGatherZone()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 2000.0 then
			for k,i in pairs(gatherIds) do				
				for k2,v2 in pairs(i) do
					if v == v2 then return v end
				end
			end
		end
	end

	return 0
end

function GetNearestProcessZone()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			for k,i in pairs(processIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end
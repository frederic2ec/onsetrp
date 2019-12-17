local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local medicNpc
local reviving = false
AddEvent("OnTranslationReady", function()
    medicNpcMenu = Dialog.create(_("medic_menu"), nil, _("start_medic") , _("stop_medic") ,_("cancel"))
end)

AddRemoteEvent("SetupMedic", function(medicnpc) 
    medicNpc = medicnpc
end)

AddEvent("OnKeyPress", function( key )
    if key == "E" then
        local NearestMedic = GetNearestMedic()
        if NearestMedic ~= 0 then
            Dialog.show(medicNpcMenu)
		end
		
		if reviving == false then
            local x, y, z = GetPlayerLocation()

            for k,v in pairs (GetAllPlayersInSphere( x, y, z, 250.0 )) do
                if IsPlayerDead(v) then
                    CallRemoteEvent("MedicDoRevive",v)
                    reviving = true
                    Delay(6000,function()
                        reviving = false
                    end)
	                break
		        end
		    end
		end
    end
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
	if dialog == medicNpcMenu then
		if button == 1 then	 
		    CallRemoteEvent("StartMedicJob") 
        end
		if button == 2 then
			CallRemoteEvent("StopMedicJob") 
        end
    end
end)

function GetNearestMedic()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
			for k,i in pairs(medicNpc) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end



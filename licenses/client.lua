local Dialog = ImportPackage("dialogui")

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local licenseNpcMenu
local licenseNpcId = { }

AddEvent("OnTranslationReady", function()
    licenseNpcMenu = Dialog.create(_("license_shop"), nil, _("cancel"))
    Dialog.addSelect(licenseNpcMenu, 1, _("license"), 5)
    Dialog.setButtons(licenseNpcMenu, 1, _("buy"))
end)

AddRemoteEvent("LicenseSetup", function(licenseNpc)
    licenseNpcId = licenseNpc
end)

function OnKeyPress(key)
    if key == "E" and not onSpawn and not onCharacterCreation then
        local nearestNpc = GetNearestLicenseNpc()
        if nearestNpc ~= 0 then
            CallRemoteEvent("LicenseInteract", nearestNpc)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == licenseNpcMenu then
        local args = { ... }
        if args[1] == "" then
            MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        else
            CallRemoteEvent("BuyLicense", args[1])
        end
    end
end)

function GetNearestLicenseNpc()
	local x, y, z = GetPlayerLocation()

	for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            if npcId == licenseNpcId then
                return npcId
            end
		end
	end

	return 0
end

AddRemoteEvent("OpenLicenses", function(licenses)
	local licenseItems = {}
	for k, v in pairs(licenses) do
		licenseItems[k] = _(k).." ["..v.._("currency").."]"
	end
    
	Dialog.setSelectLabeledOptions(licenseNpcMenu, 1, 1, licenseItems)
	Dialog.show(licenseNpcMenu)
end)

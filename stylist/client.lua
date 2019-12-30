local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local stylistNPC
local stylistNPCIds = { }

local playerHairs = ""
local playerHairsColor = ""
local playerShirt = ""
local playerPants = ""
local playerShoes = ""

AddEvent("OnTranslationReady", function()
	stylistNPC = Dialog.create(_("stylist"), nil, _("yes"), _("cancel"))
	hairsMenu = Dialog.create(_("hairs"), nil, _("choose"), _("cancel"))
	Dialog.addSelect(hairsMenu, 1, _("hairs"), 5)
    Dialog.addSelect(hairsMenu, 2, _("color"), 5)
	shirtMenu = Dialog.create(_("shirts"), nil, _("choose"), _("cancel"))
	Dialog.addSelect(shirtMenu, 1, _("shirts"), 5)
	pantsMenu = Dialog.create(_("pants"), nil, _("choose"), _("cancel"))
	Dialog.addSelect(pantsMenu, 1, _("pants"), 5)
	shoesMenu = Dialog.create(_("shoes"), nil, _("choose"), _("cancel"))
	Dialog.addSelect(shoesMenu, 1, _("shoes"), 5)
end)

AddEvent("OnKeyPress", function(key)
    if key == "E" and not onSpawn and not onCharacterCreation then
        local NeareststylistNPC = GetNeareststylistNPC()
		if NeareststylistNPC ~= 0 then
			CallRemoteEvent("stylistInteract", NeareststylistNPC)
		end
	end
end)

AddRemoteEvent("stylistSetup", function(stylistObjects)
	stylistNPCIds = stylistObjects
end)

AddRemoteEvent("openStylist", function()
	Dialog.show(stylistNPC)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }

	if dialog == stylistNPC then
		if button == 1 then
			CallRemoteEvent("startModify")
        end
    end
	if dialog == hairsMenu then
		if button == 1 then
			if args[1] == "" or args[2] == "" then
				MakeNotification(_("please_choose_hairs"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				Dialog.show(hairsMenu)
			else
				playerHairs = args[1]
				playerHairsColor = args[2]
                Dialog.show(shirtMenu)
			end
        end
    end
	if dialog == shirtMenu then
		if button == 1 then
			if args[1] == "" then
				MakeNotification(_("please_choose_shirt"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				Dialog.show(shirtMenu)
			else
				playerShirt = args[1]
                Dialog.show(pantsMenu)
			end
        end
    end
	if dialog == pantsMenu then
		if button == 1 then
			if args[1] == "" then
				MakeNotification(_("please_choose_pants"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				Dialog.show(pantsMenu)
			else
				playerPants = args[1]
                Dialog.show(shoesMenu)
			end
        end
    end	
	if dialog == shoesMenu then
		if button == 1 then
			if args[1] == "" then
				MakeNotification(_("please_choose_shoes"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				Dialog.show(shoesMenu)
			else
				playerShoes = args[1]
                CallRemoteEvent("ModifyEvent", playerHairs, playerShirt, playerPants, playerShoes, playerHairsColor)
			end
        end
    end
end)

AddRemoteEvent("openModify", function(lhairs, lshirts, lpants, lshoes,lhairscolor)
    hairs = {}
    for k,v in pairs(lhairs) do
        hairs[k] = _("clothes_"..k)
    end
    hairsColor = {}
    for k,v in pairs(lhairscolor) do
        hairsColor[k] = _(k)
    end
    shirts = {}
    for k,v in pairs(lshirts) do
        shirts[k] = _("clothes_"..k)
    end
    pants = {}
    for k,v in pairs(lpants) do
        pants[k] = _("clothes_"..k)
    end
    shoes = {}
    for k,v in pairs(lshoes) do
        shoes[k] = _("clothes_"..k)
	end

    Dialog.setSelectLabeledOptions(hairsMenu, 1, 1, hairs)
    Dialog.setSelectLabeledOptions(hairsMenu, 2, 1, hairsColor)
    Dialog.setSelectLabeledOptions(shirtMenu, 1, 1, shirts)
    Dialog.setSelectLabeledOptions(pantsMenu, 1, 1, pants)
    Dialog.setSelectLabeledOptions(shoesMenu, 1, 1, shoes)
	Dialog.show(hairsMenu)
end)

AddRemoteEvent("modifyIG", function(player, part, piece, r, g, b, a)
    local SkeletalMeshComponent
    local pieceName
    if part == 0 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing0")
        pieceName = piece
    end
    if part == 1 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
        pieceName = piece
    end
    if part == 4 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
        pieceName = piece
    end
    if part == 5 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
        pieceName = piece
    end
    SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
    local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
    if part == 0 then
        DynamicMaterialInstance:SetColorParameter("Hair Color", FLinearColor(r, g, b, a))
    end
end)

function GetNeareststylistNPC()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			for k,i in pairs(stylistNPCIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local stylistNPC
local stylistNPCIds = { }

local playerHairs = ""
local playerHairsColor = ""
local playerShirt = ""
local playerPants = ""
local playerShoes = ""
local heading = 180
local rotatingInterval
local isEditingClothes = false
local currentHair
local currentHairColor

shirtsModel = {
    formal_shirt_1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
    formal_shirt_2 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
    simple_shirt = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
    knitted_shirt_2 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
    knitted_shirt_1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
    tshirt = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR",
}

pantsModel = {
    cargo_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR",
    denim_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
    formal_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
}

shoesModel = {
    normal_shoes = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR",
    business_shoes = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
}

hairsModel = {
    hairs_business = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
    hairs_scientist = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
    hairs_1 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
    hairs_3 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
    hairs_2 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
}

hairsColor = {
    blond = { 250, 240, 190, 1 },
    light_blond = { 222, 190, 153, 1 },
    dark = { 36, 28, 17, 1 },
    brown = { 139, 69, 19, 1 },
    redhead = { 154, 51, 0, 1 },
    grey = { 169, 169, 169, 1 },
    light_grey = { 211, 211, 211, 1},
    black = { 9, 8, 6, 1 }
}

skinColor = {
    skin_1 = { 0.9, 0.9, 0.9, 0 },
    skin_2 = { 0.7, 0.7, 0.7, 0 },
    skin_3 = { 0.5, 0.5, 0.5, 0 },
    skin_4 = { 0.3, 0.3, 0.3, 0 },
    skin_5 = { 0.1, 0.1, 0.1, 0 },
    skin_6 = { 0.05, 0.05, 0.05, 0 }
}

local stylistUI = CreateWebUI(0, 0, 0, 0, 2, 16)
SetWebVisibility(stylistUI, WEB_HIDDEN)
SetWebAlignment(stylistUI, 0, 0)
SetWebAnchors(stylistUI, 0, 0, 1, 1)
SetWebURL(stylistUI, "http://asset/onsetrp/stylist/ui/index.html")

AddEvent("OnTranslationReady", function()
	-- stylistNPC = Dialog.create(_("stylist"), nil, _("yes"), _("cancel"))
	-- hairsMenu = Dialog.create(_("hairs"), nil, _("choose"), _("cancel"))
	-- Dialog.addSelect(hairsMenu, 1, _("hairs"), 5)
    -- Dialog.addSelect(hairsMenu, 2, _("color"), 5)
	-- shirtMenu = Dialog.create(_("shirts"), nil, _("choose"), _("cancel"))
	-- Dialog.addSelect(shirtMenu, 1, _("shirts"), 5)
	-- pantsMenu = Dialog.create(_("pants"), nil, _("choose"), _("cancel"))
	-- Dialog.addSelect(pantsMenu, 1, _("pants"), 5)
	-- shoesMenu = Dialog.create(_("shoes"), nil, _("choose"), _("cancel"))
	-- Dialog.addSelect(shoesMenu, 1, _("shoes"), 5)
end)

AddEvent("OnKeyRelease", function(key)
	if isEditingClothes and (key == "A" or key == "D") then
		if rotatingInterval then
			DestroyTimer(rotatingInterval)
		end
	end
end)

AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local NeareststylistNPC = GetNeareststylistNPC()
		if NeareststylistNPC ~= 0 then
			StartStylist(isCreation, true)
		end
	end

	if key == "A" and isEditingClothes then
		rotatingInterval = CreateTimer(function()
			heading = heading + 1

			if heading >= 360 then
				heading = 0
			end

			CallRemoteEvent("RotatePlayer", heading)
		end, 10)
	end

	if key == "D" and isEditingClothes then
		rotatingInterval = CreateTimer(function()
			heading = heading - 1

			if heading < 0 then
				heading = 359
			end

			CallRemoteEvent("RotatePlayer", heading)
		end, 10)
	end
end)

function StartStylist(isCreation)
	CallRemoteEvent("startModify", isCreation)
end

AddRemoteEvent("stylistSetup", function(stylistObjects)
	-- stylistNPCIds = stylistObjects
end)

AddRemoteEvent("openStylist", function()
	-- Dialog.show(stylistNPC)
end)

AddEvent("SaveCharacterStyle", function(hair, haircolors, tops, trousers, shoes, skins)
	SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
	SetWebVisibility(stylistUI, WEB_HIDDEN)

	isEditingClothes = false
	
	CallRemoteEvent("ModifyEvent", hair, tops, trousers, shoes, haircolors, skins)
end)

AddEvent("MechPreview", function(part, piece)
	local SkeletalMeshComponent

    if part == "hair" then
		currentHair = piece
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing0")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(piece))
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(hairsColor[currentHairColor][1], hairsColor[currentHairColor][2], hairsColor[currentHairColor][3], hairsColor[currentHairColor][4]))
	elseif part == "haircolors" then
        currentHairColor = piece
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing0")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(currentHair))
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(hairsColor[piece][1], hairsColor[piece][2], hairsColor[piece][3], hairsColor[piece][4]))
    elseif part == "tops" then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing1")
    elseif part == "trousers" then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing4")
    elseif part == "shoes" then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing5")
	elseif part == "skins" then
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body")
		SkeletalMeshComponent:SetMaterial(3, UMaterialInterface.LoadFromAsset("/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso"))
		SkeletalMeshComponent:SetColorParameterOnMaterials("Skin Color", FLinearColor(skinColor[piece][1], skinColor[piece][2], skinColor[piece][3], skinColor[piece][4]))
	end

    if part ~= "haircolors" and part ~= "skins" then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(piece))
    end
end)

AddRemoteEvent("openModify", function(currentClothes, isCreation)
	isEditingClothes = true

	currentHair = currentClothes.hair
	currentHairColor = currentClothes.haircolors

	local labels = { skins = {}, trousers = { }, hair = { }, haircolors = { }, tops = { }, shoes = { } }

	local isCreation = isCreation or false
	
	for k,v in pairs(hairsModel) do
		table.insert(labels.hair, { label = _("clothes_"..k), name = v, part = k })
	end
	
    for k,v in pairs(hairsColor) do
		table.insert(labels.haircolors, { label = _(k), name = k, part = k })
	end
	
	for k,v in pairs(shirtsModel) do
		table.insert(labels.tops, { label = _("clothes_"..k), name = v, part = k })
	end
	
    for k,v in pairs(pantsModel) do
		table.insert(labels.trousers, { label = _("clothes_"..k), name = v, part = k })
	end
	
    for k,v in pairs(shoesModel) do
		table.insert(labels.shoes, { label = _("clothes_"..k), name = v, part = k })
	end
	
    for k,v in pairs(skinColor) do
		table.insert(labels.skins, { label = _(k), name = k, part = k })
	end

	SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_UI)
	SetWebVisibility(stylistUI, WEB_VISIBLE)

	ExecuteWebJS(stylistUI, 'startStylist('..json_encode(labels)..', '..json_encode(currentClothes)..', '..tostring(isCreation)..');')
	
	CallRemoteEvent("RotatePlayer", heading)
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

AddEvent("OnHideMainMenu", function()
	if isEditingClothes then
		Delay(1, function()
			SetIgnoreLookInput(true)
			SetIgnoreMoveInput(true)
			ShowMouseCursor(true)
			SetInputMode(INPUT_UI)
		end)
	end
end)


local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local isCreated = true

local playerName = ""
local playerHairs = ""
local playerHairsColor = ""
local playerShirt = ""
local playerPants = ""
local playerShoes = ""

onCharacterCreation = false

AddEvent("OnTranslationReady", function()
    -- characterCreation = Dialog.create(_("character_creation"), _("create_character_name"), _("next_step"))
    -- Dialog.addTextInput(characterCreation, 1, _("first_name"))
    -- Dialog.addTextInput(characterCreation, 1, _("last_name"))
    -- hairsCreation = Dialog.create(_("hairs_creation"), _("choose_hairs_color"), _("next_step"))
    -- Dialog.addSelect(hairsCreation, 1, _("hairs"), 5)
    -- Dialog.addSelect(hairsCreation, 2, _("color"), 5)
    -- shirtsCreation = Dialog.create(_("shirts_creation"), _("choose_shirt"), _("next_step"))
    -- Dialog.addSelect(shirtsCreation, 1, _("shirts"), 5)
    -- pantsCreation = Dialog.create(_("pants_creation"), _("choose_pants"), _("next_step"))
    -- Dialog.addSelect(pantsCreation, 1, _("pants"), 5)
    -- shoesCreation = Dialog.create(_("shoes_creation"), _("choose_shoes"), _("create"))
    -- Dialog.addSelect(shoesCreation, 1, _("shoes"), 5)
end)

AddEvent("OnKeyPress", function(key)
    if onCharacterCreation then
        -- 
    end
end)


AddEvent("OnDialogUIReady", function()
    if not isCreated then
        CallRemoteEvent("ServerCharacterCreation")
    end
end)

AddRemoteEvent("askClientCreation", function() 
    isCreated = false
end)

AddEvent("OnPlayerStreamIn", function( player, otherplayer )
    CallRemoteEvent("ServerChangeOtherPlayerClothes", player, otherplayer)
end)

AddRemoteEvent("openCharacterCreation", function(lhairs, lshirts, lpants, lshoes,lhairscolor)
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
    
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(webIdCard, WEB_VISIBLE)

    -- Dialog.setSelectLabeledOptions(hairsCreation, 1, 1, hairs)
    -- Dialog.setSelectLabeledOptions(hairsCreation, 2, 1, hairsColor)
    -- Dialog.setSelectLabeledOptions(shirtsCreation, 1, 1, shirts)
    -- Dialog.setSelectLabeledOptions(pantsCreation, 1, 1, pants)
    -- Dialog.setSelectLabeledOptions(shoesCreation, 1, 1, shoes)
    
    -- onCharacterCreation = true
    -- CallRemoteEvent("account:setplayerbusy", GetPlayerId())

    -- Dialog.show(characterCreation)
end)



AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
	if dialog == characterCreation then
        if button == 1 then
            if args[1] == "" or args[2] == "" then
                MakeNotification(_("enter_valid_name"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(characterCreation)
            else
                playerName = args[1].." "..args[2]
                Dialog.show(hairsCreation)
            end
        end
    end
    if dialog == hairsCreation then
        if button == 1 then
            if args[1] == "" or args[2] == "" then
                MakeNotification(_("please_choose_hairs"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(hairsCreation)
            else
                playerHairs = args[1]
                playerHairsColor = args[2]
                Dialog.show(shirtsCreation)
            end
        end
    end
    if dialog == shirtsCreation then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("please_choose_shirt"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(shirtsCreation)
            else
                playerShirt = args[1]
                Dialog.show(pantsCreation)
            end
        end
    end
    if dialog == pantsCreation then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("please_choose_pants"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(pantsCreation)
            else
                playerPants = args[1]
                Dialog.show(shoesCreation)
            end
        end
    end
    if dialog == shoesCreation then
        if button == 1 then
            if args[1] == "" then
                MakeNotification(_("please_choose_shoes"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(shoesCreation)
            else
                playerShoes = args[1]

                CallRemoteEvent("ServerChangeClothes", playerName, playerHairs, playerHairsColor, playerShirt, playerPants, playerShoes)
                isCreated = true
                onCharacterCreation = false
                CallRemoteEvent("account:setplayernotbusy", GetPlayerId())
                CallRemoteEvent("character:playerrdytospawn", GetPlayerId())
            end
        end
    end
end)

AddEvent("OnKeyPress", function(k)
	if k == "1" then
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal03_LPR"))
		SkeletalMeshComponent:SetMaterial(3, UMaterialInterface.LoadFromAsset("/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso"))
		SkeletalMeshComponent:SetFloatParameterOnMaterials("PupilScale", 1.3)
		SkeletalMeshComponent:SetColorParameterOnMaterials("Skin Color", FLinearColor(0.239583, 0.239583, 0.239583, 0.0))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing0")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR"))
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(2.0, 0.0, 0.0, 0.0))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing1")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_CH3D_Prisoner_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing4")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR"))
		local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
		DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(0.786458, 0.103145, 0.0, 1.0))
		SkeletalMeshComponent:SetRelativeScale3D(FVector(1.0, 1.01, 1.0))
		SkeletalMeshComponent:SetRelativeRotation(FRotator(0.0, 0.0, 0.0))
		SkeletalMeshComponent:SetRelativeLocation(FVector(0.0, 0.0, 0.0))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing5")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing3")
		SkeletalMeshComponent:SetSkeletalMesh(nil)

		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing2")
		SkeletalMeshComponent:SetSkeletalMesh(nil)
	end
	
	if k == "2" then
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal04_LPR"))
		SkeletalMeshComponent:SetMaterial(0, UMaterialInterface.LoadFromAsset("/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing0")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Hat_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing1")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Long_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing4")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing5")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing3")
		SkeletalMeshComponent:SetSkeletalMesh(nil)

		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing2")
		SkeletalMeshComponent:SetSkeletalMesh(nil)
	end
	
	if k == "3" then
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Business_LPR"))
		SkeletalMeshComponent:SetMaterial(3, UMaterialInterface.LoadFromAsset("/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing0")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing4")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing5")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"))
		local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
		DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(0.0, 0.0, 0.0, 1.0))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing1")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing2")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalJacket_LPR"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing3")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TacticalGlasses_LPR"))
		SkeletalMeshComponent:SetRelativeLocation(FVector(0.0, 0.0, 3.5))
	end
	
	if k == "4" then
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_SpecialAgent_LPR"))
		SkeletalMeshComponent:SetMaterial(0, UMaterialInterface.LoadFromAsset("/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso"))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing1")
		SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_SpecialAgent_LPR"))
		local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(2)
		DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(0.0, 1.0, 0.0, 1.0))
		DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(3)
		DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(0.0, 0.0, 1.0, 1.0))
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing3")
		SkeletalMeshComponent:SetSkeletalMesh(nil)

		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing2")
		SkeletalMeshComponent:SetSkeletalMesh(nil)
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing4")
		SkeletalMeshComponent:SetSkeletalMesh(nil)
		
		SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing5")
		SkeletalMeshComponent:SetSkeletalMesh(nil)
	end

    if k == "5" then
        local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body")
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/Alien/Meshes/SK_Alien01"))
        
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing1")
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_SpecialAgent_LPR"))
        local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(2)
        DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(0.0, 1.0, 0.0, 1.0))

        DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(3)
        DynamicMaterialInstance:SetColorParameter("Clothing Color", FLinearColor(1.0, 0.0, 0.0, 1.0))
        
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing3")
        SkeletalMeshComponent:SetSkeletalMesh(nil)

        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing2")
        SkeletalMeshComponent:SetSkeletalMesh(nil)
        
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing4")
        SkeletalMeshComponent:SetSkeletalMesh(nil)
        
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing5")
        SkeletalMeshComponent:SetSkeletalMesh(nil)
     end
end)

AddRemoteEvent("ClientChangeClothing", function(player, part, piece, r, g, b, a)
    local SkeletalMeshComponent
    local pieceName
    if part == 0 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing0")
        pieceName = piece
    elseif part == 1 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
        pieceName = piece
    elseif part == 4 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
        pieceName = piece
    elseif part == 5 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
        pieceName = piece
    elseif part == 6 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
        SkeletalMeshComponent:SetMaterial(3, UMaterialInterface.LoadFromAsset(BodyMaterial[piece]))
    end
    if pieceName ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
    end
    if part == 0 then
        local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
        DynamicMaterialInstance:SetColorParameter("Hair Color", FLinearColor(r or 0, g or 0, b or 0, a or 0))
    end
end)

BodyMaterial = {
    noClothes = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoClothes",
    noLegs = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoLegs",
    noShoes = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoes",
    noShoesLegs = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegs",
    noShoesLegsTorso = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso",
    noTorso = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoTorso"
}

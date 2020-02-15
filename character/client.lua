local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local characterCreation
local isCreated = true

local playerName = ""
local playerHairs = ""
local playerHairsColor = ""
local playerShirt = ""
local playerPants = ""
local playerShoes = ""

onCharacterCreation = false

AddEvent("OnTranslationReady", function()
    characterCreation = Dialog.create(_("character_creation"), _("create_character_name"), _("next_step"))
    Dialog.addTextInput(characterCreation, 1, _("first_name"))
    Dialog.addTextInput(characterCreation, 1, _("last_name"))
    Dialog.addTextInput(characterCreation, 1, _("age"))
end)

AddEvent("OnKeyPress", function(key)
    if onCharacterCreation then
        -- 
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
	if dialog == characterCreation then
        if button == 1 then
            if args[1] == "" or args[2] == "" then
                MakeNotification(_("enter_valid_name"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(characterCreation)
            elseif args[3] == "" then
                MakeNotification(_("enter_valid_age"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                Dialog.show(characterCreation)
            else
                CallRemoteEvent("CharacterCreated", args[1], args[2], args[3])
            end
        end
    end
end)

AddEvent("OnDialogUIReady", function()
    if not isCreated then
        CallRemoteEvent("ServerCharacterCreation")
    end
end)

AddRemoteEvent("askClientCreation", function() 
    isCreated = false
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    Dialog.show(characterCreation)
end)

AddEvent("OnPlayerStreamIn", function( player, otherplayer )
    CallRemoteEvent("ServerChangeOtherPlayerClothes", player, otherplayer)
end)

AddRemoteEvent("openCharacterCreation", function(lhairs, lshirts, lpants, lshoes, lhairscolor)
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
    SetInputMode(INPUT_UI)
    SetWebVisibility(webIdCard, WEB_VISIBLE)
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
		SkeletalMeshComponent:SetColorParameterOnMaterials("Skin Color", FLinearColor(r or 0, g or 0, b or 0, a or 0))
    end
    if pieceName ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(piece))
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

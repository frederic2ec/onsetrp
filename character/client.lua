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
    hairsCreation = Dialog.create(_("hairs_creation"), _("choose_hairs_color"), _("next_step"))
    Dialog.addSelect(hairsCreation, 1, _("hairs"), 5)
    Dialog.addSelect(hairsCreation, 2, _("color"), 5)
    shirtsCreation = Dialog.create(_("shirts_creation"), _("choose_shirt"), _("next_step"))
    Dialog.addSelect(shirtsCreation, 1, _("shirts"), 5)
    pantsCreation = Dialog.create(_("pants_creation"), _("choose_pants"), _("next_step"))
    Dialog.addSelect(pantsCreation, 1, _("pants"), 5)
    shoesCreation = Dialog.create(_("shoes_creation"), _("choose_shoes"), _("create"))
    Dialog.addSelect(shoesCreation, 1, _("shoes"), 5)
end)

AddEvent("OnKeyPress", function(key)
    if onCharacterCreation then
        if playerName == "" then
            return
        end
        if playerHairs == "" then
            return Dialog.show(hairsCreation)
        end
        if playerHairs == "" or  playerHairsColor == "" then
            return Dialog.show(hairsCreation)
        end
        if playerShirt == "" then
            return Dialog.show(hairsCreation)
        end
        if playerPants == "" then
            return Dialog.show(pantsCreation)
        end
        if playerShoes == "" then
            return Dialog.show(shoesCreation)
        end
    end
end)


AddEvent("OnDialogUIReady", function()
    if not isCreated then
        CallRemoteEvent("ServerCharacterCreation")
    end
end)

AddRemoteEvent( "askClientCreation", function() 
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

    Dialog.setSelectLabeledOptions(hairsCreation, 1, 1, hairs)
    Dialog.setSelectLabeledOptions(hairsCreation, 2, 1, hairsColor)
    Dialog.setSelectLabeledOptions(shirtsCreation, 1, 1, shirts)
    Dialog.setSelectLabeledOptions(pantsCreation, 1, 1, pants)
    Dialog.setSelectLabeledOptions(shoesCreation, 1, 1, shoes)
    
    onCharacterCreation = true
    CallRemoteEvent("account:setplayerbusy", GetPlayerId())

    Dialog.show(characterCreation)
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
            end
        end
    end
end)

AddRemoteEvent("ClientChangeClothing", function(player, part, piece, r, g, b, a)
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



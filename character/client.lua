local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local characterCreation


AddEvent("OnTranslationReady", function()
    characterCreation = Dialog.create("Character Creation", "Create your character", "Create")
    Dialog.addSelect(characterCreation, 1, "Hairs", 5)
    Dialog.addSelect(characterCreation, 2, "Shirts", 5)
    Dialog.addSelect(characterCreation, 3, "Pants", 3)
    Dialog.addSelect(characterCreation, 4, "Shoes", 2)
end)

function OnKeyPress(key)
    if key == "Y" then
        CallRemoteEvent("ServerCharacterCreation")
	end
end
AddEvent("OnKeyPress", OnKeyPress)


AddRemoteEvent("openCharacterCreation", function(lhairs, lshirts, lpants, lshoes)
    AddPlayerChat("called")
    hairs = {}
    for k,v in pairs(lhairs) do
        hairs[k] = v
    end
    shirts = {}
    for k,v in pairs(lshirts) do
        shirts[k] = v
    end
    pants = {}
    for k,v in pairs(lpants) do
        pants[k] = v
    end
    shoes = {}
    for k,v in pairs(lshoes) do
        shoes[k] = v
	end

    Dialog.setSelectLabeledOptions(characterCreation, 1, 1, hairs)
    Dialog.setSelectLabeledOptions(characterCreation, 2, 1, shirts)
    Dialog.setSelectLabeledOptions(characterCreation, 3, 1, pants)
    Dialog.setSelectLabeledOptions(characterCreation, 4, 1, shoes)
    Dialog.show(characterCreation)
end)



AddEvent("OnDialogSubmit", function(dialog, button, ...)
	if dialog == characterCreation then
        local args = { ... }
        AddPlayerChat(args[1])
        if button == 1 then
			ChangeClothing(0, args[1])
            ChangeClothing(1, args[2])
            ChangeClothing(4, args[3])
            ChangeClothing(5, args[4])
        end
    end
end)

function ChangeClothing(part, piece)
    local player = GetPlayerId()
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
end



local PLAYER_SPAWN_POINT = {x = 204094, y = 180846, z = 1500}

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
    blond = {250, 240, 190, 1},
    black = {0, 0, 0, 1},
    red = {255, 0, 0, 1},
    green = {0, 255, 0, 1},
    blue = {0, 0, 255, 1},
    brown = {139, 69, 19, 1}
}

AddRemoteEvent("ServerCharacterCreation", function(player)
    CallRemoteEvent(player, "openCharacterCreation", hairsModel, shirtsModel, pantsModel, shoesModel, hairsColor)
end)


AddRemoteEvent("ServerChangeClothes", function(player, playername, playerhairs, playerhairscolor, playershirt, playerpants, playershoes)
    PlayerData[player].name = playername
    table.insert(PlayerData[player].clothing, getHairsModel(playerhairs))
    table.insert(PlayerData[player].clothing, playerhairscolor)
    table.insert(PlayerData[player].clothing, getShirtsModel(playershirt))
    table.insert(PlayerData[player].clothing, getPantsModel(playerpants))
    table.insert(PlayerData[player].clothing, getShoesModel(playershoes))
    
    playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
    
    CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
    SetPlayerName(player, playername)
    CallRemoteEvent(player, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
    
    CallRemoteEvent(player, "AskSpawnMenu")
    CallRemoteEvent(player, "OpenSpawnMenu", spawnLocation)
    
    PlayerData[player].created = 1
    
    for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
        ChangeOtherPlayerClothes(k, player)
    end
end)

AddEvent("OnPlayerSpawn", function(player)
    if PlayerData[player] == nil then
        return
    end
    if PlayerData[player].clothing == nil then
        return
    end
    if PlayerData[player].clothing[1] == nil then
        return
    end
    UpdateClothes(player)
end)

function ChangeOtherPlayerClothes(player, otherplayer)
    if PlayerData[otherplayer] == nil then
        return
    end
    if PlayerData[otherplayer].clothing == nil then
        return
    end
    if PlayerData[otherplayer].clothing[1] == nil then
        return
    end
    
    CallRemoteEvent(otherplayer, "ClientChangeClothing", player, 6, "noShoesLegsTorso")
    
    if PlayerData[otherplayer].job == "medic" then
        playerhairscolor = getHairsColor(PlayerData[otherplayer].clothing[2])
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 1, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Scientist_LPR", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 4, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 5, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", 0, 0, 0, 0)
    elseif PlayerData[otherplayer].job == "police" then
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 0, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Hat_LPR", 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 1, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Short_LPR", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 4, "/Game/CharacterModels/Clothing/Meshes/SK_Jeans01", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 5, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", 0, 0, 0, 0)
    else
        playerhairscolor = getHairsColor(PlayerData[otherplayer].clothing[2])
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 0, PlayerData[otherplayer].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 1, PlayerData[otherplayer].clothing[3], 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 4, PlayerData[otherplayer].clothing[4], 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 5, PlayerData[otherplayer].clothing[5], 0, 0, 0, 0)
    end
end
AddRemoteEvent("ServerChangeOtherPlayerClothes", ChangeOtherPlayerClothes)

function UpdateClothes(player)
    CallRemoteEvent(player, "ClientChangeClothing", player, 6, "noShoesLegsTorso")
    
    if PlayerData[player].job == "medic" then
        playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
        CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", player, 1, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Scientist_LPR", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 4, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 5, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", 0, 0, 0, 0)
        
        for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
            playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
            CallRemoteEvent(v, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
            CallRemoteEvent(v, "ClientChangeClothing", player, 1, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Scientist_LPR", 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 4, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR", 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 5, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", 0, 0, 0, 0)
        end
    elseif PlayerData[player].job == "police" then
        CallRemoteEvent(player, "ClientChangeClothing", player, 0, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Hat_LPR", 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 1, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Short_LPR", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 4, "/Game/CharacterModels/Clothing/Meshes/SK_Jeans01", 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 5, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", 0, 0, 0, 0)
        
        for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
            playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
            CallRemoteEvent(v, "ClientChangeClothing", player, 0, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Hat_LPR", 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 1, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Short_LPR", 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 4, "/Game/CharacterModels/Clothing/Meshes/SK_Jeans01", 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 5, "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", 0, 0, 0, 0)
        end
    else
        playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
        CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
        
        for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
            playerhairscolor = getHairsColor(PlayerData[player].clothing[2])
            CallRemoteEvent(v, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
            CallRemoteEvent(v, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
        end
    end
end

function getHairsColor(color)
    for k, v in pairs(hairsColor) do
        if k == color then
            return v
        end
    end
end

function getShoesModel(shoes)
    for k, v in pairs(shoesModel) do
        if k == shoes then
            return v
        end
    end
end

function getPantsModel(pants)
    for k, v in pairs(pantsModel) do
        if k == pants then
            return v
        end
    end
end

function getHairsModel(hairs)
    for k, v in pairs(hairsModel) do
        if k == hairs then
            return v
        end
    end
end

function getShirtsModel(shirts)
    for k, v in pairs(shirtsModel) do
        if k == shirts then
            return v
        end
    end
end

function GetClosePlayers(player, distance, blacklistedJob)
    local playerIds = {}
    local x, y, z = GetPlayerLocation(player)
    
    for playerId, v in pairs(GetStreamedPlayersForPlayer(player)) do
        local _x, _y, _z = GetPlayerLocation(playerId)
        
        if PlayerHaveName(playerId) and playerId ~= player and GetDistance3D(x, y, z, _x, _y, _z) < distance then
            if blacklistedJob == nil or PlayerData[playerId].job ~= blacklistedJob then
                playerIds[playerId] = PlayerData[playerId].name
            end
        end
    end
    
    return playerIds
end

function PlayerHaveName(player)
    return PlayerData[player] ~= nil and PlayerData[player].name ~= nil and PlayerData[player].steamname ~= nil
end

AddRemoteEvent("character:playerrdytospawn", function(player)
    SetPlayerLocation(player, PLAYER_SPAWN_POINT.x, PLAYER_SPAWN_POINT.y, PLAYER_SPAWN_POINT.z) -- MOTEL
end)

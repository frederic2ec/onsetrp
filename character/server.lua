local shirts = {
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Knitted_Shirt_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR",
}

local pants = {
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
}

local shoes = {
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR"
}

local hairs = {
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
}

AddRemoteEvent("ServerCharacterCreation", function(player)
    CallRemoteEvent( player, "openCharacterCreation", hairs, shirts, pants, shoes)
end)

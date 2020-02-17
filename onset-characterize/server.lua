  
local bodyOptions = {
    [1] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Business_LPR",
    [2] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal01_LPR",
    [3] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal02_LPR",
    [4] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal03_LPR",
    [5] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal04_LPR",
    [6] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Pimp_LPR",
    [7] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Police_LPR",
    [8] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Scientist_LPR",
    [9] = "/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_SpecialAgent_LPR"
}
local shirtOptions = {
    [1] = "",
    [2] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
    [3] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
    [4] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
    [5] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
    [6] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
    [7] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR"
}
local pantOptions = {
    [1] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR",
    [2] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
    [3] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
}
local shoeOptions = {
    [1] = "",
    [2] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR",
    [3] = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
}
local hairOptions = {
    [1] = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
    [2] = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
    [3] = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Police_Hair_LPR",
    [3] = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
    [4] = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
    [5] = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
}

AddRemoteEvent("characterize:GetOptions", function(player)
    CallRemoteEvent(player, "characterize:SetOptions", 
        json_encode(bodyOptions),
        json_encode(shirtOptions), 
        json_encode(pantOptions), 
        json_encode(shoeOptions), 
        json_encode(hairOptions))
end)

AddRemoteEvent("characterize:Submit", function(player, params)
    print('submitted: '..params)
    AddPlayerChat(player, 'Submitted: '..params)
end)

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

PlayerData = {}

local shirtsModel = {
    formal_shirt_1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
    formal_shirt_2 ="/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
    simple_shirt = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
    knitted_shirt_2 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
    knitted_shirt_1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
    tshirt = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR",
}

local pantsModel = {
    cargo_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR",
    denim_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
    formal_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
}

local shoesModel = {
    normal_shoes = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR",
    business_shoes = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
}

local hairsModel = {
    hairs_business = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
    hairs_scientist ="/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
    hairs_1 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
    hairs_3 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
    hairs_2 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
}

local hairsColor = {
    blond = { 250, 240, 190, 1 },
    black = { 0, 0, 0, 1 },
    red = { 255, 0, 0, 1 },
	green = { 0, 255, 0, 1 },
	blue = { 0, 0, 255, 1 },
    brown = { 139, 69, 19, 1 }
}

StylistNPCObjectsCached = { }
StylistNPCTable = {
	{
		location = { 207787, 180531, 1312, 90}
		
	}
}

-- Event ----------------------------------------------------

AddEvent("OnPackageStart", function()
	for k,v in pairs(StylistNPCTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D(_("stylist").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)

		table.insert(StylistNPCObjectsCached, v.npc)
	end
end)


AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "stylistSetup", StylistNPCObjectsCached)
end)

AddRemoteEvent("stylistInteract", function(player, stylistobject)
    local stylist = GetStylistByObject(stylistobject)
	if stylist then
		local x, y, z = GetNPCLocation(stylist.npc)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150 then
			for k,v in pairs(StylistNPCTable) do
				if stylistobject == v.npc then
					CallRemoteEvent(player, "openStylist")
				end
			end  
			
		end
	end
end)

AddRemoteEvent("startModify", function(player)
	CallRemoteEvent(player, "openModify", hairsModel, shirtsModel, pantsModel, shoesModel, hairsColor)
end)

AddRemoteEvent("ModifyEvent", function(player, hairsChoice, shirtsChoice, pantsChoice, shoesChoice, colorChoice)
local clothesRequest = "[\""..hairsModel[hairsChoice].."\",\""..colorChoice.."\",\""..shirtsModel[shirtsChoice].."\",\""..pantsModel[pantsChoice].."\",\""..shoesModel[shoesChoice].."\"]"
	
	local query = mariadb_prepare(sql, "UPDATE accounts SET clothing = '?' WHERE id = ? LIMIT 1;",
	clothesRequest,
	player
	)
        
	mariadb_query(sql, query)
	
	PlayerData[player].clothing = {}
	table.insert(PlayerData[player].clothing, hairsModel[hairsChoice])
    table.insert(PlayerData[player].clothing, colorChoice)
    table.insert(PlayerData[player].clothing, shirtsModel[shirtsChoice])
    table.insert(PlayerData[player].clothing, pantsModel[pantsChoice])
    table.insert(PlayerData[player].clothing, shoesModel[shoesChoice])
	
	playerhairscolor = hairsColor[colorChoice]
	
	CallRemoteEvent(player, "modifyIG", player, 0, hairsModel[hairsChoice], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
    CallRemoteEvent(player, "modifyIG", player, 1, shirtsModel[shirtsChoice], 0, 0, 0, 0)
    CallRemoteEvent(player, "modifyIG", player, 4, pantsModel[pantsChoice], 0, 0, 0, 0)
    CallRemoteEvent(player, "modifyIG", player, 5, shoesModel[shoesChoice], 0, 0, 0, 0)
	
	SavePlayerAccount(player)
	



end)

-- Function ----------------------------------------------------

function GetStylistByObject(stylistobject)
	for k,v in pairs(StylistNPCTable) do
		if v.npc == stylistobject then
			return v
		end
	end
	return nil
end

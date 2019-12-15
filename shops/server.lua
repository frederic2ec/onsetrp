local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

ShopObjectsCached = { }
ShopTable = { 
	{
		items = { 
            water_bottle = 10,
            apple = 10,
            donut = 10,
            repair_kit = 10,
            health_kit = 10,
            lockpick = 10,
            pickaxe = 10,
            jerican = 10
		},
		location = { 
            { 128748, 77622, 1576, 90 },
            { 42694, 137926, 1581, 90 },
            { -15402, -2773, 2065, 90 },
            { -169093, -39441, 1149, 90 },
            { 171131, 203562, 1413, -180 }
        },
        npc = {},
    },
    {
        items = {
            weapon_2 = 10,
            weapon_3 = 10,
            weapon_4 = 10,
            weapon_5 = 10,
            weapon_6 = 10,
            weapon_7 = 10,
            weapon_8 = 10,
            weapon_9 = 10,
            weapon_10 = 10,
            weapon_11 = 10,
            weapon_12 = 10,
            weapon_13 = 10,
            weapon_14 = 10,
            weapon_15 = 10,
            weapon_16 = 10,
            weapon_17 = 10,
            weapon_18 = 10,
            weapon_19 = 10,
            weapon_20 = 10
        },
        location = {
            { -181943, -40882, 1163, 0 }
        },
        npc = {},
    },
    {
        items = {
            processed_weed = 4000,
            processed_meth = 4000,
            processed_coke = 4000,
            processed_heroin = 4000
        },
        location = {
            { -177344, 3673, 1992, 0 }
        },
        npc = {},
    },
    {
        items = {
            processed_iron = 1000,
        },
        location = {
            { 21799, 137848, 1555, 90 }
        },
        npc = {},
    }
}
AddEvent("OnPackageStart", function()
    for k,v in pairs(ShopTable) do
        for i,j in pairs(v.location) do
            v.npc[i] = CreateNPC(v.location[i][1], v.location[i][2], v.location[i][3], v.location[i][4])
            CreateText3D(_("shop").."\n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 120, 0, 0, 0)
    
            table.insert(ShopObjectsCached, v.npc[i])
        end
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "shopSetup", ShopObjectsCached)
end)

AddRemoteEvent("shopInteract", function(player, shopobject)
    local shop, npcid = GetShopByObject(shopobject)

	if shop then
		local x, y, z = GetNPCLocation(shop.npc[npcid])
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 300 then
			for k,v in pairs(ShopTable) do
				if shopobject == v.npc[npcid] then
					CallRemoteEvent(player, "openShop", PlayerData[player].inventory, v.items, v.npc[npcid])
				end
			end  
			
		end
	end
end)

function GetShopByObject(shopobject)
    for k,v in pairs(ShopTable) do
        for i,j in pairs(v.npc) do
            if j == shopobject then
                return v,i
            end
        end
	end
	return nil
end

function getPrice(shop, item)
    for k,v in pairs(ShopTable) do
        for i,j in pairs(v.npc) do
            if j == shop then
                return v.items[item]
            end
        end
    end
    return 0
end


AddRemoteEvent("ShopBuy", function(player, shopid, item, amount) 
    local price = getPrice(shopid, item) * amount

    if PlayerData[player].cash < price then
        AddPlayerChat(player, _("not_enought_cash") )
    else
        PlayerData[player].cash = PlayerData[player].cash - price
        AddPlayerChat(player, _("shop_success_buy", _(item), price, _("currency")))
        AddInventory(player, item, amount)
    end
end)

AddRemoteEvent("ShopSell", function(player, shopid, item, amount) 
    local price = getPrice(shopid, item) * amount * 0.25

    if price == 0 then
        return
    end

    if tonumber(PlayerData[player].inventory[item]) < tonumber(amount) then
        AddPlayerChat(player, _("not_enough_item"))
    else
        PlayerData[player].cash = PlayerData[player].cash + math.ceil(price)
        AddPlayerChat(player, _("shop_success_sell", _(item), price, _("currency")))
        RemoveInventory(player, item, amount)
    end
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)


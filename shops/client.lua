local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("flat")
 
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local shopUI
local lastShop
local ShopIds = { }
local lastItems = { }
local lastInventoryItems = { }
AddEvent("OnTranslationReady", function()
    shopUI = Dialog.create(_("shop"), nil, _("cancel"))
    Dialog.addSelect(shopUI, 1, _("inventory"), 5)
    Dialog.addTextInput(shopUI, 1, _("quantity"))
    Dialog.setButtons(shopUI, 1, _("sell"))
    Dialog.addSelect(shopUI, 2, _("shop"), 5)
    Dialog.addTextInput(shopUI, 2, _("quantity"))
    Dialog.setButtons(shopUI, 2, _("buy"))
end)
 
AddRemoteEvent("shopSetup", function(ShopObject)
    ShopIds = ShopObject
end)
 
function OnKeyPress(key)
    if key == "E" and not GetPlayerBusy() then
		local NearestShop = GetNearestShop()
		if NearestShop ~= 0 then
			CallRemoteEvent("account:setplayernotbusy", GetPlayerId())
            CallRemoteEvent("shopInteract", NearestShop)
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)
 
AddEvent("OnDialogSubmit", function(dialog, button, ...)
	local args = { ... }
	if dialog == shopUI then
		CallRemoteEvent("account:setplayernotbusy", GetPlayerId())
		if button == 1 then
			if args[1] == "" then
				MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
			else
				if args[2] == "" or math.floor(args[2]) < 1 then
					MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				else
					CallRemoteEvent("ShopSell", lastShop, lastInventoryItems[tonumber(args[1])], math.floor(args[2]))
				end
			end
		end
		if button == 2 then
			if args[3] == "" then
				MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
			else
				if args[4] == ""  or math.floor(args[4]) < 1 then
					MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				else
					CallRemoteEvent("ShopBuy", lastShop, lastItems[tonumber(args[3])], math.floor(args[4]))
				end
			end
		end
    end
end)
 
 
function GetNearestShop()
    local x, y, z = GetPlayerLocation()
 
    for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
 
        if dist < 250.0 then
            for k,i in pairs(ShopIds) do
                if v == i then
                    return v
                end
            end
        end
    end
 
    return 0
end
 
AddRemoteEvent("openShop", function(inventory, items, shopid)
    local inventoryItems = {}  
    local inventoryKey = 0 
    local shopItems = {}
 
    lastInventoryItems = {}
 
    for inventoryItem, inventoryCount in pairs(inventory) do
        -- Check if this NPC can buy this item (NPCs can only buy items they're selling)
        for key, item in pairs(items) do
            if inventoryItem == item.name then
                inventoryKey = inventoryKey + 1
                lastInventoryItems[inventoryKey] = item
                inventoryItems[inventoryKey] = inventoryCount.." x ".._(inventoryItem).." ("..inventoryCount.." x "..(item.weightInText)..")"
            end
        end
    end
 
    for key, item in pairs(items) do
        shopItems[key] = "[".._("price_in_currency", item.price).."]  ".._(item.name).."  ("..item.weightInText..")"
    end
 
    lastItems = items
    lastShop = shopid
 
    Dialog.setSelectLabeledOptions(shopUI, 1, 1, inventoryItems)
    Dialog.setSelectLabeledOptions(shopUI, 2, 1, shopItems)
    Dialog.show(shopUI)
end)

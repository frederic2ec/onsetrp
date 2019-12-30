local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("flat")

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local shop
local lastShop
local ShopIds = { }
local lastItems = { }

AddEvent("OnTranslationReady", function()
    shop = Dialog.create(_("shop"), nil, _("cancel"))
    Dialog.addSelect(shop, 1, _("inventory"), 5)
    Dialog.addTextInput(shop, 1, _("quantity"))
    Dialog.setButtons(shop, 1, _("sell"))
    Dialog.addSelect(shop, 2, _("shop"), 5)
    Dialog.addTextInput(shop, 2, _("quantity"))
    Dialog.setButtons(shop, 2, _("buy"))
end)

AddRemoteEvent("shopSetup", function(ShopObject)
    ShopIds = ShopObject
end)

function OnKeyPress(key)
    if key == "E" and not onSpawn and not onCharacterCreation then
		local NearestShop = GetNearestShop()
        if NearestShop ~= 0 then
            CallRemoteEvent("shopInteract", NearestShop)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
	local args = { ... }
	if dialog == shop then
		if button == 1 then
			if args[1] == "" then
				MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
			else
				if args[2] == "" or math.floor(args[2]) < 1 then
					MakeNotification(_("select_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
				else
					CallRemoteEvent("ShopSell", lastShop, lastItems[tonumber(args[1])], math.floor(args[2]))
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
	local shopItems = {}

	for inventoryItem, inventoryCount in pairs(inventory) do
		-- Check if this NPC can buy this item (NPCs can only buy items they're selling)
		for key, item in pairs(items) do
			if inventoryItem == item.name then
				inventoryItems[key] = inventoryCount.." x ".._(inventoryItem)
			end
		end
	end

	for key, item in pairs(items) do
		shopItems[key] = _(item.name).." (".._("price_in_currency", item.price)..")"
	end

	lastItems = items
	lastShop = shopid

	Dialog.setSelectLabeledOptions(shop, 1, 1, inventoryItems)
	Dialog.setSelectLabeledOptions(shop, 2, 1, shopItems)
	Dialog.show(shop)
end)

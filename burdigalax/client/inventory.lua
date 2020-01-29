local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local inventoryUI

function OnPackageStartInventory()
    local width, height = GetScreenSize()
    inventoryUI = CreateWebUI(0, 0, 0, 0, 10, 60)
    LoadWebFile(inventoryUI, "http://asset/onsetrp/burdigalax/client/gui/inventory.html")
    SetWebAlignment(inventoryUI, 0.0, 0.0)
    SetWebAnchors(inventoryUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(inventoryUI, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStartInventory)

function OnPackageStopInventory()
    DestroyWebUI(inventoryUI)
end
AddEvent("OnPackageStop", OnPackageStopInventory)

-- CLOSE

function CloseUIInventory(context)
    CallRemoteEvent("account:setplayernotbusy", GetPlayerId())
    personalMenuIsOpen = 0
    if context == '"transfer"' then
        ExecuteWebJS(inventoryUI, "ResetSelectedNearbyInventory()")
    else
        ShowMouseCursor(false)
        SetInputMode(INPUT_GAME)
        Delay(100, function()
            SetWebVisibility(inventoryUI, WEB_HIDDEN)
        end)
    end
end
AddEvent("BURDIGALAX_inventory_onClose", CloseUIInventory)

-- INIT

function OpenUIInventory(items, playerInventory, playerName, playerId, playersList, maxSlots, searchedPlayer)
    CallRemoteEvent("account:setplayerbusy", GetPlayerId())
    personalMenuIsOpen = 1
    ExecuteWebJS(inventoryUI, "BURDIGALAX_inventory.setConfig("..json_encode(BuildInventoryJson(items, playerInventory, playerName, playerId, playersList, maxSlots, searchedPlayer))..");")
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(inventoryUI, WEB_VISIBLE)
end

-- UPDATE

AddRemoteEvent("UpdateUIInventory", function(player, item, quantity, equiped)
    local equiped = equiped or false
    ExecuteWebJS(inventoryUI, "BURDIGALAX_inventory.updateItemsInventories("..player..", [{ id: '"..item.."', quantity: "..quantity..", isEquipped: "..tostring(equiped).." }]);")
end)

function onEquipItemInventory(event)
    local data = json_decode(event)
    ExecuteWebJS(inventoryUI, 'setEquipItemInventory('..data.idInventory..','..data.idItem..','..tostring(data.isEquipped)..');')
end
AddEvent('BURDIGALAX_inventory_onEquip', onEquipItemInventory)

-- TRANSFERT

function onTransferItems(event)
    local data = json_decode(event)
    ExecuteWebJS(inventoryUI, "BURDIGALAX_inventory.updateItemsInventories("..data.destinationInventoryId..", [{ id: "..data.idItem..", quantity: "..data.newQuantityDestination.." }]);")
    ExecuteWebJS(inventoryUI, "BURDIGALAX_inventory.updateItemsInventories("..data.originInventoryId..", [{ id: "..data.idItem..", quantity: "..data.newQuantityOrigin.." }]);")
end
AddEvent('BURDIGALAX_inventory_onTransfer', onTransferItems)

function BuildInventoryJson(items, playerInventory, playerName, playerId, playersList, maxSlots, searchedPlayer)
    local json = {
        config = {
            hasEquipableCategory = true,
            wording = {
                emptyInventory = _("empty_inventory"),
                nameAllCategory = _("name_all_category"),
                nameEquipableCategory = _("name_equipable_category"),
                total = _("total"),
                use = _("use"),
                selectItem = _("select_item_inventory"),
                equipped = _("equipped"),
                max = _("max"),
                noneInventory = _("none_inventory"),
                noNearbyInventories = _("no_nearby_inventories")
            }
        },
        mainInventoryId = playerId,
        items = InventoryItems(items),
        effects = InventoryEffects(),
        categories = InventoryCategories(),
        inventories = Inventories(playerId, playerName, playerInventory, maxSlots)
    }

    if playersList[1] ~= nil then
        json.inventories[1].nearbyInventoriesIds = {}
    end

    for k, player in pairs(playersList) do
        local inventory = {
            id = player.id,
            storageSize = maxSlots,
            name = player.name,
            description = player.name,
            selectName = player.name,
            hasReadAccess = false
        }

        if searchedPlayer ~= nil and searchedPlayer.id == player.id then
            inventory.hasReadAccess = true
            inventory.items = InventoryAvailableItems(searchedPlayer.inventory)
            inventory.categoriesIds = {
                'food',
                'object',
                'clothing',
                'tool',
                'weapon'
            }
        end

        table.insert(json.inventories[1].nearbyInventoriesIds, player.id)
        table.insert(json.inventories, inventory)
    end

    if searchedPlayer ~= nil then
        json.inventories[1].selectedNearbyInventoryId = searchedPlayer.id
    end

    return json
end

function Inventories(playerId, playerName, playerInventory, maxSlots)
    return {
        {
            id = playerId,
            storageSize = maxSlots,
            name = _('backpack'),
            description = playerName,
            selectName = playerName,
            categoriesIds = {
                'food',
                'object',
                'clothing',
                'tool',
                'weapon'
            },
            items = InventoryAvailableItems(playerInventory)
        }
    }
end

function InventoryItems(items)
    local availableItems = {}

    for key, item in pairs(items) do
        local itemTable = {
            id = item.name,
            name = item.translated_name,
            categoryId = item.subcategory,
            isEquipable = item.equipable == 1,
            isDeletable = true,
            isUsable = item.usable == 1,
            iconUrl = item_svg(item.name),
            weight = tonumber(string.format("%." .. 3 .. "f", item.weight))
        }

        if item.subcategory == 'weapon' then
           itemTable.iconUrl = item_svg('weapon')
        end

        if item.hunger ~= 0 or item.thirst ~= 0 then
            itemTable['effects'] = {}

            if item.hunger ~= 0 then
                table.insert(itemTable.effects, { id = 'food', value = item.hunger })
            end

            if item.thirst ~= 0 then
                table.insert(itemTable.effects, { id = 'hydration', value = item.thirst })
            end
        end

        table.insert(availableItems, itemTable)
    end

    table.insert(availableItems, { id = 'cash', name = _('currency'), categoryId = 'object', isEquipable = false, isDeletable = false, isUsable = false, weight = 0, iconUrl = item_svg('cash') })

    return availableItems
end

function InventoryAvailableItems(playerInventory)
    local inventoryItems = {}

    for inventoryItem, inventoryCount in pairs(playerInventory) do
        local isEquipped = false

        for slot, v in pairs({ 1, 2, 3 }) do
            local slotWeapon, ammo = GetPlayerWeapon(slot)

            if "weapon_"..slotWeapon == inventoryItem then
                isEquipped = true
            end
        end

        table.insert(inventoryItems, { id = inventoryItem, quantity = inventoryCount, isEquipped = isEquipped })
    end

    return inventoryItems
end

function InventoryCategories()
    return {
        {
            id = 'food',
            name = _('food'),
            iconUrl = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Ctitle%3Eicon-filter-food%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cpath d='M4.347 7.042l-.928.56.708 6.65c.048.605-.248 1.185-.765 1.502-.517.317-1.169.317-1.686 0-.517-.317-.813-.898-.765-1.502l.708-6.65-.928-.56c-.443-.266-.707-.752-.69-1.268l.167-5.333c.01-.248.215-.443.463-.44.247 0 .449.195.458.442l.12 3.478c.003.19.145.349.333.373.101.011.203-.02.28-.087.077-.067.123-.163.127-.265l.12-3.482c0-.253.205-.458.458-.458s.458.205.458.458l.12 3.482c.004.1.048.194.123.26s.173.099.272.092c.189-.024.331-.183.333-.373l.117-3.478c.009-.246.211-.441.457-.442.247 0 .449.195.458.442l.167 5.333c.018.515-.244 1-.685 1.267zm7.32-2.983c0-2.242-1.137-4.058-2.537-4.058s-2.537 1.817-2.537 4.058c0 1.717.667 3.167 1.613 3.758l-.685 6.435c-.048.605.248 1.185.765 1.502.517.317 1.169.317 1.686 0 .517-.317.813-.898.765-1.502l-.685-6.435c.947-.592 1.613-2.042 1.613-3.758z' fill='%23000' fill-rule='nonzero'/%3E%3C/svg%3E"
        },
        {
            id = 'object',
            name = _('object'),
            iconUrl = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='17' height='16' viewBox='0 0 17 16'%3E%3Ctitle%3Eicon-filter-objects%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cpath d='M5.659 3.238h4.851v-1.617h-4.851v1.617zm-2.425 4.851h-3.234v-1.617c0-1.783 1.451-3.234 3.234-3.234h.808v-1.617c0-.892.724-1.617 1.617-1.617h4.851c.892 0 1.617.724 1.617 1.617v1.617h.808c1.783 0 3.234 1.451 3.234 3.234v1.617h-3.234v-1.617h-1.617v1.617h-6.467v-1.617h-1.617v1.617zm9.701 1.617h3.234v4.042c0 .892-.724 1.617-1.617 1.617h-12.935c-.892 0-1.617-.724-1.617-1.617v-4.042h3.234v1.617h1.617v-1.617h6.467v1.617h1.617v-1.617z' fill='%23000' fill-rule='nonzero'/%3E%3C/svg%3E"
        },
        {
            id = 'clothing',
            name = _('clothing'),
            iconUrl = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='16' viewBox='0 0 20 16'%3E%3Ctitle%3Eicon-filter-clothes%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cpath d='M19.084 13.927l-8.47-5.968v-.96c1.722-.444 2.937-2.146 2.596-4.07-.249-1.405-1.368-2.547-2.768-2.821-2.267-.442-4.25 1.282-4.25 3.469 0 .15.012.297.03.442h1.802c-.133-.511-.123-1.081.724-1.822.266-.232.605-.384.958-.39 1.117-.015 2.004 1.011 1.749 2.168-.131.597-.59 1.088-1.17 1.279l-.11.032c-.782.206-1.33.903-1.33 1.711v.962l-8.47 5.968c-.236.166-.376.435-.376.723v.001c0 .723.586 1.309 1.309 1.309h16.841c.723 0 1.31-.586 1.31-1.309v-.001c0-.288-.14-.558-.376-.723m-15.657.264l6.302-4.422 6.302 4.422h-12.605z' fill='%23000' fill-rule='nonzero'/%3E%3C/svg%3E"
        },
        {
            id = 'tool',
            name = _('tool'),
            iconUrl = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 16 16'%3E%3Ctitle%3Eicon-filter-tools%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cpath d='M1.6 3.2l2.8 2.8 1.6-1.6-2.8-2.8.8-.8-3.2-.8-.8.8.8 3.2.8-.8zm13.903 9.905l-3.503-3.505-2.4 2.4 3.503 3.505c.662.662 1.736.662 2.398 0l.002-.002c.662-.662.662-1.736 0-2.398zm-.12-7.069c-.335.546-.801 1.012-1.347 1.347-1.266.778-2.398.722-3.386.366l-2.902 2.902c.356.988.411 2.12-.366 3.386-.336.546-.802 1.011-1.348 1.346-1.266.779-2.398.723-3.386.367l2.15-2.15v-2.4h-2.4l-2.15 2.15c-.356-.987-.411-2.119.367-3.386.335-.546.801-1.012 1.346-1.347 1.266-.778 2.399-.722 3.386-.367l2.902-2.901c-.356-.988-.411-2.12.366-3.386.336-.546.801-1.012 1.347-1.347 1.266-.778 2.399-.722 3.386-.367l-2.15 2.15v2.4h2.4l2.15-2.15c.357.987.412 2.119-.366 3.386z' fill='%23000' fill-rule='nonzero'/%3E%3C/svg%3E"
        },
        {
            id = 'weapon',
            name = _('weapons'),
            iconUrl = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='22' height='16' viewBox='0 0 22 16'%3E%3Ctitle%3Eicon-filter-gun%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cg fill='none'%3E%3Cpath d='M12.757 6.287c-.179.551-.508 1.187-1.105 1.823l-.726-.292c.672-.716.787-1.38.694-1.916l-.106-.007h-1.724c-.925 0-1.676.526-1.678 1.174.004.924.753 1.672 1.678 1.672h1.724c.926 0 1.676-.749 1.678-1.674-.002-.3-.169-.571-.435-.778z'/%3E%3Cpath d='M18.74 5.851h-.064l-.824-1.491c.679-.134 1.556-.476 2.437-1.302l-.31-.768c-1.441 1.353-2.689.588-3.164.192l-.884-1.602h-13.931999999999999l-1.356-.824h-.527v4.438h4.029c1.957 1.732 1.619 2.523 1.619 2.523h.776v.188c0 1.498 1.214 2.711 2.711 2.711h1.362l1.917.05c1.498 0 2.71 1.214 2.71 2.711v1.419c0 1.695 3.185 1.695 3.185 1.695 1.498 0 3.026-.198 3.026-1.695v-5.535c0-1.497-1.214-2.711-2.711-2.711zm-7.183 2.937h-1.825c-.979 0-1.772-.792-1.776-1.769.002-.687.796-1.243 1.776-1.243h1.825l.112.008c.099.567-.023 1.271-.735 2.028l.769.309c.632-.673.981-1.346 1.17-1.929.281.22.458.506.46.824-.003.979-.796 1.772-1.776 1.772z' fill='%23000' fill-rule='nonzero'/%3E%3C/g%3E%3C/svg%3E"
        }
    }
end

function InventoryEffects()
    return {
        hydration = {
            name = _("hydration"),
            unit = "%",
            iconUrl = "data:image/svg+xml,%0A%3Csvg width='28' height='28' viewBox='0 0 28 28' xmlns='http://www.w3.org/2000/svg'%3E%3Ctitle%3Eeffet-hydrat@1x%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cg transform='translate(1 1)' fill='none'%3E%3Cg fill='%236ABEE4' fill-rule='nonzero'%3E%3Cpath d='M12.963 22c-3.828 0-6.943-3.114-6.943-6.943 0-3.579 5.711-10.915 6.363-11.741.14-.177.354-.281.58-.281.226 0 .44.103.58.281.651.825 6.363 8.16 6.363 11.741 0 3.828-3.114 6.943-6.942 6.943zm0-17.013c-1.933 2.564-5.465 7.733-5.465 10.07 0 3.013 2.451 5.464 5.465 5.464 3.013 0 5.465-2.451 5.465-5.464 0-2.337-3.532-7.506-5.465-10.07z'/%3E%3Cpath d='M12.963 19.045c-.389-.026-.691-.349-.691-.739s.302-.713.691-.739c1.385-.001 2.507-1.124 2.509-2.509.026-.389.349-.691.739-.691s.713.302.739.691c-.003 2.201-1.787 3.984-3.987 3.987z'/%3E%3C/g%3E%3Ccircle stroke='%236ABEE4' stroke-width='2' cx='13' cy='13' r='13'/%3E%3C/g%3E%3C/svg%3E"
        },
        petrol = {
            name = _("fuel_inventory"),
            unit = "L",
            iconUrl = "data:image/svg+xml,%0A%3Csvg width='28' height='28' viewBox='0 0 28 28' xmlns='http://www.w3.org/2000/svg'%3E%3Ctitle%3Eeffet-fuel@1x%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cg transform='translate(1 1)' fill='none'%3E%3Cpath d='M13.046 3.356c-.158-.198-.475-.198-.633 0-1.346 1.742-6.373 8.55-6.373 11.756 0 3.681 3.008 6.69 6.69 6.69 3.681 0 6.69-3.008 6.69-6.69 0-3.206-5.027-10.015-6.373-11.756zm1.94 16.11c-.079.04-.158.04-.237.04-.238 0-.475-.158-.554-.356-.119-.317.04-.633.317-.792 2.335-.95 2.138-3.8 2.098-3.84-.04-.317.198-.633.554-.633.317-.04.633.198.633.554.158 1.267-.317 3.998-2.81 5.027z' fill='%23333' fill-rule='nonzero'/%3E%3Ccircle stroke='%23808080' stroke-width='2' cx='13' cy='13' r='13'/%3E%3C/g%3E%3C/svg%3E"
        },
        food = {
            name = _("food"),
            iconUrl = "data:image/svg+xml,%0A%3Csvg width='28' height='28' viewBox='0 0 28 28' xmlns='http://www.w3.org/2000/svg'%3E%3Ctitle%3Eeffet-food@1x%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cg transform='translate(1 1)' fill='none'%3E%3Cg fill='%237F95A5' fill-rule='nonzero'%3E%3Cpath d='M17.351 5.092c-.479 0-.912.193-1.286.574-1.838 1.87-1.786 8.214-1.774 8.931l.009.52h2.523v6.296c0 .292.236.528.528.528.292 0 .528-.237.528-.528v-15.792c0-.292-.236-.528-.528-.528zM12.317 9.929h-.71v-4.87h-.698v4.87h-.71v-4.87h-.698v4.87h-.71v-4.87h-.633v4.864c0 1.119.769 2.057 1.806 2.32l-.508 9.01c0 .38.789.688 1.097.688.309 0 1.097-.308 1.097-.688l-.508-9.01c1.037-.263 1.806-1.2 1.806-2.32v-4.864h-.633v4.87h.001z'/%3E%3C/g%3E%3Ccircle stroke='%237F95A5' stroke-width='2' cx='13' cy='13' r='13'/%3E%3C/g%3E%3C/svg%3E",
            unit = "%"
        },
        health = {
            name = _("health"),
            iconUrl = "data:image/svg+xml,%0A%3Csvg width='28' height='28' viewBox='0 0 28 28' xmlns='http://www.w3.org/2000/svg'%3E%3Ctitle%3Eeffet-sante@1x%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cg transform='translate(1 1)' fill='none'%3E%3Cpath d='M17.176 6.235c2.353 0 4.706 1.647 4.706 4.471 0 .861-.299 1.721-.801 2.588h-1.294l-1.037-1.662c-.098-.154-.29-.243-.471-.213-.18.03-.338.176-.382.353l-.463 1.956-.971-4.537c-.079-.227-.2-.366-.434-.375-.235-.013-.464.178-.493.412l-.647 4.993-.551-2c-.053-.206-.265-.361-.478-.353-.213.008-.404.18-.441.39l-.434 2.184-.331-.654c-.078-.154-.247-.257-.419-.257h-2.015c-.163-.281-.461-.471-.809-.471-.52 0-.941.421-.941.941s.421.941.941.941c.346 0 .645-.193.809-.471h1.728l.809 1.618c.087.174.293.283.485.257.193-.026.359-.184.397-.375l.316-1.581.647 2.324c.059.206.272.354.485.338.214-.015.405-.192.434-.404l.588-4.574.838 3.904c.044.208.244.373.456.375.212.002.416-.161.463-.368l.684-2.904.581.934c.084.134.239.221.397.221h.934c-1.758 2.393-4.85 4.857-7.522 7.529-4-4-8.941-7.529-8.941-11.059 0-2.824 2.118-4.471 4.471-4.471 1.647 0 3.294 1.647 4.471 2.588 1.176-.941 2.588-2.588 4.235-2.588z' fill='%23FF655C' fill-rule='nonzero'/%3E%3Ccircle stroke='%23FF655C' stroke-width='2' cx='13' cy='13' r='13'/%3E%3C/g%3E%3C/svg%3E",
            unit = "%"
        },
        bleeding = {
            name = _("bleeding"),
            iconUrl = "data:image/svg+xml,%0A%3Csvg width='28' height='28' viewBox='0 0 28 28' xmlns='http://www.w3.org/2000/svg'%3E%3Ctitle%3Eeffet-bleed@1x%3C/title%3E%3Cdesc%3ECreated with Sketch.%3C/desc%3E%3Cg transform='translate(1 1)' fill='none'%3E%3Ccircle stroke='%23FF655C' stroke-width='2' cx='13' cy='13' r='13' fill='none'/%3E%3Cg fill='%23FF655C' fill-rule='nonzero'%3E%3Cpath d='M14.113 22.596c.42-.42.524-1.062.259-1.593l-1.235-2.469-1.235 2.469c-.266.531-.162 1.173.259 1.593.539.539 1.413.539 1.952 0zM16.941 15.963c-.266.531-.162 1.173.259 1.593.539.539 1.413.539 1.952 0 .42-.42.524-1.062.259-1.593l-1.235-2.469-1.235 2.469zM6.864 15.963c-.266.531-.162 1.173.259 1.593.539.539 1.413.539 1.952 0 .42-.42.524-1.062.259-1.593l-1.235-2.469-1.235 2.469zM13.137 15.174l5.608-5.608c1.197-1.197 1.197-3.138 0-4.335s-3.138-1.197-4.335 0l-1.273 1.273-1.273-1.273c-1.197-1.197-3.138-1.197-4.335 0s-1.197 3.138 0 4.335l5.608 5.608z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E",
            unit = "%"
        }
    }
end

function getWeaponID(modelid)
    if modelid:find("weapon_") then
        return modelid:gsub("weapon_", "")
    end
    return 0
end

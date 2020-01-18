local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

gatherTable = {
        {
            gather_zone = {-96766, 88886, 180},
            gather_item = "unprocessed_rock",
            gather_tool = "pickaxe",
            process_zone = {-82629, 90991, 481},
            process_item = "processed_rock",
            pickup_animation = "PICKAXE_SWING",
        },
        {
            gather_zone = {232464, 193521, 112},
            gather_item = "fish",
            gather_tool = "fishing_rod",
            pickup_animation= "FISHING",
        },
        {
            gather_zone = {-174432, 10837, 1831}, -- Champs du village
            gather_item = "peach",
            pickup_animation= "PICKUP_UPPER",
            gather_props = {
                -- Peach trees
                {model = 145, x = -174006, y = 10457, z = 1773, rx = 0, ry = 10, rz = 0},
                {model = 145, x = -173829, y = 10894, z = 1743, rx = 0, ry = 30, rz = 0},
                {model = 145, x = -173980, y = 11396, z = 1698, rx = 0, ry = 45, rz = 0},
                {model = 145, x = -174691, y = 11532, z = 1709, rx = 0, ry = 0, rz = 0},
                {model = 145, x = -175204, y = 11094, z = 1755, rx = 0, ry = 145, rz = 0},
                {model = 145, x = -175449, y = 11528, z = 1757, rx = 0, ry = 80, rz = 0},
                {model = 145, x = -175171, y = 12038, z = 1719, rx = 0, ry = 50, rz = 0},
                {model = 145, x = -174581, y = 12021, z = 1686, rx = 0, ry = 40, rz = 0},
            }
        },
        {
            gather_zone = {-45600, -106988, 2574},
            gather_item = "coca_leaf",
            process_zone = {-215517, -51147, 200},
            process_item = "cocaine",
            nb_items_per_processing = 3,
            gather_props = {
                -- Coca plants
                {model = 118, x = -45773, y = -106903, z = 2470},
                {model = 115, x = -45632, y = -106576, z = 2475},
                {model = 114, x = -45291, y = -106575, z = 2460},
                {model = 117, x = -45676, y = -107138, z = 2475},
                {model = 118, x = -45974, y = -106991, z = 2459},
                {model = 118, x = -46002, y = -106673, z = 2461},
                {model = 114, x = -45773, y = -106622, z = 2457},
                {model = 118, x = -45996, y = -106875, z = 2459},
                {model = 117, x = -45816, y = -106407, z = 2480},
                {model = 118, x = -45645, y = -106710, z = 2474},
                {model = 114, x = -45856, y = -106640, z = 2471},
                {model = 114, x = -46330, y = -106327, z = 2445},
                {model = 115, x = -46487, y = -106181, z = 2436},
                {model = 114, x = -46569, y = -106505, z = 2427},
                {model = 117, x = -46188, y = -106066, z = 2455},
                {model = 118, x = -46093, y = -106249, z = 2464},
                {model = 118, x = -46408, y = -106572, z = 2438},
                {model = 118, x = -45402, y = -107068, z = 2475},
                {model = 115, x = -45271, y = -106912, z = 2461},
                {model = 114, x = -45487, y = -106842, z = 2476},
                {model = 118, x = -45354, y = -106658, z = 2466},
                -- Process zone
                {model = 1093, x = -215575, y = -51368, z = 100, rx = 0, ry = 49, rz = 0},
                {model = 791, x = -215766, y = -50923, z = 98, rx = 0, ry = 44, rz = 0},
                {model = 887, x = -216356, y = -50306, z = 96, rx = 0, ry = 47, rz = 0},
                {model = 969, x = -215320, y = -50847, z = 110, rx = 0, ry = -47, rz = 0},
                {model = 970, x = -215351, y = -50942, z = 105, rx = 0, ry = 43, rz = 0},
                {model = 791, x = -215954, y = -51115, z = 98, rx = 0, ry = 44, rz = 0},
                {model = 501, x = -215909, y = -51147, z = 106, rx = 0, ry = 0, rz = 0},
                {model = 1099, x = -215450, y = -51220, z = 101, rx = 0, ry = -45, rz = 0},
                {model = 1160, x = -215479, y = -50969, z = 107, rx = 0, ry = 0, rz = 0},
            },
            require_knowledge = true
        },
}

gatherZoneCached = {}
processZoneCached = {}

AddEvent("OnPackageStart", function()
    for k, v in pairs(gatherTable) do
        if v.gather_zone ~= nil then
            v.gatherObject = CreatePickup(2, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3])
            CreateText3D(_("gather") .. "\n" .. _("press_e"), 18, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3] + 120, 0, 0, 0)
            table.insert(gatherZoneCached, v.gatherObject)
        end
        
        if v.process_zone ~= nil then
            v.processObject = CreatePickup(2, v.process_zone[1], v.process_zone[2], v.process_zone[3])
            CreateText3D(_("process") .. "\n" .. _("press_e"), 18, v.process_zone[1], v.process_zone[2], v.process_zone[3] + 120, 0, 0, 0)
            table.insert(processZoneCached, v.processObject)
        end
        
        if v.gather_props ~= nil then
            for kk, vv in pairs(v.gather_props) do
                if vv.ry ~= nil then
                    CreateObject(vv.model, vv.x, vv.y, vv.z, vv.rx, vv.ry, vv.rx)
                else
                    CreateObject(vv.model, vv.x, vv.y, vv.z)
                end
            end
        end
    end
end)


AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "gatheringSetup", gatherZoneCached, processZoneCached)
end)

AddEvent("OnPlayerDeath", function(player)
    PlayerData[player].onAction = false
    PlayerData[player].isActioned = false
end)


AddRemoteEvent("StartGathering", function(player, gatherzone)
    local gather = GetGatherByGatherzone(gatherzone)
    local animation = ""
    local attached_item = 0
    if gatherTable[gather].gather_tool ~= nil then
        if PlayerData[player].inventory[gatherTable[gather].gather_tool] == nil then
            return CallRemoteEvent(player, "MakeNotification", _("need_tool"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    end
    if PlayerData[player].onAction then
        PlayerData[player].onAction = false
        return CallRemoteEvent(player, "MakeNotification", _("gather_cancelled"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
    if GetPlayerVehicle(player) ~= 0 then
        return
    end
    if gatherTable[gather].gather_tool == "pickaxe" then
        attached_item = 1063
    elseif gatherTable[gather].gather_tool == "fishing_rod" then
        attached_item = 1111
    end

    if gatherTable[gather].pickup_animation ~= nil then
        animation = gatherTable[gather].pickup_animation
    else
        animation = "PICKUP_LOWER"
    end

    PlayerData[player].onAction = true
    
    function DoGathering(player, animation, gather, attached_item)
        if PlayerData[player].onAction and not PlayerData[player].isActioned then
            CallRemoteEvent(player, "LockControlMove", true)
            PlayerData[player].isActioned = true
            SetPlayerAnimation(player, animation)
            SetAttachedItem(player, "hand_r", attached_item)
            Delay(4000, function()
                SetPlayerAnimation(player, animation)
            end)
            Delay(8000, function()
                PlayerData[player].isActioned = false
                SetPlayerAnimation(player, "STOP")
                CallRemoteEvent(player, "LockControlMove", false)
                SetAttachedItem(player, "hand_r", 0)
                if AddInventory(player, gatherTable[gather].gather_item, 1) == true then
                    CallRemoteEvent(player, "MakeNotification", _("gather_success", _(gatherTable[gather].gather_item)), "linear-gradient(to right, #00b09b, #96c93d)")
                    return DoGathering(player, animation, gather, attached_item)
                else
                    CallRemoteEvent(player, "MakeNotification", _("inventory_notenoughspace"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                    PlayerData[player].onAction = false
                    return false
                end
            end)
        end
    end
    DoGathering(player, animation, gather, attached_item)
end)

AddRemoteEvent("StartProcessing", function(player, processzone)
    gather = GetGatherByProcesszone(processzone)
    unprocessed_item = gatherTable[gather].gather_item
    requireKnowledge = gatherTable[gather].require_knowledge
    processItem = gatherTable[gather].process_item or 1
    nbItemsPerProcessing = gatherTable[gather].nb_items_per_processing
    
    if PlayerData[player].onAction then
        PlayerData[player].onAction = false
        return
    end
    if GetPlayerVehicle(player) ~= 0 then
        return
    end

    -- On check si le joueur à la connaissance pour process cet item (si c'est requis)
    if requireKnowledge then
        local canProcess = 0
        for k,v in pairs(PlayerData[player].drug_knowledge) do
            if k == processItem and v == 1 then
                canProcess = 1
            end
        end
        if canProcess == 0 then 
            CallRemoteEvent(player, "MakeNotification", _("drugdealer_noknowledgeforthis"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            return
        end
    end

    PlayerData[player].onAction = true
    function DoProcessing(player, gather, unprocessed_item)
        if PlayerData[player].onAction and not PlayerData[player].isActioned then
            if PlayerData[player].inventory[unprocessed_item] == nil then
                PlayerData[player].onAction = false
                return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            end
            if tonumber(PlayerData[player].inventory[unprocessed_item]) < nbItemsPerProcessing then
                PlayerData[player].onAction = false
                return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent(player, "LockControlMove", true)
                RemoveInventory(player, unprocessed_item, nbItemsPerProcessing)
                SetPlayerAnimation(player, "COMBINE")
                PlayerData[player].isActioned = true
                Delay(4000, function()
                    SetPlayerAnimation(player, "COMBINE")
                end)
                Delay(8000, function()
                    PlayerData[player].isActioned = false
                    CallRemoteEvent(player, "LockControlMove", false)
                    SetPlayerAnimation(player, "STOP")
                    if AddInventory(player, gatherTable[gather].process_item, 1) then
                        CallRemoteEvent(player, "MakeNotification", _("process_success", _(gatherTable[gather].process_item)), "linear-gradient(to right, #00b09b, #96c93d)")
                        return DoProcessing(player, gather, unprocessed_item)
                    else
                        CallRemoteEvent(player, "MakeNotification", _("inventory_notenoughspace"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                        return false
                    end
                end)
            end
        end
    end
    DoProcessing(player, gather, unprocessed_item)
end)

function GetGatherByGatherzone(gatherzone)
    for k, v in pairs(gatherTable) do
        if v.gatherObject == gatherzone then
            return k
        end
    end
end

function GetGatherByProcesszone(processzone)
    for k, v in pairs(gatherTable) do
        if v.processObject == processzone then
            return k
        end
    end
end

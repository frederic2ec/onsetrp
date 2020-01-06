local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

gatherTable = {
        --[[ {
        gather_zone = { 186601, -39031, 1451 },
        gather_item = "unprocessed_weed",
        process_zone = { 70695, 9566, 1366 },
        process_item = "processed_weed"
        },
        {
        gather_zone = { 186474, -43277, 1451 },
        gather_item = "unprocessed_heroin",
        process_zone = { 73218, 3822, 1367 },
        process_item = "processed_heroin"
        },
        {
        gather_zone = { 193607, -46512, 1451 },
        gather_item = "unprocessed_meth",
        process_zone = { 72095, 1418, 1367 },
        process_item = "processed_meth"
        },
        {
        gather_zone = { 192080, -45155, 1529 },
        gather_item = "unprocessed_coke",
        process_zone = { 71981, 106, 1367 },
        process_item = "processed_coke"
        }, ]]
        {
            gather_zone = {-96766, 88886, 180},
            gather_item = "unprocessed_rock",
            gather_tool = "pickaxe",
            process_zone = {-82629, 90991, 481},
            process_item = "processed_rock"
        },
        {
            gather_zone = {232464, 193521, 112},
            gather_item = "fish",
            gather_tool = "fishing_rod",
        },
        {
            gather_zone = {-45600, -106988, 2574},
            gather_item = "coca_leaf",
            process_zone = {-215517, -51147, 200},
            process_item = "cocaine",
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
        return
    end
    if GetPlayerVehicle(player) ~= 0 then
        return
    end
    if gatherTable[gather].gather_tool == "pickaxe" then
        animation = "PICKAXE_SWING"
        attached_item = 1063
    elseif gatherTable[gather].gather_tool == "fishing_rod" then
        animation = "FISHING"
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
    processItem = gatherTable[gather].process_item
    
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
            if tonumber(PlayerData[player].inventory[unprocessed_item]) < 1 then
                PlayerData[player].onAction = false
                return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent(player, "LockControlMove", true)
                RemoveInventory(player, unprocessed_item, 1)
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

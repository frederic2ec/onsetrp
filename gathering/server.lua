local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

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
        gather_zone = { -96766, 88886, 180 },
        gather_item = "unprocessed_rock",
        gather_tool = "pickaxe",
        process_zone = { -82629, 90991, 481 },
        process_item = "processed_rock"
    },
}

gatherZoneCached = {}
processZoneCached = {}

AddEvent("OnPackageStart", function()
    for k,v in pairs(gatherTable) do
        if v.gather_zone ~= nil then
            v.gatherObject = CreatePickup(2, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3])
            CreateText3D(_("gather").."\n".._("press_e"), 18, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3] + 120, 0, 0, 0)
            table.insert(gatherZoneCached, v.gatherObject)
        end
        
        if v.process_zone ~= nil then
            v.processObject = CreatePickup(2, v.process_zone[1], v.process_zone[2], v.process_zone[3])
            CreateText3D(_("process").."\n".._("press_e"), 18, v.process_zone[1], v.process_zone[2], v.process_zone[3] + 120, 0, 0, 0)
            table.insert(processZoneCached, v.processObject)
        end
	end
end)


AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "gatheringSetup", gatherZoneCached, processZoneCached)
end)

AddRemoteEvent("StartGathering", function(player, gatherzone) 
    gather = GetGatherByGatherzone(gatherzone)
    if gatherTable[gather].gather_tool ~= nil then
        if PlayerData[player].inventory[gatherTable[gather].gather_tool] == nil then
            return CallRemoteEvent(player, "MakeNotification", _("need_tool"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    end
    if PlayerData[player].onAction then
        return
    end
    PlayerData[player].onAction = true
    CallRemoteEvent(player, "LockControlMove", true)
    SetPlayerAnimation(player, "COMBINE")
    Delay(4000, function() 
        SetPlayerAnimation(player, "COMBINE")
    end)
    Delay(8000, function()
        AddInventory(player, gatherTable[gather].gather_item, 1)
        CallRemoteEvent(player, "MakeNotification", _("gather_success", _(gatherTable[gather].gather_item)), "linear-gradient(to right, #00b09b, #96c93d)")
        PlayerData[player].onAction = false
        CallRemoteEvent(player, "LockControlMove", false)
    end)
end)

AddRemoteEvent("StartProcessing", function(player, processzone) 
    gather = GetGatherByProcesszone(processzone)
    unprocessed_item = gatherTable[gather].gather_item

    if PlayerData[player].onAction then
        return
    end
    if PlayerData[player].inventory[unprocessed_item] == nil then
        return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
    if tonumber(PlayerData[player].inventory[unprocessed_item]) < 1 then
         return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        PlayerData[player].onAction = true
        CallRemoteEvent(player, "LockControlMove", true)
        RemoveInventory(player, unprocessed_item, 1)
        SetPlayerAnimation(player, "COMBINE")
        Delay(4000, function() 
            SetPlayerAnimation(player, "COMBINE")
        end)
        Delay(8000, function()
            AddInventory(player, gatherTable[gather].process_item, 1)
            CallRemoteEvent(player, "MakeNotification", _("process_success", _(gatherTable[gather].process_item)), "linear-gradient(to right, #00b09b, #96c93d)")
            PlayerData[player].onAction = false
            CallRemoteEvent(player, "LockControlMove", false)
        end)
    end  
end)

function GetGatherByGatherzone(gatherzone)
    for k,v in pairs(gatherTable) do
        if v.gatherObject == gatherzone then
            return k
        end
    end
end

function GetGatherByProcesszone(processzone)
    for k,v in pairs(gatherTable) do
        if v.processObject == processzone then
            return k
        end
    end
end


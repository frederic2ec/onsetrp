local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

gatherTable = {
    {
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
    },
}

gatherZoneCached = {}
processZoneCached = {}

AddEvent("OnPackageStart", function()
    for k,v in pairs(gatherTable) do
        v.gatherObject = CreatePickup(2, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3])
        CreateText3D(_("gather").."\n".._("press_e"), 18, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3] + 120, 0, 0, 0)
        table.insert(gatherZoneCached, v.gatherObject)
        v.processObject = CreatePickup(2, v.process_zone[1], v.process_zone[2], v.process_zone[3])
        CreateText3D(_("process").."\n".._("press_e"), 18, v.process_zone[1], v.process_zone[2], v.process_zone[3] + 120, 0, 0, 0)
        table.insert(processZoneCached, v.processObject)
	end
end)


AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "gatheringSetup", gatherZoneCached, processZoneCached)
end)

AddRemoteEvent("StartGathering", function(player, gatherzone) 
    gather = GetGatherByGatherzone(gatherzone)
    SetPlayerAnimation(player, "COMBINE")
    Delay(4000, function() 
        SetPlayerAnimation(player, "COMBINE")
    end)
    Delay(8000, function()
        AddInventory(player, gatherTable[gather].gather_item, 1)
        AddPlayerChat(player, _("gather_success", _(gatherTable[gather].gather_item)))
    end)
end)

AddRemoteEvent("StartProcessing", function(player, processzone) 
    gather = GetGatherByProcesszone(processzone)
    unprocessed_item = gatherTable[gather].gather_item

    if PlayerData[player].inventory[unprocessed_item] == nil then
        AddPlayerChat(player, _("not_enough_item"))
    end
    if tonumber(PlayerData[player].inventory[unprocessed_item]) < 1 then
        AddPlayerChat(player, _("not_enough_item"))
    else
        RemoveInventory(player, unprocessed_item, 1)
        SetPlayerAnimation(player, "COMBINE")
        Delay(4000, function() 
            SetPlayerAnimation(player, "COMBINE")
        end)
        Delay(8000, function()
            AddInventory(player, gatherTable[gather].process_item, 1)
            AddPlayerChat(player, _("process_success", _(gatherTable[gather].process_item)))
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


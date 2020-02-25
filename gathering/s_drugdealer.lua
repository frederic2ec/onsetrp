local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end
local npcTable = {
    { x = -20242, y = -16094, z = 2063, h = -90 }
}

local npcTableCached = {}

local drugsUnitPrice = {
    cocaine = 42,
    weed = 7
}

AddEvent("OnPackageStart", function(player)
    for k,v in pairs(npcTable) do
        v.npcObject = CreateNPC(v.x, v.y, v.z, v.h)
        SetNPCAnimation(v.npcObject, "WALLLEAN04", 1)
        table.insert( npcTableCached, v.npcObject )
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "drugdealer:setup", npcTableCached)
end)

AddRemoteEvent("drugdealer:prepareconversation", function(player)
    local wts = 0
    if PlayerData[player].inventory['cocaine'] ~= nil and PlayerData[player].inventory['cocaine'] > 0 then wts = 1 end
    if PlayerData[player].inventory['weed'] ~= nil and PlayerData[player].inventory['weed'] > 0 then wts = 1 end
    CallRemoteEvent(player, "drugdealer:startconversation", PlayerData[player].drug_knowledge, PlayerData[player].job, wts)    
end)

AddRemoteEvent("drugdealer:proceedpayment", function(player, amount, knowledge)
    local cash = GetPlayerCash(player)
    if cash >= amount then
        RemovePlayerCash(player, amount)
        PlayerData[player].drug_knowledge[knowledge] = 1
        MessageCreated(0, PlayerData[player].phone_number, _("drugdealer_tempinfo"))        
        CallRemoteEvent(player, "drugdealer:paymentsucceed")        
    else
        CallRemoteEvent(player, "drugdealer:paymentfail")
    end
end)

AddRemoteEvent("drugdealer:checkingdrugs", function(player, npc) 
    SetNPCAnimation(npc, "THINKING", true)
end)

AddRemoteEvent("drugdealer:doneworking", function(player, npc) 
    SetNPCAnimation(npc, "WALLLEAN04", true)
    local drugs = {}
    for k,v in pairs(PlayerData[player].inventory) do
        if k == "cocaine" then
            table.insert( drugs, { label= "cocaine", nb= v, price= v*drugsUnitPrice[k] } )            
        end
        if k == "weed" then
            table.insert( drugs, { label= "weed", nb= v, price= v*drugsUnitPrice[k] } )            
        end
    end
    CallRemoteEvent(player, "drugdealer:selldrugs", drugs)
    
end)

AddRemoteEvent("drugdealer:doneselling", function(player, price)
    for k,v in pairs(PlayerData[player].inventory) do
        if k == "cocaine" then
            RemoveInventory(player, k, v)          
        end
        if k == "weed" then
            RemoveInventory(player, k, v)          
        end
    end
    AddPlayerCash(player, price)
    CallRemoteEvent(player, "MakeNotification",_("drugdealer_yousolddrugs", price), "linear-gradient(to right, #00b09b, #96c93d)")
end)


-- AddCommand("showdrugs", function(player)
--     if PlayerData[player].job ~= "police" and PlayerData[player].job ~= "medic" and PlayerData[player].drug_knowledge ~= nil then
--         CallRemoteEvent(player, "drugdealer:showdrugs", PlayerData[player].drug_knowledge)        
--     end
-- end)

-- AddCommand("hidedrugs", function(player)
--     CallRemoteEvent(player, "drugdealer:hidedrugs")        
-- end)


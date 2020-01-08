local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end
local CUI = ImportPackage("cinematicui")

local npcTableIds = {}

local priceKnowledge = 5000

AddRemoteEvent("drugdealer:setup", function(npcObjects)
    npcTableIds = npcObjects
end)

AddEvent("OnKeyPress", function(key)
    if key == "E" and not onSpawn and not onCharacterCreation then
        
        if GetNearestNpc() ~= 0 then
            CallRemoteEvent("drugdealer:prepareconversation")
        end
    end
end)

AddRemoteEvent("drugdealer:startconversation", function(knowledges, police, medic, wts)
    local params = {
        title = _("drugdealer_name"),
        actions = {}
    }
    
    if police == 0 and medic == 0 then -- On envoie chier la police et les médecins
        local cocaine = 0 -- On récupère les connaissances du joueur
        for k, v in pairs(knowledges) do
            if k == "cocaine" then cocaine = v end
        end
        
        if cocaine == 1 then -- Si le joueur possède toute les connaissances de drogues
            params.message = _("drugdealer_nothingicando")
            if wts == 1 then -- Si le joueur à de la drogue sur lui
                table.insert(params.actions, {
                    text = _("drugdealer_wts"),
                    callback = "SellDrugs"
                })
            end
            table.insert(params.actions, {
                text = _("drugdealer_bye"),
                close_on_click = true
            })
        else
            params.message = _("drugdealer_ask_drug")
            
            if cocaine == 0 then -- Ajout du bouton pour acheter la pos de la cocaine
                table.insert(params.actions, {
                    text = _("drugdealer_answer_cocain"),
                    callback = "YesCocaine",
                })
            end
            if wts == 1 then -- Si le joueur à de la drogue sur lui
                table.insert(params.actions, {
                    text = _("drugdealer_wts"),
                    callback = "SellDrugs"
                })
            end
            table.insert(params.actions, {
                text = _("drugdealer_no"),
                close_on_click = true
            })
        end
    else
        params.message = _("drugdealer_governement")
        table.insert(params.actions, {
            text = _("drugdealer_bye"),
            close_on_click = true
        })
    end
    
    CUI.startCinematic(params, NearestNpc, "WALLLEAN04")
end)

-- COCAINE
AddEvent("YesCocaine", function()
    local params = {
        message = _("drugdealer_ask_payment", priceKnowledge),
        actions = {
            {
                text = _("drugdealer_yes"),
                callback = "ConfirmPaymentCocaine",
            },
            {
                text = _("drugdealer_no"),
                close_on_click = true
            }
        }
    }
    CUI.updateCinematic(params)
end)

AddEvent("ConfirmPaymentCocaine", function()
    CallRemoteEvent("drugdealer:proceedpayment", priceKnowledge, "cocaine")
end)

AddRemoteEvent("drugdealer:paymentsucceed", function()
    local params = {
        message = _("drugdealer_explain"),
        actions = {
            {
                text = _("drugdealer_bye"),
                close_on_click = true
            }
        }
    }
    CUI.updateCinematic(params)
end)

AddRemoteEvent("drugdealer:paymentfail", function()
    local params = {
        message = _("drugdealer_notenoughmoney"),
        actions = {
            {
                text = _("drugdealer_bye"),
                close_on_click = true
            }
        }
    }
    CUI.updateCinematic(params)
end)

AddEvent("SellDrugs", function()
    local params = {
        message = _("drugdealer_checkdrugs"),
        actions = {
            {
                text = _("drugdealer_yes"),
                callback = "ConfirmSell",
                close_on_click = true
            },
            {
                text = _("drugdealer_no"),
                close_on_click = true
            }
        }
    }
    CUI.updateCinematic(params)
end)

AddEvent("ConfirmSell", function()
    local npc = GetNearestNpc()
    CallRemoteEvent("drugdealer:checkingdrugs", npc)
    
    Delay(10000, function()
        CallRemoteEvent("drugdealer:doneworking", npc)
        
    end)
end)

local totalPrice = 0
AddRemoteEvent("drugdealer:selldrugs", function(drugs)
    local npc = GetNearestNpc()
    if npc ~= 0 then            
        local params = {
            title = _("drugdealer_name"),
            message = _("drugdealer_dealmsg")
        }

        totalPrice = 0
        for k,v in pairs(drugs) do
            params.message = params.message .. " " .. _("drugdealer_for", v.price, v.nb, v.label)
            totalPrice = totalPrice + v.price
        end

        params.actions = {
            {
                text = _("drugdealer_yes"),
                callback = "DoneSelling",
                close_on_click = true
            },
            {
                text = _("drugdealer_no"),
                close_on_click = true
            }
        }

        CUI.startCinematic(params, npc, "WALLLEAN04")
    else            
        MakeNotification(_("drugdealer_toofaraway"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)

AddEvent("DoneSelling", function()
    CallRemoteEvent("drugdealer:doneselling", totalPrice)    
end)


function GetNearestNpc()
    local x, y, z = GetPlayerLocation()
    
    for k, v in pairs(npcTableIds) do
        local x2, y2, z2 = GetNPCLocation(v)
        if x2 == nil or x2 == false then return 0 end
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        
        if dist < 200.0 then
            for k, i in pairs(npcTableIds) do                
                if v == i then
                    return v
                end
            end
        end
    end
    
    return 0
end

local gpsTable = {}

AddRemoteEvent("drugdealer:showdrugs", function(knowledges)
    gpsTable = {}
    
    table.insert(gpsTable, {label = _("drugdealer_name"), x = 38011, y = 144418, z = 1400})
    
    for k, v in pairs(knowledges) do
        if k == "cocaine" and v == 1 then
            table.insert(gpsTable, {label = _("gather") .. " " .. _("coca_leaf"), x = -45600, y = -106988, z = 2574})
            table.insert(gpsTable, {label = _("process") .. " " .. _("coca_leaf"), x = -215517, y = -51147, z = 200})
        end
    end
    
    for k, v in pairs(gpsTable) do
        gpsTable[k].waypoint = CreateWaypoint(v.x, v.y, v.z, v.label)
    end
end)

AddRemoteEvent("drugdealer:hidedrugs", function()
    for k, v in pairs(gpsTable) do
        DestroyWaypoint(gpsTable[k].waypoint)
    end
end)

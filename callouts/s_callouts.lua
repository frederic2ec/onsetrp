local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local callOuts = {}

AddCommand("ccmed", function(player)
    CreateCallout(player, "medic", "Coma")
end)

AddCommand("ccpol", function(player)
    CreateCallout(player, "police", "on m'a volé mon argent moumoumou")
end)


--------- CALLOUTS
AddCommand("clearcallouts", function(player)
    if PlayerData[player].admin ~= 1 then return end
    callOuts = {}
    print('CALLOUTS → Cleared')
end)

function CreateCallout(player, job, label)-- create a new callout
    if callOuts[player] ~= nil and callOuts[player].taken ~= false then return end
    local x, y, z = GetPlayerLocation(player)    
    if PlayerData[player].job == "police" then
        label = "[POL] "..label
    elseif PlayerData[player].job == "medic" then
        label = "[MED] "..label
    end
    callOuts[player] = {location = {x = x, y = y, z = z}, taken = false, job= job, label= label}
    CalloutsNotifyPlayers(callOuts[player])
    if job == "medic" then
        CallRemoteEvent(player, "MakeNotification", _("medic_callout_created"), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
    elseif job == "police" then
        CallRemoteEvent(player, "MakeNotification", _("police_callout_created"), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
    else
        CallRemoteEvent(player, "MakeNotification", _("callout_created"), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
    end
end
AddRemoteEvent("callouts:create", CreateCallout)

function CalloutsNotifyPlayers(callout)-- send the new callout to medics and policemens
    for k, v in pairs(GetAllPlayers()) do
        if callout.job == PlayerData[v].job then
            if callout.job == "medic" then
                CallRemoteEvent(v, "MakeNotification", _("medic_new_callout", callout.label), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
                CallRemoteEvent(v, "medic:deathalarm")         
            elseif callout.job == "police" then
                CallRemoteEvent(v, "MakeNotification", _("police_new_callout", callout.label), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
                CallRemoteEvent(v, "medic:deathalarm")
            else  
                CallRemoteEvent(v, "MakeNotification", _("new_callout", callout.label), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
            end
        end        
    end
end

function CalloutTake(player, target)-- allow  to take the callout
    if PlayerData[player].job ~= "medic" and PlayerData[player].job ~= "police" then return end
    if callOuts[tonumber(target)] == nil then return end
    for k,v in pairs(callOuts) do
        if v.taken == player then
            CallRemoteEvent(player, "MakeErrorNotification", _("callout_already_have_callout"))
            return
        end
    end
    if callOuts[tonumber(target)].taken ~= false then
        CallRemoteEvent(player, "MakeErrorNotification", _("callout_taken_by", PlayerData[callOuts[tonumber(target)].taken].name))
        return
    end
    callOuts[tonumber(target)].taken = player
    local x, y, z = GetPlayerLocation(tonumber(target))
    local label
    if PlayerData[player].job == "medic" then
        label = _("medic_waypoint_label")
    elseif PlayerData[player].job == "police" then
        label = _("police_waypoint_label")
    else
        label = _("callout_waypoint_label")
    end
    CallRemoteEvent(player, "callouts:createwp", tonumber(target), x, y, z, label)
    CallRemoteEvent(player, "MakeNotification", _("callouts_you_took_callout"), "linear-gradient(to right, #00b09b, #96c93d)")
    CallRemoteEvent(tonumber(target), "MakeNotification", _("callout_has_been_taken"), "linear-gradient(to right, #00b09b, #96c93d)", 10000)
end
AddRemoteEvent("callouts:start", CalloutTake)

function CalloutEnd(player, target)-- allow  to end a callout
    if PlayerData[player].job ~= "medic" and PlayerData[player].job ~= "police" then return end
    if callOuts[tonumber(target)] == nil then return end
    if callOuts[tonumber(target)].taken ~= player then return end
    callOuts[tonumber(target)] = nil
    CallRemoteEvent(player, "callouts:cleanwp", tonumber(target))
    CallRemoteEvent(player, "MakeNotification", _("callouts_ended_callout"), "linear-gradient(to right, #00b09b, #96c93d)")
end
AddRemoteEvent("callouts:end", CalloutEnd)

AddRemoteEvent("callouts:getlist", function(player)
    if PlayerData[player].job ~= "medic" and PlayerData[player].job ~= "police" then return end

    local x,y,z = GetPlayerLocation(player)
    
    local calloutsList = {}
    for k,v in pairs(callOuts) do
        if v.job == PlayerData[player].job then
            local x2,y2,z2 = GetPlayerLocation(k)
            local dist = math.floor(tonumber(GetDistance2D(x, y, x2, y2)) / 100)
            calloutsList[k] = tostring(dist).." m  - "..v.label.." ("..PlayerData[k].name..")"
            if v.taken ~= false then            
                calloutsList[k] = calloutsList[k].."   ".._("medic_callout_taken_menu", PlayerData[player].name)
            end
        end
    end

    CallRemoteEvent(player, "callouts:displaymenu", calloutsList)    
end)

--------- CALLOUTS END
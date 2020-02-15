local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local callOuts = {}

AddCommand("med", function(player, label)
    CreateCallout(player, "medic", tostring(label))
end)

AddCommand("911", function(player, label)
    CreateCallout(player, "police", tostring(label))
end)


--------- CALLOUTS
AddCommand("clearcallouts", function(player)
    if PlayerData[player].admin ~= 1 then return end
    callOuts = {}
    UpdateCalloutsList(player)
    print('CALLOUTS → Cleared')
end)

function CreateCallout(player, job, label)-- create a new callout
    label = string.gsub(label, '"', '')
    if callOuts[player] ~= nil and callOuts[player].taken ~= false then return end
    local x, y, z = GetPlayerLocation(player)
    local caller_job = nil

    if PlayerData[player].job == "police" then
        caller_job = 'police'
    elseif PlayerData[player].job == "medic" then
        caller_job = 'medic'
    end

    callOuts[player] = { location = {x = x, y = y, z = z}, taken = false, job = job, label = label, caller_job = caller_job }
    CalloutsNotifyPlayers(callOuts[player])
    UpdateCalloutsList(player, job)

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

    UpdateCalloutsList(player)

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
    UpdateCalloutsList(player)
    CallRemoteEvent(player, "callouts:cleanwp", tonumber(target))
    CallRemoteEvent(player, "MakeNotification", _("callouts_ended_callout"), "linear-gradient(to right, #00b09b, #96c93d)")
end
AddRemoteEvent("callouts:end", CalloutEnd)

AddRemoteEvent("callouts:getlist", function(player)
    local calloutsList = GetCalloutsList(player)

    CallRemoteEvent(player, "callouts:displaymenu", calloutsList)    
end)

function UpdateCalloutsList(player, job)
    local job = job or PlayerData[player].job
    
    for k, v in pairs(GetAllPlayers()) do
        if job == PlayerData[v].job then
            local calloutsList = GetCalloutsList(v)
            CallRemoteEvent(v, "callouts:updatelist", calloutsList)  
        end
    end
end

function GetCalloutsList(player)
    if PlayerData[player].job ~= "medic" and PlayerData[player].job ~= "police" then return { } end

    local x,y,z = GetPlayerLocation(player)
    
    local calloutsList = {}

    for k,v in pairs(callOuts) do
        if v.job == PlayerData[player].job then
            local x2,y2,z2 = GetPlayerLocation(k)
            local dist = math.floor(tonumber(GetDistance2D(x, y, x2, y2)) / 100)

            local taken = v.taken

            if v.taken then
                if taken == player then
                    taken = 'me'
                else
                    taken = PlayerData[taken].name
                end
            end

            table.insert(calloutsList, {
                id = k,
                from = PlayerData[k].name,
                job = v.caller_job,
                reason = v.label,
                distance = dist,
                taken = taken
            })
        end
    end

    return calloutsList
end

--------- CALLOUTS END
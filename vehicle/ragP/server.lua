 -- Made with 🖤 By Bad
 -- https://github.com/Bad57/ragP
 
 AddRemoteEvent("RagdollPlayer", function (player, currentspeed,vehicle)
    if currentspeed < S_vitesseMin then return end
    for _, v in pairs(S_ignoredVehicles) do
        if tostring(GetVehicleModelName(vehicle)) == v then return end
    end

    local currenthealth = GetPlayerHealth(player)
    local random = math.random(100)
    if random < S_minP then random = S_minP end
    random = random/100

    SetPlayerHealth(player, math.floor(currenthealth-((currentspeed*S_ratioDegats)*random)))
    local ragTime = math.floor((currentspeed/2)*random)*1000
    Delay(100, function ()
        SetPlayerRagdoll(player,true)
        Delay(ragTime,function()
            SetPlayerRagdoll(player,false)
            SetPlayerAnimation(player, S_animation)
        end)
    end)
end)


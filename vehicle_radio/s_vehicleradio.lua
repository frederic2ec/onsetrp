sr = ImportPackage("soundstreamer")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local Radios = {
    {label = "NoCopyrightSound Radio", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://51.15.152.81:8947/listen.pls?sid=1&t=.pls"},
    {label = "BELQC RADIO by Raph & Jeanmi (OnsetRP-FR Community)", url = "https://manager2.creativradio.com:2220/raphaelgonay/1/itunes.pls"},
    {label = "Metal - Idobi Howl", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://69.46.88.26:80/listen.pls&t=.pls"},
    {label = "Reggae - 24-7 Reggae", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://146.71.124.10:8200/listen.pls?sid=1&t=.pls"},
    {label = "House - BLUE MARLIN IBIZA RADIO", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://95.211.3.65:8635/listen.pls?sid=1&t=.pls"},
    {label = "Jazz - BEST SMOOTH JAZZ - UK (LONDON) HOST ROD LUCAS", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://64.95.243.43:8002/listen.pls?sid=1&t=.pls"},
    {label = "Latino - El Metro Salsero", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://198.178.123.14:7516/listen.pls?sid=1&t=.pls"},
    {label = "Hip Hop - FMHiphop.com", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://149.56.175.167:5708/listen.pls?sid=1&t=.pls"},
    {label = "Psytrance - psyradio * fm - progressive", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://81.88.36.42:8010/listen.pls?sid=1&t=.pls"}
}

local nowPlaying = {}
local TIMER_REFRESH_RADIO_POSITION = 25
local HOOD_BONUS = 300
local RADIO_RADIUS = 800
local BASE_VOLUME = 0.2

AddEvent("OnPackageStart", function()
    CreateTimer(function()        
        for k, v in pairs(nowPlaying) do
            if IsValidVehicle(k) then            
                local x, y, z = GetVehicleLocation(k)
                sr.SetSound3DLocation(v.sound, x, y, z + HOOD_BONUS)
                local x2,y2,z2 = GetObjectLocation(v.sound)
            else
                sr.DestroySound3D(nowPlaying[k].sound)
                nowPlaying[k] = nil
            end
        end    
    end, TIMER_REFRESH_RADIO_POSITION)
end)

function VehicleRadioToggle(player)
    local veh = GetPlayerVehicle(player)
    if veh ~= nil and veh ~= 0 then
        if GetPlayerVehicleSeat(player) ~= 1 and GetPlayerVehicleSeat(player) ~= 2 then return end
        local x, y, z = GetVehicleLocation(veh)
        if nowPlaying[veh] ~= nil then
            sr.DestroySound3D(nowPlaying[veh].sound)
            nowPlaying[veh] = nil
            for k=1, GetVehicleNumberOfSeats(veh) do
                local target = GetVehiclePassenger(veh, k)
                if IsValidPlayer(target) then 
                    CallRemoteEvent(target, "vehicle:radio:toggleui", false)
                end
            end
        else
            nowPlaying[veh] = {}
            nowPlaying[veh].channel = 1
            local sound = sr.CreateSound3D(Radios[1].url, x, y, z + HOOD_BONUS, RADIO_RADIUS, BASE_VOLUME)
            nowPlaying[veh].sound = sound
            nowPlaying[veh].volume = BASE_VOLUME            
            for k=1, GetVehicleNumberOfSeats(veh) do                
                local target = GetVehiclePassenger(veh, k)
                if IsValidPlayer(target) then 
                    CallRemoteEvent(target, "vehicle:radio:toggleui", true) 
                    CallRemoteEvent(target, "vehicle:radio:updateui", Radios[nowPlaying[veh].channel].label, nowPlaying[veh].volume)  
                end
            end                  
        end
    end
end
AddRemoteEvent("vehicle:radio:toggle", VehicleRadioToggle)

function VehicleRadioUpdateVolume(player, increaseOrLower)
    local veh = GetPlayerVehicle(player)
    if veh ~= nil and veh ~= 0 and nowPlaying[veh] ~= nil then
        if GetPlayerVehicleSeat(player) ~= 1 and GetPlayerVehicleSeat(player) ~= 2 then return end
        if increaseOrLower == 1 then -- Increase
            nowPlaying[veh].volume = nowPlaying[veh].volume + 0.1
            if nowPlaying[veh].volume > 2 then nowPlaying[veh].volume = 2 end
        elseif increaseOrLower == 2 then -- Lower
            nowPlaying[veh].volume = nowPlaying[veh].volume - 0.1
            if nowPlaying[veh].volume < 0 then nowPlaying[veh].volume = 0 end
        end
        sr.SetSound3DVolume(nowPlaying[veh].sound, nowPlaying[veh].volume)
        for k=1, GetVehicleNumberOfSeats(veh) do
            local target = GetVehiclePassenger(veh, k)
            if IsValidPlayer(target) then CallRemoteEvent(target, "vehicle:radio:updateui", Radios[nowPlaying[veh].channel].label, nowPlaying[veh].volume) end
        end    
    end
end
AddRemoteEvent("vehicle:radio:updatevolume", VehicleRadioUpdateVolume)

function VehicleRadioUpdateChannel(player, channelId)
    local veh = GetPlayerVehicle(player)
    if veh ~= nil and veh ~= 0 and nowPlaying[veh] ~= nil and channelId <= 9 then
        if GetPlayerVehicleSeat(player) ~= 1 and GetPlayerVehicleSeat(player) ~= 2 then return end
        local x, y, z = GetVehicleLocation(veh)
        sr.DestroySound3D(nowPlaying[veh].sound)
        Delay(500, function()
            local sound = sr.CreateSound3D(Radios[channelId].url, x, y, z + HOOD_BONUS, RADIO_RADIUS, nowPlaying[veh].volume)        
            nowPlaying[veh].sound = sound
            nowPlaying[veh].channel = channelId   
            for k=1, GetVehicleNumberOfSeats(veh) do
                local target = GetVehiclePassenger(veh, k)
                if IsValidPlayer(target) then CallRemoteEvent(target, "vehicle:radio:updateui", Radios[nowPlaying[veh].channel].label, nowPlaying[veh].volume) end
            end
        end)
    end
end
AddRemoteEvent("vehicle:radio:updatechannel", VehicleRadioUpdateChannel)

AddEvent("OnPlayerLeaveVehicle", function(player, veh, seat)
    if seat == 1 and nowPlaying[veh] ~= nil then
        sr.DestroySound3D(nowPlaying[veh].sound)
        nowPlaying[veh] = nil        
    end
    CallRemoteEvent(player, "vehicle:radio:toggleui", false)
end)

AddEvent("OnPlayerEnterVehicle", function(player, veh, seat)
    if nowPlaying[veh] ~= nil then
        CallRemoteEvent(player, "vehicle:radio:toggleui", true)
    end
end)

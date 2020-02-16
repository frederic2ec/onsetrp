sr = ImportPackage("soundstreamer")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local Radios = {
    {label = "NCS #1", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://51.15.152.81:8947/listen.pls?sid=1&t=.pls"},
    {label = "NCS #2", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://91.121.113.129:9115/listen.pls?sid=1&t=.pls"},
    {label = "Metal", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://5.135.154.69:11590/listen.pls?sid=1&t=.pls"},
    {label = "Reggae", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us5.internet-radio.com:8487/listen.pls&t=.pls"},
    {label = "Dance", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://pulseedm.cdnstream1.com:8124/1373_128.m3u&t=.pls"},
    {label = "Jazz", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://199.180.72.2:8015/listen.pls?sid=1&t=.pls"},
    {label = "Rap", url = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://192.211.51.158:8010/listen.pls?sid=1&t=.pls"},
}

local nowPlaying = {}
local TIMER_REFRESH_RADIO_POSITION = 25
local HOOD_BONUS = 70
local RADIO_RADIUS = 500
local BASE_VOLUME = 0.2

AddEvent("OnPackageStart", function()
    CreateTimer(function()        
        for k, v in pairs(nowPlaying) do
            local x, y, z = GetVehicleLocation(k)
            sr.SetSound3DLocation(v.sound, x, y, z + HOOD_BONUS)
            local x2,y2,z2 = GetObjectLocation(v.sound)
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
        else
            nowPlaying[veh] = {}
            nowPlaying[veh].channel = 1
            local sound = sr.CreateSound3D(Radios[1].url, x, y, z + HOOD_BONUS, RADIO_RADIUS, BASE_VOLUME)        
            nowPlaying[veh].sound = sound
            nowPlaying[veh].volume = BASE_VOLUME
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
            if nowPlaying[veh].volume > 1 then nowPlaying[veh].volume = 1 end
        elseif increaseOrLower == 2 then -- Lower
            nowPlaying[veh].volume = nowPlaying[veh].volume - 0.1
            if nowPlaying[veh].volume < 0 then nowPlaying[veh].volume = 0 end
        end
        sr.SetSound3DVolume(nowPlaying[veh].sound, nowPlaying[veh].volume)
    end
end
AddRemoteEvent("vehicle:radio:updatevolume", VehicleRadioUpdateVolume)

function VehicleRadioUpdateChannel(player, channelId)
    local veh = GetPlayerVehicle(player)
    if veh ~= nil and veh ~= 0 and nowPlaying[veh] ~= nil then
        if GetPlayerVehicleSeat(player) ~= 1 and GetPlayerVehicleSeat(player) ~= 2 then return end
        local x, y, z = GetVehicleLocation(veh)
        sr.DestroySound3D(nowPlaying[veh].sound)
        local sound = sr.CreateSound3D(Radios[channelId].url, x, y, z + HOOD_BONUS, RADIO_RADIUS, nowPlaying[veh].volume)        
        nowPlaying[veh].sound = sound
    end
end
AddRemoteEvent("vehicle:radio:updatechannel", VehicleRadioUpdateChannel)

AddEvent("OnPlayerLeaveVehicle", function(player, veh, seat)
    if seat == 1 and nowPlaying[veh] ~= nil then
        sr.DestroySound3D(nowPlaying[veh].sound)
        nowPlaying[veh] = nil
    end
end)

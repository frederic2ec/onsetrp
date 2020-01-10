local devMode = false
local legendKeys = {}

local function PinLog(msg) --Just a custom log function that I use instead of print so it's clear what package the msg is from on server console
    print("[Pinmap] - " .. msg)
end

local function Test(msg)
    print(msg)
end
AddEvent("Test", Test)

local function OnPackageStart() 
    if not file_exists("packages/" .. GetPackageName() .. "/hud/pinmap/config.ini") then
        return PinLog("Failed to load the config.ini file! Critical Error!")
    end
    local ini = ini_open("packages/" .. GetPackageName() .. "/hud/pinmap/config.ini")

    --Check for dev mode
    local devModeValue = ini_read(ini, "developer", "developerModeEnabled")
    if (devModeValue == "true") then
        devMode = true
        AddRemoteEvent("PinmapRequestTeleport", ProcessTeleportRequest) --Enable the remote event for requesting teleports if dev mode is enabled
        PinLog("Developer mode is enabled! This will allow players to teleport. To turn off developer mode, please see the config.ini file in the Pinmap package!")
    end

    

    --Parse map legend data
    local legendKeyCount = ini_read(ini, "mapLegend", "keyCount")
    if (is_numeric(legendKeyCount)) then
        for i = 1, legendKeyCount do
            local keyName = ini_read(ini, "mapLegend", "key" .. i)
            if (keyName == nil or keyName == '') then
                return PinLog("Critical Error! Could not parse [mapLegend] - \"key" .. i .. "\" field! Config.ini not properly configured!")
            end
            local newKey = {}
            newKey.id = keyName
            newKey.blipCount = ini_read(ini, keyName, "blipCount")
            if (is_numeric(newKey.blipCount) ~= true) then
                return PinLog("Critical Error! Could not parse [" .. keyName .. "] - \"blipCount\" field! Config.ini is not properly configured! Expected an integer!")
            end
            newKey.iconPath = ini_read(ini, keyName, "iconPath")
            if (newKey.iconPath == nil or newKey.iconPath == '') then
                return PinLog("Critical Error! Could not parse [" .. keyName .. "] - \"iconPath\" field! Config.ini not properly configured!")
            end
            newKey.displayText = ini_read(ini, keyName, "displayText")
            if (newKey.displayText == nil or newKey.displayText == '') then
                return PinLog("Critical Error! Could not parse [" .. keyName .. "] - \"displayText\" field! Config.ini not properly configured!")
            end
            newKey.blips = {}
            for j = 1, newKey.blipCount do
                local blipstring = ini_read(ini, keyName, "blip" .. j)
                local coords = splitstring(blipstring, ',')
                if (#coords ~= 2) then
                    return PinLog("Critical Error! Expected [x, y] coordinate set! Failed to parse [" .. keyName .. "] \"blip" .. j .. "\" field! Config.ini is not properly configured!")
                end
                if (is_numeric(coords[1]) ~= true) then
                    return PinLog("Critical Error! Expected [x, y] coordinate set! Failed to parse [" .. keyName .. "] \"blip" .. j .. "\" field! X coordinate was not numeric! Config.ini is not properly configured!")
                end
                if (is_numeric(coords[2]) ~= true) then
                    return PinLog("Critical Error! Expected [x, y] coordinate set! Failed to parse [" .. keyName .. "] \"blip" .. j .. "\" field! Y coordinate was not numeric! Config.ini is not properly configured!")
                end
                local blip = {}
                blip.x = coords[1]
                blip.y = coords[2]
                newKey.blips[j] = blip
            end
            legendKeys[#legendKeys + 1] = newKey
        end
    else
        return PinLog("Critical Error! - Could not parse [mapLegend] - \"keyCount\" field! Config.ini not properly configured! Expected an integer!")
    end

end
AddEvent("OnPackageStart", OnPackageStart)

local function OnPlayerJoin(player)
    if (devMode) then
        CallRemoteEvent(player, "PinmapEnableDevmode") --If the server is ran in dev mode, we call a remote event to tell the client that it is in dev mode so the client can add the teleport option to right click menu on map
    end
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

local function PinmapRequestLegend(player)
    local kc = 0
    for i = 1, #legendKeys do
        CallRemoteEvent(player, "PinmapRegisterLegendKey", legendKeys[i].id,  legendKeys[i].displayText, legendKeys[i].iconPath)
        for j, blip in ipairs(legendKeys[i].blips) do
            CallRemoteEvent(player, "PinmapRegisterBlip", legendKeys[i].id, blip.x, blip.y)
        end
    end
end
AddRemoteEvent("PinmapRequestLegend", PinmapRequestLegend)

function ProcessTeleportRequest(player, worldX, worldY, worldZ) --Teleports player, this will only be called if the remote event is enabled IF the server is ran in dev mode (see config.ini file)
    SetPlayerLocation(player, worldX, worldY, worldZ)
end

function file_exists(filename) --function copy&pasted from onset lua script examples to check if file exists
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function is_numeric(n) --function to check if var is int
    local x = tonumber(n)
    if (x == nil) then 
        print(n)
        return false 
    end
    return true
end

function splitstring(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
local i18n = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local mapGui = nil
local miniMapGui = nil
local devMode = false
local mapUILoaded = false
local minimapUILoaded

local function OnPackageStart()
	local screenX, screenY = GetScreenSize()
	mapGui = CreateWebUI(0, 0, 0, 0)
	LoadWebFile(mapGui, "http://asset/" .. GetPackageName() .. "/hud/pinmap/client/web/map.html")

	SetWebAlignment(mapGui, 0, 0)
	SetWebAnchors(mapGui, 0.1, 0.1, 0.9, 0.9) --Set up my web ui to take up the center 80% of the screen

    SetWebVisibility(mapGui, WEB_HIDDEN)
    
    local minimapWidth = 300
    local minimapHeight = 300
    local minX = 0 + 30/screenX
    local maxX = 0 + 30/screenX + minimapWidth/screenX
    local minY = 1 - minimapHeight/screenY - 30/screenY
    local maxY = 1 - 30/screenY
	miniMapGui = CreateWebUI(0, 0, 0, 0, 0, 144)
	LoadWebFile(miniMapGui, "http://asset/" .. GetPackageName() .. "/hud/pinmap/client/web/minimap.html")

	SetWebAlignment(miniMapGui, 0, 0)
	SetWebAnchors(miniMapGui, minX, minY, maxX, maxY) --Set up my web ui to take up the center 80% of the screen

	SetWebVisibility(miniMapGui, WEB_HITINVISIBLE)
end
AddEvent("OnPackageStart", OnPackageStart)

function InitializeMapValues() --This will send the width/height of the map which will be used by the WebUI to make sure user does not drag map off screen as well as send the legend info
	local screenX, screenY = GetScreenSize()
	mapWidth = screenX * 0.8
	mapHeight = screenY * 0.8
	jsString = "AssignParameters(" .. mapWidth .. "," .. mapHeight ..");"
	ExecuteWebJS(mapGui, jsString)

	if (devMode) then
		ExecuteWebJS(mapGui, "EnableDevMode();") --When EnableDevMode() is called in the js, it adds the menu option for "Teleport Here" in the right click menu on the map
	end
	
    mapUILoaded = true
    if (minimapUILoaded) then
        CallRemoteEvent("PinmapRequestLegend")
    end
end
AddEvent("OnMapUILoaded", InitializeMapValues) --This event is called by the map.js after the page is loaded. If we try to execute the web js before the page is loaded, it's invalid behavior.

function InitializeMinimapValues() --This will send the width/height of the map which will be used by the WebUI to make sure user does not drag map off screen as well as send the legend info
    minimapUILoaded = true
    if (mapUILoaded) then
        CallRemoteEvent("PinmapRequestLegend")
    end
end
AddEvent("OnMinimapUILoaded", InitializeMinimapValues) --This event is called by the map.js after the page is loaded. If we try to execute the web js before the page is loaded, it's invalid behavior.


function PinmapRegisterLegendKey(id, displayText, iconPath)
    ExecuteWebJS(mapGui, "RegisterLegendKey('" .. id .. "', '" .. i18n(displayText) .. "', '" .. iconPath .. "');")
	ExecuteWebJS(miniMapGui, "RegisterLegendKey('" .. id .. "', '" .. i18n(displayText) .. "', '" .. iconPath .. "');")	
	ExecuteWebJS(mapGui, "UpdateText('" .. i18n("legend") .. "', '" .. i18n("set_destination") .. "', '" .. i18n("clear_destination") .. "');")
end
AddRemoteEvent("PinmapRegisterLegendKey", PinmapRegisterLegendKey)

function PinmapRegisterBlip(id, x, y)
    ExecuteWebJS(mapGui, "RegisterBlip('" .. id .. "', " .. x .. ", " .. y .. ");")
	ExecuteWebJS(miniMapGui, "RegisterBlip('" .. id .. "', " .. x .. ", " .. y .. ");")
end
AddRemoteEvent("PinmapRegisterBlip", PinmapRegisterBlip)

function PinmapShowKey(key)
    ExecuteWebJS(miniMapGui, "ShowKey('" .. key .. "');")
end
AddEvent("PinmapShowKey", PinmapShowKey)

function PinmapHideKey(key)
    ExecuteWebJS(miniMapGui, "HideKey('" .. key .. "');")
end
AddEvent("PinmapHideKey", PinmapHideKey)

function PinmapEnableDevmode()
	PinLog("Developer mode is enabled! This will allow players to teleport via the map feature. To turn off developer mode, please see the config.ini file in the Pinmap package!")
	devMode = true
	if (mapUILoaded) then
		ExecuteWebJS(mapGui, "EnableDevMode();") --When EnableDevMode() is called in the js, it adds the menu option for "Teleport Here" in the right click menu on the map
	end
end
AddRemoteEvent("PinmapEnableDevmode", PinmapEnableDevmode) --Server will send this event if dev mode is enabled in server config

local fixTeleportTimer = nil --There are inherent issues with LineTrace not being accurate if the collision check is not within render distance. Due to this, I had to rig up this system where it attempts to recalculate/reteleport until it finds an intersection with the actual ground.
local teleportX
local teleportY
function FixTeleport()
	_, _, _, _, teleportZ = LineTrace(teleportX, teleportY, 7000, teleportX, teleportY, 0) --attempt to trace line and get Z value for teleport target
	PinLog("Attempting to retrieve adjusted teleport coordinates: [" .. teleportX .. ", " .. teleportY .. ", " .. teleportZ .. "]")
	if (teleportZ ~= 0) then
		PinLog("Teleporting to fixed coordinates: [" .. teleportX .. ", " .. teleportY .. ", " .. teleportZ .. "]")
		teleportZ = teleportZ + 50 --Teleport above the ground so we don't fall through it 
		SetIgnoreMoveInput(false) --Allow player to move again since we supposedly found the correct teleport coordinates and requested it to server
		DestroyTimer(fixTeleportTimer) --Destroy timer since we don't need to keep checking after we found the correct coordinates
		fixTeleportTimer = nil --assign to nil for checking if timer exists in RequestTeleportToLocation()
		CallRemoteEvent("PinmapRequestTeleport", teleportX, teleportY, teleportZ) --send new teleport request to server
	end
end

function RequestTeleportToLocation(worldX, worldY)
	_, _, _, _, worldZ = LineTrace(worldX, worldY, 10000, worldX, worldY, 0)
	worldX = math.ceil(worldX)
	worldY = math.ceil(worldY)
	worldZ = math.ceil(worldZ) + 50 --Round everything up and try to teleport 50 units above the target coordinate that LineTrace calculated
	PinLog("Requesting teleport to: [" .. worldX .. ", " .. worldY .. ", " .. worldZ .. "]")
	if (worldZ == 50) then --If the z calculation failed... This can happen due to the intersection being out of render distance or LineTrace just failing - it has issues with certain surfaces
		SetIgnoreMoveInput(true) --Do not allow user to move while we try to fix the failed teleport
		teleportX = worldX --store the target x,y teleport coordinates, and we'll try to recalculate the z in FixTeleport()
		teleportY = worldY
		if (fixTeleportTimer == nil) then --if the fix teleport timer isn't active, lets create one to start attempting to recalculate/reteleport
			fixTeleportTimer = CreateTimer(FixTeleport, 100) --Create timer where the FixTeleport callback function is called approximately 10 times/sec (100ms)
		end
	else --If z calculation looks accurate (LineTrace didn't fail on us)
		if (fixTeleportTimer ~= nil) then --If a fix teleport timer exists/is running, let's clean that up
			DestroyTimer(fixTeleportTimer)
			fixTeleportTimer = nil --Assign to nil so that we can properly check if it is running or not in the future
		end
		SetIgnoreMoveInput(false) --Allow user to move again in case it was disabled
	end
	CallRemoteEvent("PinmapRequestTeleport", worldX, worldY, worldZ) --Request to server to teleport us to target location
end
AddEvent("RequestTeleportToLocation", RequestTeleportToLocation) --This event is called by the map.js file when you try to teleport from the UI

local isMapOpen = false
local timeMapClosed = GetTimeSeconds() --Store the last time map was closed
local zoomTimer = nil
local zoomScale = 1
local zoomFactor = 1
function ProcessZoom()
    zoomScale = zoomScale * zoomFactor
    if (zoomScale < 0.16) then
        zoomScale = 0.16;
    end
    if (zoomScale > 3) then
        zoomScale = 3
    end
    ExecuteWebJS(miniMapGui, "UpdateZoomScale(" .. zoomScale .. ");")
end

function OnKeyPress(key)
	if (key == "M") and not GetPlayerBusy() then
		dt = GetTimeSeconds() - timeMapClosed
		if (dt < 0.5) then --If the map was opened or closed in the last 0.5 seconds, ignore this. This is to try to prevent map from being automatically opened/closed again. This threshold could be reduced, but I felt like 0.5 was safe.
			return false
		end
		if (isMapOpen) then
			CloseMap()
		else
			isMapOpen = true
			UpdatePositionOnMap()
            SetWebVisibility(mapGui, WEB_VISIBLE)
			SetWebVisibility(miniMapGui, WEB_HIDDEN)
			SetInputMode(INPUT_GAMEANDUI)
			ShowMouseCursor(true)
		end
    end
    if (key == "Num +") then
        if (zoomTimer ~= nil) then
            DestroyTimer(zoomTimer)
        end
        zoomFactor = 1/0.94
        zoomTimer = CreateTimer(ProcessZoom, 20);
    end
    if (key == "Num -") then
        if (zoomTimer ~= nil) then
            DestroyTimer(zoomTimer)
        end
        zoomFactor = 0.94
        zoomTimer = CreateTimer(ProcessZoom, 20);
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnKeyRelease(key)
    if (key == "Num +" or key == "Num -") then
        if (zoomTimer ~= nil) then
            DestroyTimer(zoomTimer)
        end
    end
end
AddEvent("OnKeyRelease", OnKeyRelease)

local destinationWP = nil
function UpdateMapDestination(worldX, worldY)
	_, _, _, _, worldZ = LineTrace(worldX, worldY, 10000, worldX, worldY, 0)
	if (destinationWP ~= nil) then --If we have an existing waypoint, destroy it before creating this new one
		DestroyWaypoint(destinationWP)
	end
    destinationWP = CreateWaypoint(worldX, worldY, worldZ, "Destination")
    ExecuteWebJS(miniMapGui, "UpdateDestination(" .. worldX .. "," .. worldY .. ");")
end
AddEvent("UpdateMapDestination", UpdateMapDestination)

function ClearMapDestination()
    if (destinationWP ~= nil) then
        ExecuteWebJS(miniMapGui, "ClearDestination();")
		DestroyWaypoint(destinationWP)
		destinationWP = nil
	end
end
AddEvent("ClearMapDestination", ClearMapDestination)

function UpdatePositionOnMap()
	if (isMapOpen == true) then
		local x, y, z = GetPlayerLocation()
		heading = GetPlayerHeading() + 90
		if (heading < 0) then
			heading = heading + 360
		end
		jsString = "UpdatePlayerPosition(" .. x .. "," .. y .. "," .. z .. "," .. heading .. ");"
        ExecuteWebJS(mapGui, jsString)
    else
        local x, y, z = GetPlayerLocation()
        _, heading = GetCameraRotation()
        heading = heading + 90
		if (heading < 0) then
			heading = heading + 360
		end
		jsString = "UpdatePlayerPosition(" .. x .. "," .. y .. "," .. z .. "," .. heading .. ");"
        ExecuteWebJS(miniMapGui, jsString)
	end
end
CreateTimer(UpdatePositionOnMap, 10)

function CloseMap()
    SetWebVisibility(mapGui, WEB_HIDDEN)
	SetWebVisibility(miniMapGui, WEB_VISIBLE)
	SetInputMode(INPUT_GAME)
	timeMapClosed = GetTimeSeconds()
	isMapOpen = false
	ShowMouseCursor(false)
end
AddEvent("CloseMap", CloseMap)

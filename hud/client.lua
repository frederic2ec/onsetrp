
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local HungerFoodHud
local ThirstHud
local HealthHud
local VehicleSpeedHud
local VehicleFuelHud
local VehicleHealthHud
local SpeakingHud
local minimap

personalMenuIsOpen = 0

function OnPackageStart()
    HungerFoodHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(HungerFoodHud, 1.0, 0.0)
    SetWebAnchors(HungerFoodHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(HungerFoodHud, "http://asset/onsetrp/hud/hunger/hunger.html")
    SetWebVisibility(HungerFoodHud, WEB_HITINVISIBLE)

    ThirstHud = CreateWebUI(0, 0, 0, 0, 0, 28)
    SetWebAlignment(ThirstHud, 1.0, 0.0)
    SetWebAnchors(ThirstHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(ThirstHud, "http://asset/onsetrp/hud/thirst/thirst.html")
    SetWebVisibility(ThirstHud, WEB_HITINVISIBLE)

    HealthHud = CreateWebUI(0, 0, 0, 0, 0, 28)
	SetWebAlignment(HealthHud, 1.0, 0.0)
	SetWebAnchors(HealthHud, 0.0, 0.0, 1.0, 1.0) 
	LoadWebFile(HealthHud, "http://asset/onsetrp/hud/health/health.html")
    SetWebVisibility(HealthHud, WEB_HITINVISIBLE)
    
    VehicleSpeedHud = CreateTextBox(-15, 260, "Speed", "right" )
    SetTextBoxAnchors(VehicleSpeedHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(VehicleSpeedHud, 1.0, 0.0)
    
    VehicleHealthHud = CreateTextBox(-15, 280, "Health", "right" )
    SetTextBoxAnchors(VehicleHealthHud, 1.0, 0.0, 1.0, 0.0)
	SetTextBoxAlignment(VehicleHealthHud, 1.0, 0.0)

    VehicleFuelHud = CreateTextBox(-15, 300, "Fuel", "right" )
    SetTextBoxAnchors(VehicleFuelHud, 1.0, 0.0, 1.0, 0.0)
	SetTextBoxAlignment(VehicleFuelHud, 1.0, 0.0)

    SpeakingHud = CreateWebUI( 0, 0, 0, 0, 0, 48 )
    LoadWebFile( SpeakingHud, "http://asset/onsetrp/hud/speaking/hud.html" )
    SetWebAlignment( SpeakingHud, 0, 0 )
    SetWebAnchors( SpeakingHud, 0, 0, 1, 1 )
    SetWebVisibility( SpeakingHud, WEB_HITINVISIBLE )

    minimap = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebVisibility(minimap, WEB_HITINVISIBLE)
    SetWebAnchors(minimap, 0, 0, 1, 1)
    SetWebAlignment(minimap, 0, 0)
    SetWebURL(minimap, "http://asset/onsetrp/hud/minimap/minimap.html")
    
	ShowHealthHUD(false)
    ShowWeaponHUD(false)
end
AddEvent("OnPackageStart", OnPackageStart)

function updateHud(hunger, thirst, cash, bank, healthlife, vehiclefuel)    
    ExecuteWebJS(HealthHud, "SetHealth("..healthlife..", "..personalMenuIsOpen..");")
    ExecuteWebJS(ThirstHud, "SetThirst("..thirst..", "..personalMenuIsOpen..");")
    ExecuteWebJS(HungerFoodHud, "SetHunger("..hunger..", "..personalMenuIsOpen..");")

    if GetPlayerVehicle() ~= 0 then
        vehiclespeed = math.floor(GetVehicleForwardSpeed(GetPlayerVehicle()))
        vehiclehealth = math.floor(GetVehicleHealth(GetPlayerVehicle()))
        SetTextBoxText(VehicleSpeedHud, _("speed")..vehiclespeed.."KM/H")
        SetTextBoxText(VehicleHealthHud, _("vehicle_health")..vehiclehealth)
        SetTextBoxText(VehicleFuelHud, _("fuel")..vehiclefuel)
    else
        SetTextBoxText(VehicleSpeedHud, "")
        SetTextBoxText(VehicleFuelHud, "")
        SetTextBoxText(VehicleHealthHud, "")
    end
end
AddRemoteEvent("updateHud", updateHud)

AddEvent( "OnGameTick", function()
    --Speaking icon check
    local player = GetPlayerId()
    if IsPlayerTalking(player) then
        SetWebVisibility(SpeakingHud, WEB_HITINVISIBLE)
    else
        SetWebVisibility(SpeakingHud, WEB_HIDDEN)
    end
    --Minimap refresh
    local x, y, z = GetCameraRotation()
    local px,py,pz = GetPlayerLocation()
    ExecuteWebJS(minimap, "SetHUDHeading("..(360-y)..");")
    ExecuteWebJS(minimap, "SetMap("..px..","..py..","..y..");")
    -- Hud refresh
    CallRemoteEvent("getHudData")
end )

function SetHUDMarker(name, h, r, g, b)
    if h == nil then
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\");");
    else
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\", "..h..", "..r..", "..g..", "..b..");");
    end
end
AddRemoteEvent("SetHUDMarker", SetHUDMarker)

function hideRPHud()
    SetWebVisibility(HungerFoodHud, WEB_HIDDEN)
    SetWebVisibility(ThirstHud, WEB_HIDDEN)
    SetWebVisibility(HealthHud, WEB_HIDDEN)
    SetWebVisibility(VehicleSpeedHud, WEB_HIDDEN)
    SetWebVisibility(VehicleFuelHud, WEB_HIDDEN)
    SetWebVisibility(VehicleHealthHud, WEB_HIDDEN)
    SetWebVisibility(SpeakingHud, WEB_HIDDEN)
    SetWebVisibility(minimap, WEB_HIDDEN)
end

function showRPHud()
    SetWebVisibility(HungerFoodHud, WEB_HITINVISIBLE)
    SetWebVisibility(ThirstHud, WEB_HITINVISIBLE)
    SetWebVisibility(HealthHud, WEB_HITINVISIBLE)
    SetWebVisibility(VehicleSpeedHud, WEB_HITINVISIBLE)
    SetWebVisibility(VehicleFuelHud, WEB_HITINVISIBLE)
    SetWebVisibility(VehicleHealthHud, WEB_HITINVISIBLE)
    SetWebVisibility(SpeakingHud, WEB_HITINVISIBLE)
    SetWebVisibility(minimap, WEB_HITINVISIBLE)
end

AddFunctionExport("hideRPHud", hideRPHud)
AddFunctionExport("showRPHud", showRPHud)

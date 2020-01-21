
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local HungerFoodHud
local ThirstHud
local HealthHud
local VehicleHud
local SpeakingHud

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

    VehicleHud = CreateWebUI(0, 0, 0, 0, 0, 60)
	SetWebAlignment(VehicleHud, 1.0, 0.0)
	SetWebAnchors(VehicleHud, 0.0, 0.0, 1.0, 1.0) 
	LoadWebFile(VehicleHud, "http://asset/onsetrp/hud/vehicle/index.html")
    SetWebVisibility(VehicleHud, WEB_HIDDEN)

    SpeakingHud = CreateWebUI( 0, 0, 0, 0, 0, 48 )
    LoadWebFile( SpeakingHud, "http://asset/onsetrp/hud/speaking/hud.html" )
    SetWebAlignment( SpeakingHud, 0, 0 )
    SetWebAnchors( SpeakingHud, 0, 0, 1, 1 )
    SetWebVisibility( SpeakingHud, WEB_HITINVISIBLE )
    
	ShowHealthHUD(false)
    ShowWeaponHUD(false)
end
AddEvent("OnPackageStart", OnPackageStart)

function updateHud()
    local pHealth = GetPlayerHealth()
    local pHunger = GetPlayerPropertyValue(GetPlayerId(), "hunger")
    local pThirst = GetPlayerPropertyValue(GetPlayerId(), "thirst")
    if HealthHud ~= nil and pHealth ~= nil then ExecuteWebJS(HealthHud, "SetHealth("..pHealth..", "..personalMenuIsOpen..");") end -- Fix robustesse
    if ThirstHud ~= nil and pThirst ~= nil then ExecuteWebJS(ThirstHud, "SetThirst("..pThirst..", "..personalMenuIsOpen..");") end
    if HungerFoodHud ~= nil and pHunger ~= nil then ExecuteWebJS(HungerFoodHud, "SetHunger("..pHunger..", "..personalMenuIsOpen..");") end

    if GetPlayerVehicle() ~= 0 then
        local vehiclespeed = math.floor(GetVehicleForwardSpeed(GetPlayerVehicle()))
        local vehiclehealth = math.floor(GetVehicleHealth(GetPlayerVehicle()))
        local vehiclefuel = GetVehiclePropertyValue(GetPlayerVehicle(), "fuel")
        vehiclefuel = vehiclefuel or 100
        SetWebVisibility(VehicleHud, WEB_VISIBLE)
        ExecuteWebJS(VehicleHud, "SetVehicleFuel("..vehiclefuel..");")
        ExecuteWebJS(VehicleHud, "SetVehicleSpeed("..vehiclespeed..");")
        ExecuteWebJS(VehicleHud, "SetVehicleHealth("..vehiclehealth..");")
    else
        SetWebVisibility(VehicleHud, WEB_HIDDEN)
    end
end

CreateTimer(function()
    --Speaking icon check
    local player = GetPlayerId()
    if IsPlayerTalking(player) then
        SetWebVisibility(SpeakingHud, WEB_HITINVISIBLE)
    else
        SetWebVisibility(SpeakingHud, WEB_HIDDEN)
    end
    -- Hud refresh
    updateHud()
end, 100)

function hideRPHud()
    SetWebVisibility(HungerFoodHud, WEB_HIDDEN)
    SetWebVisibility(ThirstHud, WEB_HIDDEN)
    SetWebVisibility(HealthHud, WEB_HIDDEN)
    SetWebVisibility(SpeakingHud, WEB_HIDDEN)
end

function showRPHud()
    SetWebVisibility(HungerFoodHud, WEB_HITINVISIBLE)
    SetWebVisibility(ThirstHud, WEB_HITINVISIBLE)
    SetWebVisibility(HealthHud, WEB_HITINVISIBLE)
    SetWebVisibility(SpeakingHud, WEB_HITINVISIBLE)
end

AddFunctionExport("hideRPHud", hideRPHud)
AddFunctionExport("showRPHud", showRPHud)


local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local HungerHud
local ThirstHud
local CashHud
local BankHud
local VehicleSpeedHud
local VehicleFuelHud
local VehicleHealthHud
local SpeakingHud
local minimap

local timer = false

function OnPackageStart()
    HungerHud = CreateTextBox(-15, 180, "Hunger", "right" )
    SetTextBoxAnchors(HungerHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(HungerHud, 1.0, 0.0)
    
    ThirstHud = CreateTextBox(-15, 200, "Thirst", "right" )
    SetTextBoxAnchors(ThirstHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(ThirstHud, 1.0, 0.0)
    
    CashHud = CreateTextBox(-15, 220, "Cash", "right" )
    SetTextBoxAnchors(CashHud, 1.0, 0.0, 1.0, 0.0)
	SetTextBoxAlignment(CashHud, 1.0, 0.0)

    BankHud = CreateTextBox(-15, 240, "Bank", "right" )
    SetTextBoxAnchors(BankHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(BankHud, 1.0, 0.0)
    
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
    
	ShowHealthHUD(true)
    ShowWeaponHUD(true)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerSpawn(player)
    if not timer then
        timer = true
        CreateTimer(function()
            CallRemoteEvent("getHudData")
        end, 1000)
    end
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)

function updateHud(hunger, thirst, cash, bank, vehiclefuel)
    SetTextBoxText(HungerHud, _("hunger")..hunger.."%" )
    SetTextBoxText(ThirstHud, _("thirst")..thirst.."%" )
    SetTextBoxText(CashHud, _("cash")..cash.._("currency") )
    SetTextBoxText(BankHud, _("bank_balance")..bank.._("currency") )

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
end )

function SetHUDMarker(name, h, r, g, b)
    if h == nil then
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\");");
    else
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\", "..h..", "..r..", "..g..", "..b..");");
    end
end

AddRemoteEvent("SetHUDMarker", SetHUDMarker)

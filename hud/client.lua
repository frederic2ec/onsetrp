
local hud = 0
local timer = false

function OnPackageStart()
    local width, height = GetScreenSize()

	hud = CreateWebUI(0, 0, width, height)
	SetWebAlignment(hud, 0.0, 0.0)
	SetWebAnchors(hud, 0.0, 0.0, 0, 0)
	LoadWebFile(hud, "http://asset/"..GetPackageName().."/client/hud/hud.html")

	ShowHealthHUD(false)
    ShowWeaponHUD(true)
    
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
	DestroyWebUI(hud)
end
AddEvent("OnPackageStop", OnPackageStop)

function OnPlayerSpawn(player)
    if not timer then
        timer = true
        CreateTimer(function()
            CallRemoteEvent("getHudData")
        end, 1000)
    end
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)

function updateHud(health, armor, hunger, thirst)
    ExecuteWebJS(hud, "changeHealth("..health..")")
    ExecuteWebJS(hud, "changeArmor("..armor..")")
    ExecuteWebJS(hud, "changeHunger("..hunger..")")
    ExecuteWebJS(hud, "changeThirst("..thirst..")")
end
AddRemoteEvent("updateHud", updateHud)

-- Based on MasterCedric (https://github.com/MasterCedric/)

animationWheelUI = nil

function OnPackageStart()
	web = CreateWebUI(0, 0, 0, 0, 60)
	LoadWebFile(web, "http://asset/" .. GetPackageName() .. "/animation/web/index.html")
	SetWebSize(web, 700, 700)
	SetWebAlignment(web, 0.5, 0.5)
	SetWebAnchors(web, 0.5, 0.5, 0.5, 0.5)
	SetWebVisibility(web, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnKeyPress", function(key)
	if key == "G" and not IsPlayerInVehicle(GetPlayerId()) and not alreadyInteracting then
		if (GetWebVisibility(animationWheelUI) == 0) then
			local ScreenX, ScreenY = GetScreenSize()
			SetMouseLocation(math.floor(ScreenX / 2), math.floor(ScreenY / 2))
			SetWebVisibility(animationWheelUI, WEB_VISIBLE)
			ShowMouseCursor(true)
			SetInputMode(INPUT_GAMEANDUI)
		else
			SetWebVisibility(animationWheelUI, WEB_HIDDEN)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
		end

	elseif key == "E" and not IsPlayerInVehicle(GetPlayerId()) and not alreadyInteracting then
		CallRemoteEvent("PickupGun")		
	end
end)

function OnPlayerAnimation(id)
	SetWebVisibility(animationWheelUI, WEB_HIDDEN)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	CallRemoteEvent("Server_OnPlayerAnimation", id)
end
AddEvent("OnPlayerAnimation", OnPlayerAnimation)

AddEvent("drop", function(player)
	if not IsPlayerReloading(GetPlayerId()) then
		SetWebVisibility(animationWheelUI, WEB_HIDDEN)
		ShowMouseCursor(false)
		SetInputMode(INPUT_GAME)
		CallRemoteEvent("DropGun")
	else
		--can't do /prevent bug
	end	
end)

AddEvent("OnObjectStreamIn", function(object)
	if IsValidObject(object) and GetObjectPropertyValue(object, "collision") == false then
		GetObjectActor(object):SetActorEnableCollision(false)
	end
end)

AddRemoteEvent("GetClientObjects", function()
	CallRemoteEvent("ReturnedObjects", GetStreamedObjects(false))
	CallRemoteEvent("ReturnedObjects", GetStreamedObjects(false))
end)

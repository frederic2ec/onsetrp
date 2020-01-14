-- Based on MasterCedric (https://github.com/MasterCedric/)

animationWheelUI = nil

function OnPackageStart()
	animationWheelUI = CreateWebUI(0, 0, 0, 0, 10)
	LoadWebFile(animationWheelUI, "http://asset/" .. GetPackageName() .. "/animation/web/index.html")
	SetWebSize(animationWheelUI, 500, 500)
	SetWebAlignment(animationWheelUI, 0.5, 0.5)
	SetWebAnchors(animationWheelUI, 0.5, 0.5, 0.5, 0.5)
	SetWebVisibility(animationWheelUI, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnKeyPress", function(key)
	if key == "G" and not alreadyInteracting then
		if GetPlayerVehicle(GetPlayerId()) == 0 then
			if(GetWebVisibility(animationWheelUI) == 0) then
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
		else
			return CallRemoteEvent(player, "MakeNotification", _("cant_do_that"), "linear-gradient(to right, #ff5f6d, #ffc371)")
		end
	elseif key == "E" and not alreadyInteracting then
		if GetPlayerVehicle(GetPlayerId()) == 0 then
			CallRemoteEvent("PickupGun")
		else
			return CallRemoteEvent(player, "MakeNotification", _("cant_do_that"), "linear-gradient(to right, #ff5f6d, #ffc371)")
		end
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
	SetWebVisibility(animationWheelUI, WEB_HIDDEN)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	CallRemoteEvent("DropGun")
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

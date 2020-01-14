-- Based on MasterCedric (https://github.com/MasterCedric/)

animationWheelUI = nil

function OnPackageStart()
	animationWheelUI = CreateWebUI(0, 0, 0, 0, 10)
	LoadWebFile(animationWheelUI, "http://asset/" .. GetPackageName() .. "/animation/web/index.html")
	SetWebSize(animationWheelUI, 700, 700)
	SetWebAlignment(animationWheelUI, 0.5, 0.5)
	SetWebAnchors(animationWheelUI, 0.5, 0.5, 0.5, 0.5)
	SetWebVisibility(animationWheelUI, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnKeyPress", function(key)
	if key == "G" and not alreadyInteracting then
		if(GetWebVisibility(animationWheelUI) == 0) then
			SetWebVisibility(animationWheelUI, WEB_VISIBLE)
			ShowMouseCursor(true)
			SetInputMode(INPUT_GAMEANDUI)
			--alreadyInteracting = true   if set to true, can't close with key
		else
			SetWebVisibility(animationWheelUI, WEB_HIDDEN)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
			--alreadyInteracting = false
		end
	elseif key == "E" and not alreadyInteracting then
		CallRemoteEvent("PickupGun")	
	end
end)

function OnPlayerAnimation(id)
	SetWebVisibility(animationWheelUI, WEB_HIDDEN)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	CallRemoteEvent("Server_OnPlayerAnimation", id)
	--alreadyInteracting = false
end
AddEvent("OnPlayerAnimation", OnPlayerAnimation)

AddEvent("drop", function(player)
	SetWebVisibility(animationWheelUI, WEB_HIDDEN)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	CallRemoteEvent("DropGun")
	--alreadyInteracting = false
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

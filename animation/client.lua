-- Based on MasterCedric (https://github.com/MasterCedric/)

web = nil

function OnPackageStart()
	web = CreateWebUI(0, 0, 0, 0, 10)
	LoadWebFile(web, "http://asset/" .. GetPackageName() .. "/animation/web/index.html")
	SetWebSize(web, 700, 700)
	SetWebAlignment(web, 0.5, 0.5)
	SetWebAnchors(web, 0.5, 0.5, 0.5, 0.5)
	SetWebVisibility(web, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnKeyPress", function(key)
	if key == "G" and not alreadyInteracting then
		if(GetWebVisibility(web) == 0) then
			SetWebVisibility(web, WEB_VISIBLE)
			ShowMouseCursor(true)
			SetInputMode(INPUT_GAMEANDUI)
		else
			SetWebVisibility(web, WEB_HIDDEN)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
		end
	elseif key == "E" and not alreadyInteracting then
		CallRemoteEvent("PickupGun")	
	end
end)

function OnPlayerAnimation(id)
	SetWebVisibility(web, WEB_HIDDEN)
	ShowMouseCursor(false)
	SetInputMode(INPUT_GAME)
	CallRemoteEvent("Server_OnPlayerAnimation", id)
end
AddEvent("OnPlayerAnimation", OnPlayerAnimation)

AddEvent("drop", function(player)
	SetWebVisibility(web, WEB_HIDDEN)
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
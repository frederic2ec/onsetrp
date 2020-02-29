local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

function OnKeyPress(key)
    if key == INTERACT_KEY then
        player = GetPlayerId()
        if GetPlayerPropertyValue(player, "sit") then
            CallRemoteEvent("Unsit")
        elseif not IsPlayerInVehicle(player) then
            objects = GetStreamedObjects(false)
            CallRemoteEvent("FindObject", objects)
        else
            CallRemoteEvent(player, "MakeNotification",_("cant_do_that"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

AddRemoteEvent("siting", function(object)
    local actorYAdjustment = 90
    local playerId = player
    local objectId = object
    local modelid = GetObjectModel(objectId)
    local chairYAdjustment = 0
    local chairZAdjustment = 0  --Not all chairs are rotated properly by default, so you'll have to test for each chair model that you want to use and adjust y accordingly
    local ZAdjustment = 0
    local magniAd = 0   --Magnitude of vector for placing player (bigger = further away, smaller = closer)
    if (modelid == 952) then 
        chairYAdjustment = 180
    elseif (modelid == 728 or modelid == 729) then
        chairYAdjustment = 90
        magniAd = 20
    elseif (modelid == 1131 or modelid == 1132 or modelid == 1133 or modelid == 1134 or modelid == 1135 or modelid == 1136) then
        chairYAdjustment = -90
    elseif modelid == 1256 then
        chairYAdjustment = -90
        ZAdjustment = 30
    elseif modelid == 1228 or modelid == 1223 or modelid == 1127 or modelid == 1126 or modelid == 1095 then
        ZAdjustment = 30
    elseif modelid == 1181 then
        ZAdjustment = 60
    elseif modelid == 769 then
        magniAd = 60
        ZAdjustment = 20
    elseif modelid == 519 or modelid == 520 then
        magniAd = 20
    end
    local x, y, z = GetObjectLocation(objectId)
    local rX, rY, rZ = GetObjectRotation(objectId)
    local locationVector = FVector(x, y, z)
    local forwardVector = FVector(0, 1, 0)
    local rotator = FRotator(rX, rY + chairYAdjustment, rZ)
    forwardVector = rotator:RotateVector(forwardVector)
    local magnitude = magniAd + 30 --Magnitude of vector for placing player (bigger = further away, smaller = closer)
    forwardVector = forwardVector * FVector(magnitude, magnitude, magnitude)
    locationVector = locationVector + forwardVector
    locationVector.Z = locationVector.Z + ZAdjustment + 100

    local actor = GetPlayerActor(GetPlayerId())
    --actor:SetActorEnableCollision(false) --Disable player collision so that the player will not be pushed off the chair
    GetObjectStaticMeshComponent(objectId):SetCollisionEnabled(ECollisionEnabled.NoCollision)

    actor:SetActorLocation(locationVector)
    SetIgnoreMoveInput(true)
    actor:SetActorRotation(FRotator(rX, rY + actorYAdjustment + chairYAdjustment, rZ))
    if IsFirstPersonCamera() then
        SetControlRotation(rX, rY + actorYAdjustment + chairYAdjustment, rZ)
        SetControllerOrientedMovement(false)
    end
    Pstream = GetStreamedPlayers()
    condi = false
    CallRemoteEvent("ablecol", Pstream, objectId, condi)
end)

AddRemoteEvent("StockPos", function(x, y, z, object)
    if x ~= nil then
        xL = x
        yL = y
        zL = z
        cH = object
    else
        if IsFirstPersonCamera() then
            SetControllerOrientedMovement(true)
        end
        SetIgnoreMoveInput(false)
        GetObjectStaticMeshComponent(cH):SetCollisionEnabled(ECollisionEnabled.QueryAndPhysics)
        Pstream = GetStreamedPlayers()
        condi = true
        CallRemoteEvent("ablecol", Pstream, cH, condi, xL, yL, zL)
    end
end)

AddRemoteEvent("colforP", function(objet)
    GetObjectStaticMeshComponent(objet):SetCollisionEnabled(ECollisionEnabled.NoCollision)
end)

AddRemoteEvent("DcolforP", function(objet)   
    GetObjectStaticMeshComponent(objet):SetCollisionEnabled(ECollisionEnabled.QueryAndPhysics)
end)

AddEvent("OnObjectStreamIn", function(object)
	if IsValidObject(object) and GetObjectPropertyValue(object, "free") == false then
        GetObjectStaticMeshComponent(object):SetCollisionEnabled(ECollisionEnabled.NoCollision)
    elseif IsValidObject(object) and GetObjectPropertyValue(object, "collision") == false then
        GetObjectActor(object):SetActorEnableCollision(false)
	end
end)

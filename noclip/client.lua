local noclipping = false
local speed = 250
local pressing =
{
  F=false,
  B=false,
  L=false,
  R=false,
  U=false,
  below=false
}
local keys =
{
  F="Z",
  B="S",
  L="Q",
  R="D",
  U="Up", -- No spacebar please
  below="Left Shift",
  toggle="F8"
}

AddEvent("OnKeyPress", function(key)
  if key == keys['toggle'] then
    noclipping = not noclipping
    GetPlayerActor(GetPlayerId()):SetActorEnableCollision(not noclipping)
    CallRemoteEvent("Setnoclipserver", noclipping)
  end
  if noclipping then
    if key == keys['F'] then
      pressing['F'] = true
    elseif key == keys['B'] then
      pressing['B'] = true
    elseif key == keys['L'] then
      pressing['L'] = true
    elseif key == keys['R'] then
      pressing['R'] = true
    elseif key == keys['U'] then
      pressing['U'] = true
  elseif key == keys['below'] then
    pressing['below'] = true
  end
  end
end)

AddEvent("OnKeyRelease", function(key)
  if noclipping then
    if key == keys['F'] then
      pressing['F'] = false
    elseif key == keys['B'] then
        pressing['B'] = false
    elseif key == keys['L'] then
        pressing['L'] = false
    elseif key == keys['R'] then
        pressing['R'] = false
    elseif key == keys['U'] then
      pressing['U'] = false
  elseif key == keys['below'] then
    pressing['below'] = false
  end
  end
end)

AddRemoteEvent("Setnoclip", function(bool)
  noclipping = bool
  GetPlayerActor(GetPlayerId()):SetActorEnableCollision(not bool)
end)

AddEvent("OnGameTick", function(DeltaS)
  if noclipping then
    local fx, fy, fz = GetCameraForwardVector()
    local rx, ry, rz = GetCameraRightVector()
    local ux, uy, uz = GetCameraUpVector()
    local x, y, z = GetPlayerLocation()
    
    fx = fx*speed
    fy = fy*speed
    fz = fz*speed
    rx = rx*speed
    ry = ry*speed
    rz = rz*speed
    ux = ux*speed
    uy = uy*speed
    uz = uz*speed

    if pressing['F'] then
      CallRemoteEvent("tp_noc", x+fx, y+fy, z+fz)
    elseif pressing['B'] then
      CallRemoteEvent("tp_noc", x+fx*-1, y+fy*-1, z+fz*-1)
    elseif pressing['L'] then
      CallRemoteEvent("tp_noc", x+rx*-1, y+ry*-1, z+rz*-1)
    elseif pressing['R'] then
      CallRemoteEvent("tp_noc", x+rx, y+ry, z+rz)
    elseif pressing['U'] then
      CallRemoteEvent("tp_noc", x+ux, y+uy, z+uz)
  elseif pressing['below'] then
    CallRemoteEvent("tp_noc", x+ux*-1, y+uy*-1, z+uz*-1)
  end
  end
end)
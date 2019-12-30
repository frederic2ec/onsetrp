local noclipers = {}

function noclip(player)
if tonumber(PlayerData[player].admin) ~= 1 then return end
    if (noclipers[tostring(player)]==nil) then
        noclipers[tostring(player)] = true
   CallRemoteEvent(player, "Setnoclip" , true )
    else
        if (noclipers[tostring(player)]==true) then
            noclipers[tostring(player)] = false
            CallRemoteEvent(player, "Setnoclip" , false )
        else
            noclipers[tostring(player)] = true
             CallRemoteEvent(player, "Setnoclip" , true )
        end
    end
end

AddRemoteEvent("Setnoclipserver", function(player,bool)
if tonumber(PlayerData[player].admin) ~= 1 then return end
    noclipers[tostring(player)] = bool
  end)

AddCommand("noclip", noclip)

function tp_noc(player,x,y,z)
if tonumber(PlayerData[player].admin) ~= 1 then return end
    SetPlayerLocation(player, x, y, z)
end

AddRemoteEvent("tp_noc", tp_noc )
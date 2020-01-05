AddRemoteEvent("radio:getplayersinvehicle", function(player, radioStatus, volume, channel)
    local vehicle = GetPlayerVehicle(player) -- On récupère le véhicle
    local nbSeats = GetVehicleNumberOfSeats(vehicle) -- On récupère le nombre de places
    local passengers = {} -- On définie un array
    for i=1,nbSeats do 
        passengers[i] = GetVehiclePassenger(vehicle, i) -- Pour chaque place, on récupère le player qui l'occupe
    end
    
    if GetPlayerVehicleSeat(player) == 1 or GetPlayerVehicleSeat(player) == 2 then -- Si le joueur qui déclence est devant, la radio peut être allumée
        for k,v in pairs(passengers) do
            if v ~= 0 then
                if volume ~= nil then
                    print('set volume for '..v)
                    CallRemoteEvent(v, "radio:setvolume", vehicle, volume) 
                elseif channel ~= nil then
                    print('set station '..channel..' for '..v)
                    CallRemoteEvent(v, "radio:setchannel", vehicle, channel) 
                else
                    if radioStatus == 0 then
                        print('turnon radio for '..v)
                        CallRemoteEvent(v, "radio:turnonradio", vehicle) 
                    else
                        print('turnoff radio for '..v)
                        CallRemoteEvent(v, "radio:turnoffradio", vehicle) 
                    end
                end
                
            end
        end
        
    end
    
end)


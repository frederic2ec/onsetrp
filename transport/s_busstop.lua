local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local bus_stops = { 
    prop = { -- Arrêts de bus (id 1588)
        { x= 44159, y= 134743, z= 1467, ry= -3 }, --Vieille ville
        { x= -162727, y= 79044, z= 1434, ry= 183 }, --Prison
    },
    location = {
        { x= 43977, y= 134767, z= 1567, labelArret= _("old_town") }, --Vieille ville
        { x= -23335, y= -12534, z= 2081, labelArret= _("desert_town") }, --Ville du desert
        { x= -162541, y= 79023, z= 1545, labelArret= _("prison") }, --Ville du desert
        { x= -181984, y= -44583, z= 1149, labelArret= _("town") }, --Village        
        { x= -165259, y= -37945, z= 1149, labelArret= _("town").." 2" }, --Village        
        { x= 178654, y= 210121, z= 1314, labelArret= _("city").." 1" }, -- Ville
        { x= 210387, y= 194379, z= 1310, labelArret= _("city").." 2" }, -- Ville
        { x= 194706, y= 211555, z= 1310, labelArret= _("city").." 3" }, -- Ville
        { x= 196929, y= 200157, z= 1309, labelArret= _("city").." 4" }, -- Ville
        { x= 179352, y= 195067, z= 1310, labelArret= _("city").." 5" }, -- Ville
        { x= 182731, y= 198008, z= 1310, labelArret= _("city").." 6" }, -- Ville        
        { x= 157242, y= 210114, z= 1310, labelArret= _("city").." 7" }, -- Ville
        { x= 204877, y= 187104, z= 1312, labelArret= _("city").." 8" }, -- Ville
    },
    pickup = {}
}

local ticketPrice = 5
local kilometerPrice = 2

bus_stops_cached = {}

function CalculateAmount(distance) 
    if distance <= 4 then
        return 0
    end
    return (math.floor(distance / 1000) * kilometerPrice) + ticketPrice
end

AddEvent("OnPackageStart", function() -- Création des halos jaunes sur les arrêts de bus
    for i,j in pairs(bus_stops.location) do
        bus_stops.pickup[i] = CreatePickup(2 , bus_stops.location[i].x, bus_stops.location[i].y, bus_stops.location[i].z)
        CreateText3D( _("bus_stop").."\n".._("press_e"), 18, bus_stops.location[i].x, bus_stops.location[i].y, bus_stops.location[i].z + 120, 0, 0, 0)
        table.insert(bus_stops_cached, bus_stops.pickup[i])
    end    

    for i,j in pairs(bus_stops.prop) do -- Ajout des arrêts de bus qui ne sont pas présents de base
        CreateObject(1588, j.x, j.y, j.z, 0, j.ry)
    end    
end)

AddEvent("OnPlayerJoin", function(player) -- Mise en cache client
    CallRemoteEvent(player, "busStopSetup", bus_stops_cached)
end)

AddRemoteEvent("TransportMenuSGetListe", function(player) -- Récupération de la liste des arrêts de bus et envoie au menu
    transportMenuListe = {}
    local x,y = GetPlayerLocation(player)
    for k,v in pairs(bus_stops.location) do
        local distance = math.floor(tonumber(GetDistance2D(x, y, v.x, v.y)) / 100)
        transportMenuListe[k] = { label= v.labelArret, distance= distance, amount= CalculateAmount(distance)}
        if distance <= 4 then
            transportMenuListe[k].label = transportMenuListe[k].label.." ".._("transport_you_are_there")
        end
    end
    CallRemoteEvent(player, "TransportMenuCOpenMenu", transportMenuListe)
end)

AddRemoteEvent("TransportMenuSTeleportPlayer", function(player, arret) -- Téléport du joueur a l'arrêt de bus
    for k,v in pairs(bus_stops.location) do
        if k == tonumber(arret) then
            local x,y = GetPlayerLocation(player)
            local amount = CalculateAmount(math.floor(tonumber(GetDistance2D(x, y, v.x, v.y)) / 100))

            if GetPlayerCash(player) >= amount then                
                CallRemoteEvent(player, "TransportMenuCPresentToastSuccess")
                
                Delay(10000, function() -- Timer de 10s pour plus de RP
                    SetPlayerLocation(player, v.x, v.y, v.z + 200) -- pour éviter la chute sous le sol (marche pas tout le temps :( )
                    RemovePlayerCash(player, amount)
                end)                
            else
                CallRemoteEvent(player, "TransportMenuCPresentNotEnoughMoney")
            end
            return
        end
    end
end)

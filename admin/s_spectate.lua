local spectable = {}
local posbefspec = {}

function speclogic(cmdply, ply)
    for i, v in ipairs(spectable) do
        if v.id == cmdply then
            table.remove(spectable, i)
            SetPlayerLocation(cmdply, posbefspec[i].x, posbefspec[i].y, posbefspec[i].z)
            table.remove(posbefspec, i)
        end
    end
    local x, y, z = GetPlayerLocation(cmdply)
    tblspecin = {}
    tblspecin.id = cmdply
    tblspecin.specid = ply
    table.insert(spectable, tblspecin)
    tblinsert = {}
    tblinsert.x = x
    tblinsert.y = y
    tblinsert.z = z
    table.insert(posbefspec, tblinsert)
    local x, y, z = GetPlayerLocation(ply)
    CallRemoteEvent(cmdply, "SpecRemoteEvent", true, ply, x, y, z)
end

function AdminSpectatePlayer(cmdply, ply)
    if PlayerData[cmdply].admin ~= 1 then return end
    if cmdply == ply then return end

    if (ply ~= nil and ply ~= "" and ply ~= " ") then
        ply = tonumber(ply)
        if cmdply ~= ply then
            local hmhalreadyspec = false
            for i, v in ipairs(spectable) do
                if v.id == ply then
                    hmhalreadyspec = true
                end
            end
            if hmhalreadyspec == false then
                for i, v in ipairs(GetAllPlayers()) do
                    if v == ply then
                        speclogic(cmdply, ply)
                    end
                end
            end
        end
    end
end
AddRemoteEvent("admin:spectate", AdminSpectatePlayer)


AddEvent("OnPlayerQuit", function(ply)
    for i, v in ipairs(spectable) do
        if v.id == ply then
            table.remove(spectable, i)
            table.remove(posbefspec, i)
        end
    end
end)

AddRemoteEvent("NoLongerSpectating", function(ply)
    for i, v in ipairs(spectable) do
        if v.id == ply then
            table.remove(spectable, i)
            SetPlayerLocation(ply, posbefspec[i].x, posbefspec[i].y, posbefspec[i].z)
            table.remove(posbefspec, i)
        end
    end
end)

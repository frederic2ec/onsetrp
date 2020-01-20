local robberyPosition
local alarm
local timerAlarm

function robberySetup(x, y, z)
    robberyPosition = { x, y, z }
end
AddRemoteEvent("robberySetup", robberySetup)

function OnKeyPress(key)
    if key == "E" and not GetPlayerBusy() then
        local x, y, z = GetPlayerLocation()
        local dist = GetDistance3D(x, y, z, robberyPosition[1], robberyPosition[2], robberyPosition[3])

        if dist < 200.0 then
            CallRemoteEvent("RobberyAction")            
        end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function SoundAlarm()
    timerAlarm = CreateTimer(function()
        if alarm ~= nil then DestroySound(alarm) end
        alarm = CreateSound3D("client/files/bankAlarm.mp3", robberyPosition[1], robberyPosition[2], robberyPosition[3], 7000)
    end, 10000)    
end
AddRemoteEvent("RobberySoundAlarm", SoundAlarm)

function StopAlarm()
    if alarm ~= nil then 
        DestroySound(alarm) 
        DestroyTimer(timerAlarm)       
        timerAlarm = nil 
        alarm = nil
    end
end
AddRemoteEvent("RobberyStopAlarm", StopAlarm)



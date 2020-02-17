sr = ImportPackage("soundstreamer")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local vehicleRadioUi

AddEvent("OnPackageStart", function()
    vehicleRadioUi = CreateWebUI(0, 0, 0, 0, 0, 60)
    SetWebAlignment(vehicleRadioUi, 1.0, 0.0)
    SetWebAnchors(vehicleRadioUi, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(vehicleRadioUi, "http://asset/onsetrp/vehicle_radio/ui/radio.html")
    SetWebVisibility(vehicleRadioUi, WEB_HIDDEN)
end)


AddEvent("OnKeyPress", function(key)
    if IsPlayerInVehicle() then
        if key == VEHICLE_RADIO_KEY and IsCtrlPressed() then
            CallRemoteEvent("vehicle:radio:toggle")
        end
        if key == VEHICLE_RADIO_INCREASE_KEY then
            CallRemoteEvent("vehicle:radio:updatevolume", 1)
        end
        if key == VEHICLE_RADIO_LOWER_KEY then
            CallRemoteEvent("vehicle:radio:updatevolume", 2)
        end
        if key == "Num 1" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 1) end
        if key == "Num 2" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 2) end
        if key == "Num 3" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 3) end
        if key == "Num 4" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 4) end
        if key == "Num 5" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 5) end
        if key == "Num 6" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 6) end
        if key == "Num 7" and IsCtrlPressed then CallRemoteEvent("vehicle:radio:updatechannel", 7) end
    end
end)

AddEvent("OnSoundUpdateMeta", function(sound, meta)
    if IsPlayerInVehicle() then
        UpdatePlaying(meta)     
    end
end)

AddRemoteEvent("vehicle:radio:toggleui", function(state)    
    if state == true then
        SetWebVisibility(vehicleRadioUi, WEB_VISIBLE)
        SetInputMode(INPUT_GAME)
    else
        SetWebVisibility(vehicleRadioUi, WEB_HIDDEN)
        SetInputMode(INPUT_GAME)
    end
end)

function UpdateRadio(radio, volume)
    volume = math.floor( volume * 100 )    
    ExecuteWebJS(vehicleRadioUi, "UpdateRadio('" .. tostring(radio) .. "', " .. tostring(volume) .. ");")
end
AddRemoteEvent("vehicle:radio:updateui", UpdateRadio)

function UpdatePlaying(playing)
    ExecuteWebJS(vehicleRadioUi, "UpdateNowPlaying('" .. playing .. "');")
end

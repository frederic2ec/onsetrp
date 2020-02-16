sr = ImportPackage("soundstreamer")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end



AddEvent("OnKeyPress", function(key)
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
end)

local Dialog = ImportPackage("dialogui")
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local wpObject
local currentCallout

local calloutsMenu

AddEvent("OnTranslationReady", function()
    -- CALLOUTS MENU
    calloutsMenu = Dialog.create(_("callout_menu"), nil, _("callout_take"), _("cancel"))
    Dialog.addSelect(calloutsMenu, 1, _("callouts"), 8)
end)

function OpeningCalloutMenu() 
    CallRemoteEvent("callouts:getlist")    
end
AddEvent("callouts:openingmenu", OpeningCalloutMenu)
AddRemoteEvent("callouts:openingmenu", OpeningCalloutMenu)

AddRemoteEvent("callouts:displaymenu", function(callouts)
    Dialog.setSelectLabeledOptions(calloutsMenu, 1, 1, callouts)
    Dialog.show(calloutsMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == calloutsMenu then
        if button == 1 then
            if args[1] == "" then
                MakeErrorNotification(_("callout_please_choose_callout"))
                return
            end
            CallRemoteEvent("callouts:start", args[1])            
        end
    end
end)

function StopCurrentCallout()
    CallRemoteEvent("callouts:end", currentCallout)
end
AddEvent("callouts:stoppingcallout", StopCurrentCallout)

function CreateCallout(service, reason)
    CallRemoteEvent("callouts:create", service, reason)
end
AddEvent("callouts:new", CreateCallout)


AddRemoteEvent("callouts:createwp", function(target, x, y, z, label)
    if wpObject ~= nil then DestroyWaypoint(wpObject) end
    currentCallout = target
    wpObject = CreateWaypoint(x, y, z, tostring(label))
end)

AddRemoteEvent("callouts:cleanwp", function()
    currentCallout = nil
    if wpObject ~= nil then DestroyWaypoint(wpObject) end
    wpObject = nil
end)
local NotificationHud

AddEvent("OnPackageStart", function()
    NotificationHud = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebAlignment(NotificationHud, 0.0, 0.0)
    SetWebAnchors(NotificationHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(NotificationHud, "http://asset/onsetrp/notification/notification/notification.html")
    SetWebVisibility(NotificationHud, WEB_HITINVISIBLE)

    --[[ CreateTimer(function()
        MakeNotification("test", "linear-gradient(to right, #00b09b, #96c93d)")
    end, 1000) ]]
    
end)

function MakeNotification(text, color, duration)
    if duration == nil then duration = 3000 end
    ExecuteWebJS(NotificationHud, 'makeNotification("' ..text.. '", "' ..color.. '", '..duration..')')
    PlayAudioFile("notification.mp3")
end
AddRemoteEvent("MakeNotification", MakeNotification)

function MakeSuccessNotification(text)
    ExecuteWebJS(NotificationHud, 'makeNotification("' ..text.. '", "linear-gradient(to right, #00b09b, #96c93d)")')
    PlayAudioFile("notification.mp3")
end
AddRemoteEvent("MakeSuccessNotification", MakeSuccessNotification)

function MakeErrorNotification(text, duration)
    if duration == nil then duration = 3000 end
    ExecuteWebJS(NotificationHud, 'makeNotification("' ..text.. '", "linear-gradient(to right, #ff5f6d, #ffc371)", '..duration..')')
    PlayAudioFile("notification.mp3")
end
AddRemoteEvent("MakeErrorNotification", MakeErrorNotification)


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

function MakeNotification(text, color)
    ExecuteWebJS(NotificationHud, 'makeNotification("' ..text.. '", "' ..color.. '")')
    PlayAudioFile("notification.mp3")
end
AddRemoteEvent("MakeNotification", MakeNotification)


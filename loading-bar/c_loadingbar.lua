local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local LoadingBarHUD

AddEvent("OnPackageStart", function()
    LoadingBarHUD = CreateWebUI(0, 0, 0, 0, 0, 60)
    SetWebAlignment(LoadingBarHUD, 1.0, 0.0)
    SetWebAnchors(LoadingBarHUD, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(LoadingBarHUD, "http://asset/onsetrp/loading-bar/files/loading-bar.html")
    SetWebVisibility(LoadingBarHUD, WEB_HITINVISIBLE)
end)

AddRemoteEvent("loadingbar:show", function(activity, timer)
    ExecuteWebJS(LoadingBarHUD, "CreateLoading('"..activity.."', "..timer..");")
end)

AddRemoteEvent("loadingbar:hide", function()
    ExecuteWebJS(LoadingBarHUD, "HideLoading();")
end)
local Dialog = ImportPackage("dialogui")
local _ = _ or function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local previousInputMode

local webIdCard = CreateWebUI(0, 0, 0, 0, 2, 16)
SetWebVisibility(webIdCard, WEB_HIDDEN)
SetWebAlignment(webIdCard, 0, 0)
SetWebAnchors(webIdCard, 0, 0, 1, 1)
SetWebURL(webIdCard, "http://asset/onsetrp/idcard/id.html")

local idCardMenu

AddEvent("OnKeyPress", function(key)
    if key == "F1" then
        Dialog.show(idCardMenu)
    end
end)

-- DIALOGS

AddEvent("OnTranslationReady", function()
    idCardMenu = Dialog.create(_("id_card_menu"), nil, _("see_id_card"), _("show_id_card") ,_("cancel"))
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == idCardMenu then
        if button == 1 then
            CallRemoteEvent("SeeIdCard")
        end
        if button == 2 then
            CallRemoteEvent("ShowIdCard")
        end
    end
end)

-- LOADING

AddRemoteEvent("OnCardDataLoaded", function(id, name)
    print("OnCardDataLoaded")
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(webIdCard, WEB_VISIBLE)
    -- Coming soon: job and jobTitle
    -- ExecuteWebJS(web, 'LoadCardFromData('..json_encode({ name = name, age = "32", job = company, jobTitle = job, issued = "23/12/2019" })..');')
    ExecuteWebJS(webIdCard, 'LoadCardFromData('..json_encode({ id = id, name = name, age = "32", issued = "23/12/2019" })..');')
end)

AddRemoteEvent("ConfirmIdCardShow", function(shownTo)
    MakeNotification(_("id_card_shown", shownTo), "linear-gradient(to right, #ff5f6d, #ffc371)")
end)

AddEvent("HideIdCard", function()
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(webIdCard, WEB_HIDDEN)
end)

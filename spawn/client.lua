local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local spawnMenu

local spawnAsked = false
onSpawn = false

AddEvent("OnKeyPress", function(key)
    if onSpawn then
        Dialog.show(spawnMenu)
    end
end)

AddEvent("OnTranslationReady", function()
    spawnMenu = Dialog.create(_("spawn_menu"), nil, _("spawn"))
    Dialog.addSelect(spawnMenu, 1, _("place"), 8)
end)

AddRemoteEvent("AskSpawnMenu", function()
    spawnAsked = true
end)

AddEvent("OnPlayerSpawn", function( playerid )
    if spawnAsked then
        CallRemoteEvent("ServerSpawnMenu")
    end
end)

AddEvent("OnDialogUIReady", function()
    if spawnAsked then
        CallRemoteEvent("ServerSpawnMenu")
    end
end)

AddRemoteEvent("OpenSpawnMenu", function(spawnList, house)
    local spawns = {}
    for k,v in pairs(spawnList) do
        spawns[k] = _(k)
    end
    if house then
        spawns["house"] = _("house")
    end
    Dialog.setSelectLabeledOptions(spawnMenu, 1, 1, spawns) 
    onSpawn = true
    CallRemoteEvent("account:setplayerbusy", GetPlayerId())
    Dialog.show(spawnMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
	local args = { ... }
	if dialog == spawnMenu then
		if button == 1 then
			if args[1] == "" then
                MakeNotification(_("select_city"), "linear-gradient(to right, #ff5f6d, #ffc371)")
                CallRemoteEvent("ServerSpawnMenu")
            else
                onSpawn = false
                CallRemoteEvent("account:setplayernotbusy", GetPlayerId())
                CallRemoteEvent("PlayerSpawn", args[1])
			end
		end
    end
end)


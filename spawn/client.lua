local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local spawnMenu
local spawns = {}

local spawnAsked = false

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

AddRemoteEvent("OpenSpawnMenu", function(spawnList)
    for k,v in pairs(spawnList) do
        spawns[k] = _(k)
    end
    Dialog.setSelectLabeledOptions(spawnMenu, 1, 1, spawns) 
    Dialog.show(spawnMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
	local args = { ... }
	if dialog == spawnMenu then
		if button == 1 then
			if args[1] == "" then
                AddPlayerChat(_("select_city"))
                allRemoteEvent("ServerSpawnMenu")
            else
                CallRemoteEvent("PlayerSpawn", args[1])
			end
		end
    end
end)


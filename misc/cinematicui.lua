local CUI = ImportPackage("cinematicui")
local _ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

function startCinematic(data, npc, animation)
    hideRPHud()
    CUI.startCinematic(data, npc, animation)
end

function updateCinematic(data, npc, animation)
    CUI.updateCinematic(data, npc, animation)
end

function stopCinematic()
    showRPHud()
    CUI.stopCinematic()
end

AddEvent("CUIGoodbye", function()
	updateCinematic({
		message = _("npc_end_stop")
	})
	Delay(1500, function()
		stopCinematic()
    end)
end)
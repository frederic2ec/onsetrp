local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local personalMenu

AddEvent("OnTranslationReady", function()
    personalMenu = Dialog.create(_("personal_menu"), _("bank_balance").." : {bank} ".._("currency").." | ".._("cash").." : {cash} ".._("currency"), _("transfer") ,_("use"), _("cancel"))
    Dialog.addSelect(personalMenu, 1, _("inventory"), 5)
    Dialog.addTextInput(personalMenu, 1, _("quantity"))
    Dialog.addSelect(personalMenu, 1, _("player"), 3)
end)


AddRemoteEvent("OpenPersonalMenu", function(cash, bank, inventory, playerList)
    Dialog.setVariable(personalMenu, "cash", cash)
    Dialog.setVariable(personalMenu, "bank", bank)
    local items = {}
	for k,v in pairs(inventory) do
		items[k] = _(k).."["..v.."]"
    end
    Dialog.setSelectLabeledOptions(personalMenu, 1, 1, items)
    Dialog.setSelectLabeledOptions(personalMenu, 1, 3, playerList)
    Dialog.show(personalMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
	local args = { ... }
    if dialog == personalMenu then
        if button == 1 then
            if args[1] == "" then
				AddPlayerChat(_("select_item"))
			else
				if args[2] == "" then
					AddPlayerChat(_("select_amount"))
                else
                    if args[3] == "" then
                        AddPlayerChat(_("select_player"))
                    else
                        CallRemoteEvent("TransferInventory", args[1], args[2], args[3])
                    end   
				end
			end
        end
		if button == 2 then
			if args[1] == "" then
				AddPlayerChat(_("select_item"))
			else
				if args[2] == "" then
					AddPlayerChat(_("select_amount"))
				else
                    CallRemoteEvent("UseInventory", args[1], args[2])
				end
			end
		end
    end
end)


AddEvent("OnKeyPress", function( key )
    if key == "F4" then
        CallRemoteEvent("ServerPersonalMenu")
    end
end)


local Dialog = ImportPackage("dialogui")
local _ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local atm
local isAtm
local AtmIds = { }

AddEvent("OnTranslationReady", function()
    atm = Dialog.create(_("atm"), _("bank_balance").." : {bank_balance} ".._("currency").." | ".._("cash").." : {cash_balance} ".._("currency"), _("transfer"),_("withdraw"), _("deposit"), _("cancel"))
    Dialog.addTextInput(atm, 1, _("amount").." :")
    Dialog.addSelect(atm, 1, _("player"), 3)
    Dialog.setVariable(atm, "bank_balance", 0)
    Dialog.setVariable(atm, "cash_balance", 0) 
end)

AddEvent("OnKeyPress", function(key)
    if key == "E" then
        local NearestATM = GetNearestATM()
		if NearestATM ~= 0 then
            CallRemoteEvent("atmInteract", NearestATM)
		end
	end
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == atm then
        local args = { ... }
        if button == 1 then
            if args[1] ~= "" then
                if tonumber(args[1]) > 0 then
                    CallRemoteEvent("transferAtm", args[1], args[2])
                else
                    AddPlayerChat(_("enter_higher_number"))
                end
            else
                AddPlayerChat(_("valid_number"))
            end 
        end
        if button == 2 then
            withdrawMoney(args[1])
        end
        if button == 3 then
            depositMoney(args[1])
        end
    end
end)

AddRemoteEvent("atmSetup", function(AtmObjects)
	AtmIds = AtmObjects
end)

function GetNearestATM()
	local x, y, z = GetPlayerLocation()

	for k,v in pairs(GetStreamedObjects()) do
		local x2, y2, z2 = GetObjectLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 180.0 then
            for k,i in pairs(AtmIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function tablefind(tab, el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end

function withdrawMoney(amount)
    if amount ~= "" then
        if tonumber(amount) > 0 then
            CallRemoteEvent("withdrawAtm", amount)
        else
            AddPlayerChat(_("enter_higher_number"))
        end
    else
        AddPlayerChat(_("valid_number"))
    end 
end
AddEvent("withdrawMoney", withdrawMoney)

function depositMoney(amount)
    if amount ~= "" then
        if tonumber(amount) > 0 then
            CallRemoteEvent("depositAtm", amount)
        else
            AddPlayerChat(_("enter_higher_number"))
        end
    else
        AddPlayerChat(_("valid_number"))
    end 
end
AddEvent("depositMoney", depositMoney)

function openAtm(bank, cash, playerNames)
    Dialog.setVariable(atm, "bank_balance", bank)
    Dialog.setVariable(atm, "cash_balance", cash)
    Dialog.setSelectLabeledOptions(atm, 1, 2, playerNames)
    Dialog.show(atm)
end
AddRemoteEvent("openAtm", openAtm)

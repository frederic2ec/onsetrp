local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local house
local houseMenu

AddEvent("OnTranslationReady", function()
	houseMenu = Dialog.create(_("house_menu"), _("price").." {price}".._("currency"), _("buy"),  _("cancel"))
end)

AddRemoteEvent("OpenHouseMenu", function(houseid, price)
    house = houseid
    Dialog.setVariable(houseMenu, "price", price)
    Dialog.show(houseMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == houseMenu then
        if button == 1 then
            CallRemoteEvent("BuyHouse", house)        
        end
    end
end)



local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

Licenses = {
    driver_license = 1500,
    gun_license = 6000
}
-- LicensesNpcLocation = { x = 183339, y = 182525, z = 1291, h = 0 }
LicensesNpcLocation = { x = 211564, y = 175848, z = 1307, h = 180 }
LicensesNpc = {}

AddEvent("OnPackageStart", function()
    LicensesNpc = CreateNPC(LicensesNpcLocation.x, LicensesNpcLocation.y, LicensesNpcLocation.z, LicensesNpcLocation.h)
    CreateText3D("LICENSES\n".._("press_e"), 18, LicensesNpcLocation.x, LicensesNpcLocation.y, LicensesNpcLocation.z + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "LicenseSetup", LicensesNpc)
end)

AddRemoteEvent("LicenseInteract", function(player)
    CallRemoteEvent(player, "OpenLicenses", Licenses)
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)
local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

-------------------------------------------------------
----------- CONFIG FILE FOR KEYS SHORTCUTS ------------
-------------------------------------------------------
INTERACT_KEY = "E" -- To interact with something
PHONE_OPEN_KEY = "K" -- To open the phone
PHONE_CLOSE_KEY = "Escape" -- To close the phone
HOUSING_MENU_KEY = "F1" -- To show the housing menu
ID_CARD_MENU_KEY = "F2" -- To show the ID CARD menu
JOB_MENU_KEY = "F3" -- To show the job menu
INVENTORY_KEY = "I" -- To show the inventory
SHORTCUT_VIEWER_KEY = "F8" -- To display the shortcuts
ANIMATION_MENU_KEY = "G" -- To open the animation wheel
MAP_OPEN_KEY = "M" -- To open the big map
MAP_ZOOMIN_KEY = "Page Up" -- To zoom in the map
MAP_ZOOMOUT_KEY = "Page Down" -- To zoom out in the map
FPS_KEY = "V" -- To toggle FPS mode
VEHICLE_LOCK_KEY = "U" -- To lock the vehicle
VEHICLE_MENU_KEY = "F1" -- To open the vehicle menu
VEHICLE_ENGINE_KEY = "X" -- To toggle vehicle engine
VEHICLE_TRUNK_KEY = "O" -- To open the vehicle trunk
VEHICLE_HOOD_KEY = "P" -- To open the vehicle hood
ADMIN_MENU_KEY = "N" -- To show the admin menu
TOGGLE_CHAT_KEY = "Num /" -- To toggle the chat
VEHICLE_RADIO_KEY = "R" -- To toggle radio (ctrl)
VEHICLE_RADIO_LOWER_KEY = "Num -" -- To lower radio (ctrl)
VEHICLE_RADIO_INCREASE_KEY = "Num +" -- To increase radio (ctrl)

function GetAllKeybinds()
    return {
        {label = _("INTERACT_KEY"), key = INTERACT_KEY},
        {label = _("PHONE_OPEN_KEY"), key = PHONE_OPEN_KEY},
        {label = _("PHONE_CLOSE_KEY"), key = PHONE_CLOSE_KEY},
        {label = _("HOUSING_MENU_KEY"), key = HOUSING_MENU_KEY},
        {label = _("ID_CARD_MENU_KEY"), key = ID_CARD_MENU_KEY},
        {label = _("JOB_MENU_KEY"), key = JOB_MENU_KEY},
        {label = _("INVENTORY_KEY"), key = INVENTORY_KEY},
        {label = _("SHORTCUT_VIEWER_KEY"), key = SHORTCUT_VIEWER_KEY},
        {label = _("ANIMATION_MENU_KEY"), key = ANIMATION_MENU_KEY},
        {label = _("MAP_OPEN_KEY"), key = MAP_OPEN_KEY},
        {label = _("MAP_ZOOMIN_KEY"), key = MAP_ZOOMIN_KEY},
        {label = _("MAP_ZOOMOUT_KEY"), key = MAP_ZOOMOUT_KEY},
        {label = _("FPS_KEY"), key = FPS_KEY},
        {label = _("VEHICLE_LOCK_KEY"), key = VEHICLE_LOCK_KEY},
        {label = _("VEHICLE_MENU_KEY"), key = VEHICLE_MENU_KEY},
        {label = _("VEHICLE_ENGINE_KEY"), key = VEHICLE_ENGINE_KEY},
        {label = _("VEHICLE_TRUNK_KEY"), key = VEHICLE_TRUNK_KEY},
        {label = _("VEHICLE_HOOD_KEY"), key = VEHICLE_HOOD_KEY},
        {label = _("ADMIN_MENU_KEY"), key = ADMIN_MENU_KEY},
        {label = _("ADMIN_MENU_KEY"), key = ADMIN_MENU_KEY},
    }
end


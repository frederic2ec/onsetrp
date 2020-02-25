local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local minutes = 20

local MINIMUM_WAGE = 50
local JOB_WAGE = 100
local POLICE_WAGE = 200
local MEDIC_WAGE = 500

CreateTimer(function()
    for key, player in pairs(GetAllPlayers()) do
        if PlayerData[player] then 

            -- THOSE HAS TO BE ORDER BY WAGE AMOUNT (desc)
            if PlayerData[player].job == "medic" then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + MEDIC_WAGE
            elseif PlayerData[player].job == "police" then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + POLICE_WAGE
            elseif PlayerData[player].job ~= nil then
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + JOB_WAGE
            else
                PlayerData[player].bank_balance = PlayerData[player].bank_balance + MINIMUM_WAGE
            end
    
            CallRemoteEvent(player, "MakeSuccessNotification", _("salary_notification", _("price_in_currency", tostring(salary))))
        end
	end
end, minutes * 60000)

--Code from FinnCoding https://github.com/FinnCoding/OnsetRagdoll
function OnTazerShot(player, weapon, hittype, hitid, hitx, hity, hitz, startx, starty, startz, normalx, normaly, normalz)
    if (hittype == HIT_PLAYER) then
        if (weapon == 21) then -- 21 is the weapon ID for the tazer
            SetPlayerRagdoll(hitid, true)-- Makes player ragdoll
            Delay(6000, function()-- Waits 6 seconds before the player can stand up again
                SetPlayerRagdoll(hitid, false)-- Disables the ragdoll so he can walk again.
                SetPlayerAnimation(hitid, "PUSHUP_END")
                Delay(2000, function()
                    CallEvent("police:refreshcuff", hitid)
                end)
            end)
        end
    end
end
AddEvent("OnPlayerWeaponShot", OnTazerShot)

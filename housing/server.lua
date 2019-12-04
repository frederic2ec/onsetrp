local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

houses = {
    {
        id = 1,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-170925.921875, -33268.609375, 1229.1983642578, 0},
        text = {-171000.421875, -33466.25, 1227.6971435547},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -171043,
                y = -33401,
                z = 1131,
                r = 90
            },
            {
                entity = -1,
                model = 23,
                x = -171090,
                y = -33189,
                z = 1130,
                r = 0
            },
            {
                entity = -1,
                model = 41,
                x = -172818,
                y = -33414,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 2,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-174669.234375, -36615.8203125, 1227.7788085938, 0},
        text = {-174832.296875, -36621.96484375, 1227.1726074219},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -174799,
                y = -36578,
                z = 1129,
                r = 0
            },
            {
                entity = -1,
                model = 23,
                x = -174097,
                y = -37446,
                z = 1129,
                r = 0
            },
            {
                entity = -1,
                model = 23,
                x = -174380,
                y = -36595,
                z = 1468,
                r = 0
            },
            {
                entity = -1,
                model = 23,
                x = -174139,
                y = -37072,
                z = 1467,
                r = 90
            },
            {
                entity = -1,
                model = 41,
                x = -174589,
                y = -38487,
                z = 1025,
                r = -90
            }
        }
    },
    {
        id = 3,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-177951.015625, -36964.82421875, 1236.9774169922, 0},
        text = {-177775.0625, -36968.03515625, 1232.1761474609},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -177823,
                y = -37014,
                z = 1139,
                r = 180
            },
            {
                entity = -1,
                model = 23,
                x = -178293,
                y = -36769,
                z = 1139,
                r = 90
            },
            {
                entity = -1,
                model = 41,
                x = -177836,
                y = -38578,
                z = 1025,
                r = 90
            }
        }
    },
    {
        id = 4,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-177982.640625, -41709.20703125, 1235.4838867188, 0},
        text = {-177808.453125, -41703.95703125, 1227.4689941406},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -177842,
                y = -41749,
                z = 1137,
                r = 180
            },
            {
                entity = -1,
                model = 23,
                x = -178502,
                y = -41690,
                z = 1137,
                r = 90
            }
        }
    },
    {
        id = 5,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-174131.640625, -41843.55859375, 1227.8481445313, 0},
        text = {-174132.265625, -42024.71484375, 1227.0222167969},
        doors = {
            {
                entity = -1,
                model = 21,
                x = -174179,
                y = -41970,
                z = 1129,
                r = 90
            },
            {
                entity = -1,
                model = 41,
                x = -172828,
                y = -41752,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 6,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-169924.265625, -45905.42578125, 1240.1983642578, 0},
        text = {-169766.84375, -45728.04296875, 1237.1525878906},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -169720,
                y = -45762,
                z = 1141,
                r = 270
            },
            {
                entity = -1,
                model = 22,
                x = -170169,
                y = -46594,
                z = 1141,
                r = 90
            },
            {
                entity = -1,
                model = 24,
                x = -169674,
                y = -45973,
                z = 1142,
                r = 180
            }
        }
    },
    {
        id = 7,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-174477.25, -46827.19921875, 1247.6391601563, 0},
        text = {-174619.734375, -46827.60546875, 1237.1765136719},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -174585,
                y = -46782,
                z = 1150,
                r = 0
            },
            {
                entity = -1,
                model = 41,
                x = -174588,
                y = -45277,
                z = 1025,
                r = -90
            }
        }
    },
    {
        id = 8,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-177772.359375, -45908.84765625, 1239.1857910156, 0},
        text = {-177765.703125, -45769.59375, 1232.1630859375},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -177721,
                y = -45803,
                z = 1140,
                r = -90
            },
            {
                entity = -1,
                model = 23,
                x = -177673,
                y = -46192,
                z = 1140,
                r = 180
            }
        }
    },
    {
        id = 9,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-177647.359375, -49682.26953125, 1244.6986083984, 0},
        text = {-177499.15625, -49685.515625, 1237.4119873047},
        doors = {
            {
                entity = -1,
                model = 21,
                x = -177532,
                y = -49729,
                z = 1145,
                r = 180
            },
            {
                entity = -1,
                model = 23,
                x = -178660,
                y = -49881,
                z = 1146,
                r = 0
            },
            {
                entity = -1,
                model = 22,
                x = -179061,
                y = -49841,
                z = 1146,
                r = 0
            }
        }
    },
    {
        id = 10,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-162374.625, -36704.3828125, 1179.8830566406, 0},
        text = {-162252.421875, -36704.33984375, 1182.3640136719},
        doors = {
            {
                entity = -1,
                model = 40,
                x = -162288,
                y = -36656,
                z = 1085,
                r = 0
            }
        }
    },
    {
        id = 11,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-161461.625, -39828.9140625, 1182.1553955078, 0},
        text = {-161348.671875, -39832.46484375, 1182.1553955078},
        doors = {
            {
                entity = -1,
                model = 40,
                x = -161386,
                y = -39784,
                z = 1085,
                r = 0
            }
        }
    },
    {
        id = 12,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-158540.296875, -39682.5078125, 1183.2471923828, 0},
        text = {-158432.078125, -39682.453125, 1183.7580566406},
        doors = {
            {
                entity = -1,
                model = 40,
                x = -158468,
                y = -39638.199219,
                z = 1085,
                r = 0
            }
        }
    },
    {
        id = 13,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-158366.25, -36742.921875, 1179.8830566406, 0},
        text = {-158361.1875, -36869.93359375, 1182.3640136719},
        doors = {
            {
                entity = -1,
                model = 40,
                x = -158320,
                y = -36831.199219,
                z = 1085,
                r = -90
            }
        }
    },
    {
        id = 14,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-155138.546875, -37943.53515625, 1179.8830566406, 0},
        text = {-155139.625, -38035.80078125, 1182.3640136719},
        doors = {
            {
                entity = -1,
                model = 40,
                x = -155095,
                y = -38000.199219,
                z = 1085,
                r = -90
            }
        }
    },
    {
        id = 15,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-155251.765625, -35692.234375, 1182.1553955078, 0},
        text = {-155360.65625, -35692.38671875, 1182.1553955078},
        doors = {
            {
                entity = -1,
                model = 40,
                x = -155325,
                y = -35741,
                z = 1085,
                r = -180
            }
        }
    },
    {
        id = 16,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-178881.03125, -55652.6015625, 1234.1956787109, 0},
        text = {-178885.734375, -55772.125, 1227.7380371094},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -178929,
                y = -55734,
                z = 1136,
                r = 90
            },
            {
                entity = -1,
                model = 21,
                x = -178481,
                y = -54904,
                z = 1136,
                r = -90
            },
            {
                entity = -1,
                model = 41,
                x = -180508,
                y = -55740,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 17,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-180347.609375, -58988.8359375, 1260.90234375, 0},
        text = {-180344.265625, -58874.5390625, 1247.1533203125},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -180300,
                y = -58908,
                z = 1162,
                r = -90
            },
            {
                entity = -1,
                model = 21,
                x = -180607,
                y = -59875,
                z = 1163,
                r = 90
            }
        }
    },
    {
        id = 18,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-183801.109375, -55658.9453125, 1234.1982421875, 0},
        text = {-183806.1875, -55767.91015625, 1227.4790039063},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -183854,
                y = -55734,
                z = 1136,
                r = 90
            },
            {
                entity = -1,
                model = 22,
                x = -183406,
                y = -54904,
                z = 1136,
                r = -90
            },
            {
                entity = -1,
                model = 41,
                x = -185429,
                y = -55740,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 19,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-184816.359375, -59492.55859375, 1240.2672119141, 0},
        text = {-184703.578125, -59495.83203125, 1227.6677246094},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -184737,
                y = -59543,
                z = 1142,
                r = -180
            }
        }
    },
    {
        id = 20,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-187944.484375, -55663.140625, 1234.1983642578, 0},
        text = {-187943.40625, -55767.58984375, 1227.6694335938},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -187989,
                y = -55734,
                z = 1136,
                r = 90
            },
            {
                entity = -1,
                model = 22,
                x = -187541,
                y = -54904,
                z = 1136,
                r = -90
            },
            {
                entity = -1,
                model = 41,
                x = -189619,
                y = -55740,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 21,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-187447.578125, -59081.828125, 1234.1983642578, 0},
        text = {-187442.9375, -58979.546875, 1227.6531982422},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -187398,
                y = -59013,
                z = 1136,
                r = -90
            },
            {
                entity = -1,
                model = 41,
                x = -189483,
                y = -59061,
                z = 1025,
                r = -180
            }
        }
    },
    {
        id = 22,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-193419.578125, -53819.87890625, 1240.1038818359, 0},
        text = {-193317.703125, -53825.0625, 1232.0913085938},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -193351,
                y = -53869,
                z = 1142,
                r = 180
            },
            {
                entity = -1,
                model = 21,
                x = -194321,
                y = -53563,
                z = 1142,
                r = 0
            },
            {
                entity = -1,
                model = 41,
                x = -193301,
                y = -55363,
                z = 1025,
                r = 90
            }
        }
    },
    {
        id = 23,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-187995.96875, -62689.67578125, 1234.1983642578, 0},
        text = {-187992.78125, -62791.9609375, 1227.4311523438},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -188044,
                y = -62758,
                z = 1136,
                r = 90
            },
            {
                entity = -1,
                model = 21,
                x = -187596,
                y = -61929,
                z = 1136,
                r = -9
            },
            {
                entity = -1,
                model = 41,
                x = -189647,
                y = -62736,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 24,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-184625.703125, -62431.58984375, 1225.2888183594, 0},
        text = {-184515.765625, -62431.81640625, 1227.7380371094},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -184564,
                y = -62479,
                z = 1127,
                r = 180
            }
        }
    },
    {
        id = 25,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-181522.953125, -62986.84765625, 1229.1857910156, 0},
        text = {-181525.671875, -63100.46484375, 1228.0900878906},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -181573,
                y = -63059,
                z = 1131,
                r = 90
            },
            {
                entity = -1,
                model = 41,
                x = -179389,
                y = -62734,
                z = 1025,
                r = 0
            }
        }
    },
    {
        id = 26,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-172571.3125, -88361.0390625, 1600.3059082031, 0},
        text = {-172675.140625, -88305.8671875, 1598.4008789063},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -172624.25,
                y = -88277.867188,
                z = 1502,
                r = -26
            },
            {
                entity = -1,
                model = 22,
                x = -172194.53125,
                y = -89294.8125,
                z = 1502,
                r = 154
            },
            {
                entity = -1,
                model = 42,
                x = -172121.671875,
                y = -87257.554688,
                z = 1421,
                r = -116
            }
        }
    },
    {
        id = 27,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-180066.546875, -83100.4375, 1743.3872070313, 0},
        text = {-180063.203125, -83200.5546875, 1737.4022216797},
        doors = {
            {
                entity = -1,
                model = 20,
                x = -180113.28125,
                y = -83168.921875,
                z = 1645,
                r = 92
            },
            {
                entity = -1,
                model = 41,
                x = -176790.890625,
                y = -83896.84375,
                z = 1589,
                r = -88
            },
            {
                entity = -1,
                model = 41,
                x = -176838.281250,
                y = -82539.664063,
                z = 1589,
                r = -88
            }
        }
    },
    {
        id = 28,
        price = 100,
        lock = true,
        spawnable = 0,
        owner = 0,
        spawn = {-173915.4375, -50723.91796875, 1244.5828857422, 0},
        text = {-173912.359375, -50595.3359375, 1227.9490966797},
        doors = {}
    }
}

function OnPackageStart()
    -- Save all player data automatically 
    CreateTimer(function()
		for k,v in pairs(houses) do
            SaveHouseData(k)
            
        end
        print("All houses have been saved !")
    end, 30000)
    
end
AddEvent("OnPackageStart", OnPackageStart)

function getHouseDoor(door)
    for k,v in pairs(houses) do
        for i,j in pairs(v.doors) do
            if j.entity == door then
                return k
            end
        end
    end
    return 0
end

function getHouseID(id)
    for k,v in pairs(houses) do
        if v.id == id then
            return k
        end
    end
    return 0
end

function getHouseOwner(player)
    for k,v in pairs(houses) do
        if v.owner == tonumber(PlayerData[player].accountid) then
            return k
        end
    end
    return 0
end

AddEvent("database:connected", function()
    mariadb_query(sql, "SELECT * FROM player_house;", function()
        for i=1,mariadb_get_row_count() do
            local result = mariadb_get_assoc(i)
            local id = getHouseID(tonumber(result['id']))
            

            houses[id].owner = tonumber(result['ownerid'])
            houses[id].spawnable = tonumber(result['spawn'])

            if houses[id].owner == 0 then
                houses[id].txtentities = {
                    CreateText3D( _("house_id").." "..houses[id].id, 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3]+20, 0, 0, 0 ),
                    CreateText3D( _("price").." "..houses[id].price.._("currency"), 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3], 0, 0, 0 )
                }
            else
                mariadb_query(sql, "SELECT name FROM accounts WHERE id='"..houses[id].owner.."';", function()
                    houses[id].txtentities = {
                        CreateText3D( _("house_id").." "..houses[id].id, 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3]+20, 0, 0, 0 ),
                        CreateText3D( _("owner").." "..mariadb_get_value_name(1, "name"), 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3], 0, 0, 0 )
                    }
                end)
            end
        end
    end)
    
end)

AddEvent("OnPlayerSpawn", function( player )
    Delay( 500, function()
        local house = getHouseOwner(player)

        if house ~= 0 then
            if houses[house].spawnable == 1 then
                SetPlayerLocation(player, houses[house].spawn[1], houses[house].spawn[2], houses[house].spawn[3] + 100)
                SetPlayerHeading( player, houses[house].spawn[4] )
            end
        end
    end)
end)


AddRemoteEvent("interactHouse", function(player, door) 
    local house = getHouseDoor(door)

    if houses == 0 then
        return
    end

    if houses[house].owner == 0 then
        CallRemoteEvent(player, "OpenHouseBuy", house, houses[house].price)
    else
        if houses[house].owner == tonumber(PlayerData[player].accountid) then
            CallRemoteEvent(player, "OpenHouseMenu", house, houses[house].price)
        end
    end
end)


AddEvent("OnPackageStart", function()
    for k,v in pairs(houses) do
        for k,v in pairs(v.doors) do
            v.entity = CreateDoor( v.model, v.x, v.y, v.z, v.r, true )
        end
    end
end)

AddEvent("OnPlayerInteractDoor", function( player, door, bWantsOpen )
    local house = getHouseDoor(door)
    if house == 0 then
        SetDoorOpen(door, not IsDoorOpen(door))
    else
        if not houses[house].lock then
            SetDoorOpen(door, not IsDoorOpen(door))
        end
    end
end)

AddRemoteEvent("BuyHouse", function(player, house)
    if PlayerData[player].cash < houses[house].price then
        return AddPlayerChat(player, _("not_enought_cash"))
    end

    if getHouseOwner(player) ~= 0 then
        AddPlayerChat(player, _("already_house_owner"))
    else
        PlayerData[player].cash = PlayerData[player].cash - houses[house].price
        houses[house].owner = tonumber(PlayerData[player].accountid)
        DestroyText3D(houses[house].txtentities[2])
        houses[house].txtentities[2] = CreateText3D( _("owner").." "..GetPlayerName(player), 10, houses[house].text[1] , houses[house].text[2], houses[house].text[3], 0, 0, 0 )        
    end
end)

AddRemoteEvent("UnlockHouse", function(player, house) 
    if houses[house].owner == tonumber(PlayerData[player].accountid) then
        if houses[house].lock then
            houses[house].lock = false
            AddPlayerChat(player, _("unlock_house"))
        else
            houses[house].lock = true
            AddPlayerChat(player, _("lock_house"))
        end
    end
end)

AddRemoteEvent("SellHouse", function(player, house) 
    if houses[house].owner == tonumber(PlayerData[player].accountid) then
        price = math.ceil(houses[house].price * 0.25)
        PlayerData[player].cash = PlayerData[player].cash + price
        houses[house].owner = 0
        AddPlayerChat(player, _("house_sell", price, _("currency")))
        DestroyText3D(houses[house].txtentities[2])
        houses[house].txtentities[2] = CreateText3D( _("price").." "..houses[house].price.._("currency"), 10, houses[house].text[1] , houses[house].text[2], houses[house].text[3], 0, 0, 0 )        
    end
end)

AddRemoteEvent("SetHouseSpawn", function(player, house)
    if houses[house].owner == tonumber(PlayerData[player].accountid) then
        if houses[house].spawnable == 1 then
            AddPlayerChat(player, _("default_spawn"))
            houses[house].spawnable = 0
        else
            AddPlayerChat(player, _("house_spawn"))
            houses[house].spawnable = 1
        end
    end
end)

function SaveHouseData(house) 
    local query = mariadb_prepare(sql, "UPDATE player_house SET ownerid = '?', spawn = '?' WHERE id = '?' LIMIT 1;",
    houses[house].owner,
    houses[house].spawnable,
    houses[house].id
    )
    
mariadb_query(sql, query)
end

function GetNearestHouseDoor(player)
    local x, y, z = GetPlayerLocation(player)

    for k,v in pairs(houses) do
            for i,j in pairs(v.doors) do
                local x2, y2, z2 = GetDoorLocation( j.entity )
                local dist = GetDistance3D(x, y, z, x2, y2, z2)
                if dist < 150.0 then
                    return j.entity
                end
            end
        end
    return 0
end
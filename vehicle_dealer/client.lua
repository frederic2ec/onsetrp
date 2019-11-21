local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local carDealer
local isCarDealer
local StreamedCarDealerIds = { }
local CarDealerIds = { }
local carRetrieved

function OnPackageStart()
	carDealer = CreateWebUI(800.0, 200.0, 700.0, 450.0, 5, 10)
	LoadWebFile(carDealer, "http://asset/"..GetPackageName().."/client/cardealer/cardealer.html")
	SetWebAlignment(carDealer, 0.0, 0.0)
	SetWebAnchors(carDealer, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(carDealer, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
	DestroyWebUI(carDealer)
end
AddEvent("OnPackageStop", OnPackageStop)

function OnWebLoadComplete(webid)
	if (carDealer == webid) and not carRetrieved then
        Delay(1000, function(webid)
            carRetrieved = not carRetrieved
			CallRemoteEvent("sendCarList")
		end, carDealer)
	end
end
AddEvent("OnWebLoadComplete", OnWebLoadComplete)

function OnKeyPress(key)
    if key == "E" then
        local NearestCarDealer = GetNearestCarDealer()
        if NearestCarDealer ~= 0 then
            CallRemoteEvent("carDealerInteract", NearestCarDealer)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddRemoteEvent("carDealerSetup", function(CarDealerObject)
    CarDealerIds = CarDealerObject
end)

function GetNearestCarDealer()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			for k,i in pairs(CarDealerIds) do
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

function openCarDealer()
    ShowMouseCursor(true)
    SetInputMode(INPUT_UI)
    SetWebVisibility(carDealer, WEB_VISIBLE)
    isCarDealer = not isCarDealer
    
end
AddRemoteEvent("openCarDealer", openCarDealer)

function getCarList(car)
    for k,v in pairs(car) do
        local modelid = tostring(v.modelid)
        local name = tostring(v.name)
        local price = tostring(v.price)
        ExecuteWebJS(carDealer, 'addCarList( "'..modelid..'", "'..name..'", "'..price..'");')
	end
end
AddRemoteEvent("getCarList", getCarList)

function closeCarDealer()
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(carDealer, WEB_HIDDEN)
    isCarDealer = not isCarDealer
end
AddRemoteEvent("closeCarDealer", closeCarDealer)
AddEvent("closeCarDealer", closeCarDealer)

function buyCar(modelid, color)
	local modelid = tostring(modelid)
	local color = tostring(color)
    if color == 'nil' then
        AddPlayerChat(_("select_car_to_buy"))
    else
        CallRemoteEvent("buyCarServer", modelid, color)
    end
end
AddEvent("buyCar", buyCar)
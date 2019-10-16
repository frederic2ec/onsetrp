
local atm
local isAtm
local StreamedAtmIds = { }
local AtmIds = { }

function OnPackageStart()
	atm = CreateWebUI(800.0, 200.0, 700.0, 450.0, 5, 10)
	LoadWebFile(atm, "http://asset/"..GetPackageName().."/client/atm/atm.html")
	SetWebAlignment(atm, 0.0, 0.0)
	SetWebAnchors(atm, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(atm, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
	DestroyWebUI(atm)
end
AddEvent("OnPackageStop", OnPackageStop)

function OnKeyPress(key)
    if key == "E" then
        local NearestATM = GetNearestATM()
		if NearestATM ~= 0 then
            CallRemoteEvent("atmInteract", NearestATM)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function updateAtm(bank, cash)
    ExecuteWebJS(atm, "changeBank("..bank..")")
    ExecuteWebJS(atm, "changeCash("..cash..")")
end
AddRemoteEvent("updateAtm", updateAtm)

AddRemoteEvent("atmSetup", function(AtmObjects)
    AtmIds = AtmObjects

	-- Reset the table
	StreamedAtmIds = { }

	for _,v in pairs(AtmIds) do
		-- IsValidObject returns true on the client if this object is streamed in
		if IsValidObject(v) then
			table.insert(StreamedAtmIds, v)
		end
	end
end)

AddEvent("OnObjectStreamIn", function(object)
	for _,v in pairs(AtmIds) do
		if object == v then
			table.insert(StreamedAtmIds, v)
			break
		end
	end
end)

AddEvent("OnObjectStreamOut", function(object)
	for _,v in pairs(AtmIds) do
		if object == v then
			table.remove(StreamedAtmIds, tablefind(StreamedAtmIds, v))
			break
		end
	end
end)

function GetNearestATM()
	local x, y, z = GetPlayerLocation()

	for _,v in pairs(StreamedAtmIds) do
		local x2, y2, z2 = GetObjectLocation(v)

		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 180.0 then
            return v
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
    if tonumber(amount) ~= nil then
        if tonumber(amount) > 0 then
            CallRemoteEvent("withdrawAtm", amount)
        else
            AddPlayerChat("Please enter an higher number !")
        end
    else
        AddPlayerChat("Please enter a valid number !")
    end 
end
AddEvent("withdrawMoney", withdrawMoney)

function depositMoney(amount)
    if tonumber(amount) ~= nil then
        if tonumber(amount) > 0 then
            CallRemoteEvent("depositAtm", amount)
        else
            AddPlayerChat("Please enter an higher number !")
        end
    else
        AddPlayerChat("Please enter a valid number !")
    end 
end
AddEvent("depositMoney", depositMoney)

function openAtm()
    ShowMouseCursor(true)
    SetInputMode(INPUT_UI)
    SetWebVisibility(atm, WEB_VISIBLE)
    CallRemoteEvent("getAtmData")
    isAtm = not isAtm
end
AddRemoteEvent("openAtm", openAtm)

function closeAtm()
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(atm, WEB_HIDDEN)
    isAtm = not isAtm
end
AddEvent("closeAtm", closeAtm)
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gasStationUI

function OnPackageStartGasStation()
    local width, height = GetScreenSize()
    gasStationUI = CreateWebUI(width / 4.7, height / 4.7, 540, -1050, 5, 60)
    LoadWebFile(gasStationUI, "http://asset/onsetrp/burdigalax/client/gui/gasStation.html")
    SetWebAlignment(gasStationUI, 0.0, 0.0)
    SetWebAnchors(gasStationUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(gasStationUI, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStartGasStation)

function OnPackageStopGasStation()
    DestroyWebUI(gasStationUI)
end
AddEvent("OnPackageStop", OnPackageStopGasStation)

-- CLOSE

function CloseUIGasStation()
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    Delay(100, function()
      SetWebVisibility(gasStationUI, WEB_HIDDEN)
      OnPackageStartGasStation() -- Rustine pour reset l'ui
    end)
end
AddEvent("BURDIGALAX_gasStation_onClose", CloseUIGasStation)

function OpenUIGasStation(cash, maxFuel, currentFuel, gasoilPrice, gasoilPlusPrice)
    ExecuteWebJS(gasStationUI, "BURDIGALAX_gasStation.setConfig("..json_encode(BuildGasStationJson(cash, maxFuel, currentFuel, gasoilPrice, gasoilPlusPrice))..")")
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(gasStationUI, WEB_VISIBLE)
end
AddEvent("OpenUIGasStation", OpenUIGasStation)
AddRemoteEvent("OpenUIGasStation", OpenUIGasStation)

function OnKeyPressGasStation(key)
    if key == 'Backspace' then
        CloseUIGasStation()
    end
end
AddEvent("OnKeyPress", OnKeyPressGasStation)

function OnPaymentGasStation(event)
    ExecuteWebJS(gasStationUI, "SetErrorGasStation()")
end
AddEvent('BURDIGALAX_gasStation_onPayment', OnPaymentGasStation)

function UpdateGasStation(cash, maxFuel, currentFuel)
    ExecuteWebJS(gasStationUI, "BURDIGALAX_gasStation.updatePlayer({ money: "..cash..", car: { tank: "..maxFuel..", fuelValue: "..currentFuel.." } })")
end
AddEvent('UpdateGasStation', UpdateGasStation)
AddRemoteEvent("UpdateGasStation", UpdateGasStation)

function BuildGasStationJson(cash, maxFuel, currentFuel, gasoilPrice, gasoilPlusPrice)
    return {
        config = {
            hasTaxEnabled = false
        },
        player = {
            money = cash,
            car = {
                tank = maxFuel,
                type = "fuel",
                fuelValue = currentFuel
            }
        },
        station = {
            name = "7 GAS",
            iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgMTAwIDEwMCIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgMTAwIDEwMCIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+PGc+PHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik01MCw1LjUzMWMtMTkuNjMxLDAtMzUuNTQzLDE1LjkxMy0zNS41NDQsMzUuNTQzICAgYzAsOS44MTUsNC4zNjYsMTguMzM2LDEwLjQxMSwyNS4xMzVMNTAsOTQuNDY5bDI1LjEzNC0yOC4yNmM2LjA0My02Ljc5OSwxMC40MS0xNS4zMTksMTAuNDEtMjUuMTM1ICAgQzg1LjU0NCwyMS40NDQsNjkuNjMsNS41MzEsNTAsNS41MzF6IE02OS44NzQsNjAuOTQ4QzY0Ljc4OCw2Ni4wMzUsNTcuNzYxLDY5LjE4MSw1MCw2OS4xODFjLTcuNzYzLDAtMTQuNzg4LTMuMTQ2LTE5Ljg3NS04LjIzMiAgIGMtNS4wODYtNS4wODctOC4yMzEtMTIuMTEzLTguMjMxLTE5Ljg3NGMwLTE1LjUyMywxMi41ODQtMjguMTA1LDI4LjEwNi0yOC4xMDVjMTUuNTIxLDAsMjguMTA1LDEyLjU4MiwyOC4xMDUsMjguMTA1ICAgQzc4LjEwNSw0OC44MzUsNzQuOTYsNTUuODYxLDY5Ljg3NCw2MC45NDh6Ij48L3BhdGg+PHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik02Ny4xMzcsMzUuODk2bC0wLjEyOC0wLjU5NWwtMS4yMzgtMy43NDVjMC4xOTktMC4xNTgsMC4zMDUtMC40MjQsMC4xOTItMC42NTYgICBsLTEuMDY2LTIuMjJjLTAuMTkyLTAuNDAyLTAuNjQ3LTAuNTk4LTEuMDcyLTAuNDZsLTAuNTcsMC4xODZsLTAuMDAyLDAuMDAzTDYxLjc1MSwyNy41bC0wLjc4NiwwLjE5M2wtMS42MjEtMC44MjR2LTMuMTE2ICAgYzAtMC43MDItMC41NzUtMS4yNzYtMS4yNzctMS4yNzZIMzkuMjk0Yy0wLjcwMiwwLTEuMjc2LDAuNTc0LTEuMjc2LDEuMjc2djM1LjU2NWMwLDAuNzAyLDAuNTc0LDEuMjc2LDEuMjc2LDEuMjc2aDE4Ljc3MiAgIGMwLjcwMiwwLDEuMjc3LTAuNTc0LDEuMjc3LTEuMjc2VjQ0Ljk4NGMwLjU2MSwwLjAyMiwxLjA0NSwwLjE1OSwxLjI1MywwLjU2YzAuMjI2LDAuNDM3LDAuMjAxLDEuNjA0LDAuMTczLDIuOTAxICAgYy0wLjAxMSwwLjUwNy0wLjAyMiwxLjAzMS0wLjAyMiwxLjMzNGgwLjAwM2MwLDIuODkzLDAuMzk2LDUuNzUzLDMuNDM5LDUuNzUzYzAuMjk2LDAsMC41NzYtMC4wMzcsMC44NDQtMC4xMSAgIGMxLjM1My0wLjM2NywyLjIwNS0xLjU2NywyLjY5OS0zLjI0MmMwLjQzNy0xLjQ3OSwwLjYwMy0zLjM1NSwwLjYwMy01LjMyYzAtNC4yMTYtMC43NTYtOC45MzktMS4yMDEtMTAuOTYzTDY3LjEzNywzNS44OTZ6ICAgIE02Mi42OTMsMzIuNzZjMC4wOTItMC4yMjMsMC4yNS0wLjQxNCwwLjQ4Ny0wLjQ1M2wxLjA1Ni0wLjE3MmwwLjkwOCwyLjc5NmwtMC45NjEsMC4wODVjLTAuMzMsMC4wMjktMC42MzItMC4xMS0wLjc5My0wLjM5OSAgIGwtMC42NjUtMS4xOTJDNjIuNjA3LDMzLjIxNSw2Mi42MDMsMzIuOTgyLDYyLjY5MywzMi43NnogTTU1LjgxLDM2LjMwNUg0MS41NWMtMC43MjMsMC0xLjMxNC0wLjU5Mi0xLjMxNC0xLjMxNXYtOSAgIGMwLTAuNzIzLDAuNTkyLTEuMzE0LDEuMzE0LTEuMzE0aDE0LjI2YzAuNzI0LDAsMS4zMTUsMC41OTIsMS4zMTUsMS4zMTR2OUM1Ny4xMjUsMzUuNzEzLDU2LjUzMywzNi4zMDUsNTUuODEsMzYuMzA1eiAgICBNNjYuMDY5LDUxLjY5Yy0wLjMyNCwxLjEwMS0wLjgwNCwxLjg2OC0xLjQ5MSwyLjA1NmMtMC4xMTgsMC4wMzItMC4yNDgsMC4wNDktMC4zODksMC4wNDljLTEuNTEyLDAtMS43MDgtMS45OTctMS43MDgtNC4wMTYgICBoMC4wMDNjMC0wLjU4NCwwLjAwOC0wLjk0NSwwLjAxNi0xLjNjMC4wMzQtMS41MzEsMC4wNjMtMi45MDctMC4zNjMtMy43MjljLTAuNjEzLTEuMTgzLTEuNjkyLTEuNDkzLTIuNzkzLTEuNTFWMjcuNzc4ICAgbDEuMTkyLDAuNjA4bC0wLjAwNSwwLjAwOGwwLjE5NiwwLjc5NmwxLjI1NCwwLjc1OWwtMC41NjcsMC42OWMtMC4wMDYsMC4wMDYtMC4wMDEsMC4wMTQtMC4wMDYsMC4wMmwtMC4wMTIsMC4wMDVsLTAuNDk2LDAuODggICBjLTAuMSwwLjE3Ni0wLjEyMiwwLjM2OC0wLjAzNSwwLjU0OWMwLjYxMSwxLjI3OSwxLjI1OSwyLjUwNywxLjkyLDMuNzY4YzAuMTQ1LDAuMjc1LDAuNDM0LDAuNDIyLDAuNzQsMC4zNzRsMS44MzktMC4yODYgICBjMC40MDMsMS42NTksMS4yMzMsNi41NSwxLjIzMywxMC45MTFDNjYuNTk4LDQ4LjY4Myw2Ni40NTIsNTAuMzk1LDY2LjA2OSw1MS42OXoiPjwvcGF0aD48L2c+PC9zdmc+",
            isOpen = true
        },
        gases = {
            {
                id = 'gasoil',
                name = "Gasoil",
                type = "fuel",
                price = tonumber(gasoilPrice),
                tax = 0,
                color = "#eac718",
                bgColorSelected = "#fdfdb7",
                fuelColor = "#eac718",
                iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgMTAwIDEwMCIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgMTAwIDEwMCIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+PHBhdGggZD0iTTY2LjEyMSw0Mi42NTFjLTYuMDg1LTkuMTc2LTEyLjk3OS0xOS41NjgtMTUuMjE2LTM3LjIyQzQ4LjY2NiwyMy4wOCw0MS43NzIsMzMuNDc2LDM1LjY4OCw0Mi42NSAgYy01LjU3OSw4LjQxMS0xMC4zOTcsMTUuNjc2LTEwLjM5NywyNi42NTVjMCwxMy45MywxMS40OTEsMjUuMjYzLDI1LjYxNCwyNS4yNjNjMTQuMTIzLDAsMjUuNjEyLTExLjMzMywyNS42MTItMjUuMjYzICBDNzYuNTE4LDU4LjMyNyw3MS43LDUxLjA2Myw2Ni4xMjEsNDIuNjUxeiBNNTMuMTkyLDg3LjI0NGwtMC43NTItMS44NTRjNi43MzctMi43MywxMi4wMjUtOC4xNDgsMTQuNTA5LTE0Ljg2NGwxLjg3NSwwLjY5MyAgQzY2LjE0Nyw3OC40NjMsNjAuNDQ5LDg0LjMwMyw1My4xOTIsODcuMjQ0eiI+PC9wYXRoPjxwYXRoIGQ9Ik04Ny43LDMwLjgwNGMtMy45NDQtNS45NDgtOC4zODItMTIuNjM5LTEwLjE4My0yMy41NDhjLTEuNzk5LDEwLjkwNi02LjIzNiwxNy41OTgtMTAuMTgxLDIzLjU0NiAgYy0xLjE1NiwxLjc0My0yLjI0NywzLjM5OS0zLjIyNSw1LjA4YzEuMjI5LDEuOTY3LDIuNDY4LDMuODQzLDMuNjc2LDUuNjY0YzUuMTczLDcuOCw5LjY5OSwxNC42NTQsMTAuNTY3LDI0LjM2NCAgYzkuMTMxLTAuNDM1LDE2LjQyOS03Ljg3NCwxNi40MjktMTYuOTg0Qzk0Ljc4NCw0MS40ODQsOTEuNTAyLDM2LjUzNSw4Ny43LDMwLjgwNHoiPjwvcGF0aD48cGF0aCBkPSJNNS4yMTYsNjMuMjM3YzAsNy45MTcsNi41MzMsMTQuMzU3LDE0LjU2MywxNC4zNTdjMS41NzEsMCwzLjEwOC0wLjI2Nyw0LjU5LTAuNzY1Yy0wLjY5Ny0yLjM5Mi0xLjA3OC00LjkxNC0xLjA3OC03LjUyNCAgYzAtOC4xMTUsMi40NDUtMTQuMjI1LDUuODg3LTIwLjE0MmMtMC4yODEtMC40MjktMC41NjItMC44NTUtMC44NS0xLjI5MWMtMy4yNjYtNC45MjYtNi45MjctMTAuNDQ5LTguNTQ5LTE5LjI3OCAgYy0xLjYyMiw4LjgzMi01LjI4NSwxNC4zNTYtOC41NTIsMTkuMjgzQzguMDAxLDUyLjc0MSw1LjIxNiw1Ni45NDEsNS4yMTYsNjMuMjM3eiI+PC9wYXRoPjwvc3ZnPg==",
                unit = "L",
                quantity = 500,
                speed = 1
            },
            {
              id = "gasoilplus",
              name = "Gasoil +",
              type = "fuel",
              price = tonumber(gasoilPlusPrice),
              tax = 0,
              color = "#ffa603",
              bgColorSelected = "#ffe5b5",
              fuelColor = "#ffa603",
              iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgMTAwIDEwMCIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgMTAwIDEwMCIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+PHBhdGggZD0iTTY2LjEyMSw0Mi42NTFjLTYuMDg1LTkuMTc2LTEyLjk3OS0xOS41NjgtMTUuMjE2LTM3LjIyQzQ4LjY2NiwyMy4wOCw0MS43NzIsMzMuNDc2LDM1LjY4OCw0Mi42NSAgYy01LjU3OSw4LjQxMS0xMC4zOTcsMTUuNjc2LTEwLjM5NywyNi42NTVjMCwxMy45MywxMS40OTEsMjUuMjYzLDI1LjYxNCwyNS4yNjNjMTQuMTIzLDAsMjUuNjEyLTExLjMzMywyNS42MTItMjUuMjYzICBDNzYuNTE4LDU4LjMyNyw3MS43LDUxLjA2Myw2Ni4xMjEsNDIuNjUxeiBNNTMuMTkyLDg3LjI0NGwtMC43NTItMS44NTRjNi43MzctMi43MywxMi4wMjUtOC4xNDgsMTQuNTA5LTE0Ljg2NGwxLjg3NSwwLjY5MyAgQzY2LjE0Nyw3OC40NjMsNjAuNDQ5LDg0LjMwMyw1My4xOTIsODcuMjQ0eiI+PC9wYXRoPjxwYXRoIGQ9Ik04Ny43LDMwLjgwNGMtMy45NDQtNS45NDgtOC4zODItMTIuNjM5LTEwLjE4My0yMy41NDhjLTEuNzk5LDEwLjkwNi02LjIzNiwxNy41OTgtMTAuMTgxLDIzLjU0NiAgYy0xLjE1NiwxLjc0My0yLjI0NywzLjM5OS0zLjIyNSw1LjA4YzEuMjI5LDEuOTY3LDIuNDY4LDMuODQzLDMuNjc2LDUuNjY0YzUuMTczLDcuOCw5LjY5OSwxNC42NTQsMTAuNTY3LDI0LjM2NCAgYzkuMTMxLTAuNDM1LDE2LjQyOS03Ljg3NCwxNi40MjktMTYuOTg0Qzk0Ljc4NCw0MS40ODQsOTEuNTAyLDM2LjUzNSw4Ny43LDMwLjgwNHoiPjwvcGF0aD48cGF0aCBkPSJNNS4yMTYsNjMuMjM3YzAsNy45MTcsNi41MzMsMTQuMzU3LDE0LjU2MywxNC4zNTdjMS41NzEsMCwzLjEwOC0wLjI2Nyw0LjU5LTAuNzY1Yy0wLjY5Ny0yLjM5Mi0xLjA3OC00LjkxNC0xLjA3OC03LjUyNCAgYzAtOC4xMTUsMi40NDUtMTQuMjI1LDUuODg3LTIwLjE0MmMtMC4yODEtMC40MjktMC41NjItMC44NTUtMC44NS0xLjI5MWMtMy4yNjYtNC45MjYtNi45MjctMTAuNDQ5LTguNTQ5LTE5LjI3OCAgYy0xLjYyMiw4LjgzMi01LjI4NSwxNC4zNTYtOC41NTIsMTkuMjgzQzguMDAxLDUyLjc0MSw1LjIxNiw1Ni45NDEsNS4yMTYsNjMuMjM3eiI+PC9wYXRoPjwvc3ZnPg==",
              unit = "L",
              quantity = 500,
              speed = 2
            },
            {
              id = 3,
              name = "ESSENCE",
              type = "fuel",
              price = 0.895,
              tax = 70,
              color = "#000000",
              bgColorSelected = "#a9a9a9",
              fuelColor = "#615e5e",
              iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxuczp4PSJodHRwOi8vbnMuYWRvYmUuY29tL0V4dGVuc2liaWxpdHkvMS4wLyIgeG1sbnM6aT0iaHR0cDovL25zLmFkb2JlLmNvbS9BZG9iZUlsbHVzdHJhdG9yLzEwLjAvIiB4bWxuczpncmFwaD0iaHR0cDovL25zLmFkb2JlLmNvbS9HcmFwaHMvMS4wLyIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIGVuYWJsZS1iYWNrZ3JvdW5kPSJuZXcgMCAwIDEwMCAxMDAiIHhtbDpzcGFjZT0icHJlc2VydmUiPjxtZXRhZGF0YT48c2Z3IHhtbG5zPSJodHRwOi8vbnMuYWRvYmUuY29tL1NhdmVGb3JXZWIvMS4wLyI+PHNsaWNlcz48L3NsaWNlcz48c2xpY2VTb3VyY2VCb3VuZHMgaGVpZ2h0PSI4Ni42MzkiIHdpZHRoPSI1OCIgeD0iMjEiIHk9IjcuMjUiIGJvdHRvbUxlZnRPcmlnaW49InRydWUiPjwvc2xpY2VTb3VyY2VCb3VuZHM+PG9wdGltaXphdGlvblNldHRpbmdzPjx0YXJnZXRTZXR0aW5ncyBmaWxlRm9ybWF0PSJHSUZGb3JtYXQiIHRhcmdldFNldHRpbmdzSUQ9IjAiPjxHSUZGb3JtYXQgdHJhbnNwYXJlbmN5PSJ0cnVlIiBsb3NzeT0iMCIgYXV0b1JlZHVjZT0iZmFsc2UiIHJvbGxvdmVyTWFzdGVyUGFsZXR0ZT0iZmFsc2UiIG51bUNvbG9ycz0iMjU2IiBkaXRoZXJQZXJjZW50PSIxMDAiIGRpdGhlckFsZ29yaXRobT0iZGlmZnVzaW9uIiByZWR1Y3Rpb25BbGdvcml0aG09InNlbGVjdGl2ZSIgaW5jbHVkZUNhcHRpb249ImZhbHNlIiB3ZWJTaGlmdFBlcmNlbnQ9IjAiIG5vTWF0dGVDb2xvcj0iZmFsc2UiIGludGVybGFjZWQ9ImZhbHNlIiBtYXR0ZUNvbG9yPSIjRkZGRkZGIj48Y29sb3JUYWJsZSBpc0V4YWN0PSJmYWxzZSI+PC9jb2xvclRhYmxlPjxsb2NrZWRDb2xvcnM+PC9sb2NrZWRDb2xvcnM+PGNvbG9yU2hpZnRFbnRyaWVzPjwvY29sb3JTaGlmdEVudHJpZXM+PC9HSUZGb3JtYXQ+PC90YXJnZXRTZXR0aW5ncz48L29wdGltaXphdGlvblNldHRpbmdzPjwvc2Z3PjwvbWV0YWRhdGE+PHBhdGggZD0iTTUxLjIzNCw3Ljg5N0w1MCw2LjExMWwtMS4yMzQsMS43ODdDNDcuNjMyLDkuNTM5LDIxLDQ4LjI3MiwyMSw2My43NWMwLDE1Ljk5LDEzLjAwOSwyOSwyOSwyOWMxNS45OSwwLDI5LTEzLjAxLDI5LTI5ICBDNzksNDguMjcyLDUyLjM2OCw5LjUzOSw1MS4yMzQsNy44OTd6IE01MCw4NS4yNWMtMTEuODU1LDAtMjEuNS05LjY0NS0yMS41LTIxLjVjMC0wLjgyOCwwLjY3MS0xLjUsMS41LTEuNXMxLjUsMC42NzIsMS41LDEuNSAgYzAsMTAuMjAxLDguMjk5LDE4LjUsMTguNSwxOC41YzAuODI5LDAsMS41LDAuNjcyLDEuNSwxLjVTNTAuODI5LDg1LjI1LDUwLDg1LjI1eiI+PC9wYXRoPjwvc3ZnPg==",
              unit = "L",
              quantity = 0
            },
            {
              id = 4,
              name = "ESSENCE+",
              type = "fuel",
              price = 1.182,
              tax = 75,
              color = "#4a0b4a",
              bgColorSelected = "#edd8ff",
              fuelColor = "#4a0b4a",
              iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxuczp4PSJodHRwOi8vbnMuYWRvYmUuY29tL0V4dGVuc2liaWxpdHkvMS4wLyIgeG1sbnM6aT0iaHR0cDovL25zLmFkb2JlLmNvbS9BZG9iZUlsbHVzdHJhdG9yLzEwLjAvIiB4bWxuczpncmFwaD0iaHR0cDovL25zLmFkb2JlLmNvbS9HcmFwaHMvMS4wLyIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIGVuYWJsZS1iYWNrZ3JvdW5kPSJuZXcgMCAwIDEwMCAxMDAiIHhtbDpzcGFjZT0icHJlc2VydmUiPjxtZXRhZGF0YT48c2Z3IHhtbG5zPSJodHRwOi8vbnMuYWRvYmUuY29tL1NhdmVGb3JXZWIvMS4wLyI+PHNsaWNlcz48L3NsaWNlcz48c2xpY2VTb3VyY2VCb3VuZHMgaGVpZ2h0PSI4Ni42MzkiIHdpZHRoPSI1OCIgeD0iMjEiIHk9IjcuMjUiIGJvdHRvbUxlZnRPcmlnaW49InRydWUiPjwvc2xpY2VTb3VyY2VCb3VuZHM+PG9wdGltaXphdGlvblNldHRpbmdzPjx0YXJnZXRTZXR0aW5ncyBmaWxlRm9ybWF0PSJHSUZGb3JtYXQiIHRhcmdldFNldHRpbmdzSUQ9IjAiPjxHSUZGb3JtYXQgdHJhbnNwYXJlbmN5PSJ0cnVlIiBsb3NzeT0iMCIgYXV0b1JlZHVjZT0iZmFsc2UiIHJvbGxvdmVyTWFzdGVyUGFsZXR0ZT0iZmFsc2UiIG51bUNvbG9ycz0iMjU2IiBkaXRoZXJQZXJjZW50PSIxMDAiIGRpdGhlckFsZ29yaXRobT0iZGlmZnVzaW9uIiByZWR1Y3Rpb25BbGdvcml0aG09InNlbGVjdGl2ZSIgaW5jbHVkZUNhcHRpb249ImZhbHNlIiB3ZWJTaGlmdFBlcmNlbnQ9IjAiIG5vTWF0dGVDb2xvcj0iZmFsc2UiIGludGVybGFjZWQ9ImZhbHNlIiBtYXR0ZUNvbG9yPSIjRkZGRkZGIj48Y29sb3JUYWJsZSBpc0V4YWN0PSJmYWxzZSI+PC9jb2xvclRhYmxlPjxsb2NrZWRDb2xvcnM+PC9sb2NrZWRDb2xvcnM+PGNvbG9yU2hpZnRFbnRyaWVzPjwvY29sb3JTaGlmdEVudHJpZXM+PC9HSUZGb3JtYXQ+PC90YXJnZXRTZXR0aW5ncz48L29wdGltaXphdGlvblNldHRpbmdzPjwvc2Z3PjwvbWV0YWRhdGE+PHBhdGggZD0iTTUxLjIzNCw3Ljg5N0w1MCw2LjExMWwtMS4yMzQsMS43ODdDNDcuNjMyLDkuNTM5LDIxLDQ4LjI3MiwyMSw2My43NWMwLDE1Ljk5LDEzLjAwOSwyOSwyOSwyOWMxNS45OSwwLDI5LTEzLjAxLDI5LTI5ICBDNzksNDguMjcyLDUyLjM2OCw5LjUzOSw1MS4yMzQsNy44OTd6IE01MCw4NS4yNWMtMTEuODU1LDAtMjEuNS05LjY0NS0yMS41LTIxLjVjMC0wLjgyOCwwLjY3MS0xLjUsMS41LTEuNXMxLjUsMC42NzIsMS41LDEuNSAgYzAsMTAuMjAxLDguMjk5LDE4LjUsMTguNSwxOC41YzAuODI5LDAsMS41LDAuNjcyLDEuNSwxLjVTNTAuODI5LDg1LjI1LDUwLDg1LjI1eiI+PC9wYXRoPjwvc3ZnPg==",
              unit = "L",
              quantity = 0
            },
            {
              id = 5,
              name = "ELECTRIQUE",
              type = "electric",
              price = 0.25,
              tax = 0,
              color = "#449cf7",
              bgColorSelected = "#cdecf9",
              fuelColor = "#449cf7",
              iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgMzAgMzAiIHhtbDpzcGFjZT0icHJlc2VydmUiPjxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKC00NTAgLTQ0MCkiPjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxwYXRoIGQ9Ik00NTUsNDU1YzAtNS4zMSw0LjE2Ni05LjY1Niw5LjQtOS45NzFsMS41MTctMS45ODJDNDY1LjYxMyw0NDMuMDIzLDQ2NS4zMSw0NDMsNDY1LDQ0M2MtNi42MjcsMC0xMiw1LjM3My0xMiwxMiAgICBjMCw0LjM5MSwyLjM2NSw4LjIxOSw1Ljg4NCwxMC4zMWwwLjUyMS0yLjAyN0M0NTYuNzQ5LDQ2MS40ODQsNDU1LDQ1OC40NDEsNDU1LDQ1NXoiPjwvcGF0aD48cGF0aCBkPSJNNDcxLjA3NCw0NDQuNjY0bC0wLjU0OSwyLjAwOEM0NzMuMjIsNDQ4LjQ2Nyw0NzUsNDUxLjUyNyw0NzUsNDU1YzAsNS4zMS00LjE2Niw5LjY1Ni05LjQsOS45NjlsLTEuNTE4LDEuOTg0ICAgIEM0NjQuMzg3LDQ2Ni45NzcsNDY0LjY5LDQ2Nyw0NjUsNDY3YzYuNjI3LDAsMTItNS4zNzMsMTItMTJDNDc3LDQ1MC41OTIsNDc0LjYxNiw0NDYuNzUsNDcxLjA3NCw0NDQuNjY0eiI+PC9wYXRoPjxwb2x5Z29uIHBvaW50cz0iNDczLDQ1MiA0NjcsNDUyIDQ2Ny41ODgsNDQ5Ljg0MiA0NjguNzEyLDQ0NS43MjMgNDY5LjI0LDQ0My43ODUgNDcwLDQ0MSA0NjguMTQyLDQ0My40MyA0NjYuODEsNDQ1LjE3MiAgICAgNDYzLjQ4Miw0NDkuNTIzIDQ1Nyw0NTggNDYzLDQ1OCA0NjIuNDE1LDQ2MC4xNDUgNDYxLjI4OCw0NjQuMjc3IDQ2MC43Niw0NjYuMjE1IDQ2MCw0NjkgNDYxLjg1OCw0NjYuNTcgNDYzLjE5LDQ2NC44MjggICAgIDQ2Ni41Niw0NjAuNDIgICAiPjwvcG9seWdvbj48L2c+PC9nPjwvc3ZnPg==",
              unit = "W",
              quantity = 0
            },
            {
              id = 6,
              name = "BIO",
              type = "fuel",
              price = 0.389,
              tax = 0,
              color = "#4fcc30",
              bgColorSelected = "#d2fbc8",
              fuelColor = "#4fcc30",
              iconUrl = "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGRhdGEtbmFtZT0iTGF5ZXIgMSIgdmlld0JveD0iMCAwIDEwMCAxMDAiIHg9IjBweCIgeT0iMHB4Ij48dGl0bGU+RWNvbG9neTwvdGl0bGU+PHBhdGggZD0iTTYzLjkxODgyLDY2LjM1OTE5Yy0xNi4yMjU3LTguOTE1NC0xOC42OTIyNi0zLjA3NDIyLTI2LjAxMTktNS41NTUyMy04LjIxOTI0LTIuNzg1NzctOS4zMTY0LDguMTgzLDYuMjk1MTEsOS43MDgwNiwxNi4xNDQsMS41NzcwOS03LjYyMzg0LDkuMjcyODktMTcuNTI2ODYsMi4xMzA3NEM3LjExNTYsNTguNTM2MTMsMS45MTc2LDY1LjU2NzM4LDguMzk4MzgsNjkuOTczODhjNi4zNTc2LDQuMzIyODEsOS4zNTQwNiw5Ljk0OTUyLDEzLjk5MzE2LDEyLjU4MTY2LDQuMjgzNjMsMi40MzA0OCw3LjExMSwzLjIyNzcyLDEyLjQ2OTQ4LDQuNjMxLDEyLjc1NzMzLDMuMzQwODgsMjcuMjI5MTMsMy43MjIsMzUuNjk2MjktLjI2ODg2LjU4NjU2LS4yNzYzNSwxMS4wMDM1Ny01LjMyMDE0LDIwLjY3ODM5LTkuOTc2NDNhMS43LDEuNywwLDAsMCwuOTYyNzQtMS41MzMzbC0uMDAwMDYtMjEuOTQ5NzFhLjUzNTExLjUzNTExLDAsMCwwLS42NzYxNi0uNTIwNDNDODEuMzAxNjgsNTUuOTIzMzUsNjguNjcwMyw2OC45Nyw2My45MTg4Miw2Ni4zNTkxOVoiPjwvcGF0aD48cGF0aCBkPSJNMjIuNzY3LDMzLjg0OGMyLjk2Miw2LjIzOTc1LDguMDU4NzcsOS40ODk1NywxMS4xNzc3Myw3LjE5ODg2YTkuMjgzMDksOS4yODMwOSwwLDAsMCwzLjAyMDYzLTUuOTE0MTNsLjAwMTgzLS4wMDA3M2E2NS40MDEzNyw2NS40MDEzNywwLDAsMSw3LjQ0NjM1LDcuNjk3NTdoMy4wNzI4OEMzMy45NDMzLDI1LjM1NDI1LDE4LjU1MjMxLDIwLDE4LjU1MjMxLDIwYzYuOTMsMS4zMjg0MywxNy42MTQxMyw2LjU4NTMzLDI1LjAxNjc4LDEyLjgxOTIxbC4wMDEuMDAwMzFhNi43MDQsNi43MDQsMCwwLDAsMy4wNTYtMS4wODY0OWMzLjExODktMi4yOTA3MSw0LjgyMjg4LTguMTU0NzgtMi42ODE1Mi0xMy40Mzg5QzI5LjU5NjY4LDguMTkxMjIsNSwxOC42Nyw1LDE4LjY3UzE0Ljg1NzA2LDE3LjE4NDg4LDIyLjc2NywzMy44NDhaIj48L3BhdGg+PHBhdGggZD0iTTg1LjYzMTU5LDE2LjYzMTM1Yy0uMDAyOTMuMDMyNDEtMTIuOTk1Niw4LjYwMDc3LTIyLjMzNDc4LDE5LjU0MDQ2LS4yODY1Ni4zNDA1Mi03Ljk4Niw5LjM5MzgtMTAuNDQxNzEsMTcuODI2ODVsMy44NTk0NCwyLjE0Mjg4YTM4Ljk0NzE0LDM4Ljk0NzE0LDAsMCwxLDQuMjU0ODgtMTAuNTQ0OEE1Ljg2Nyw1Ljg2NywwLDAsMCw2Mi4wMzE4LDQ3Ljc2NmMyLjgzNjc5LDMuNzI5MTMsMTAuNDg4ODMsMi4yOTQzNywxNi43NTcxNC0yLjkwNTM5Qzk0LjQ2MzA3LDMxLjg1ODI4LDk1LDEwLjY2NTEsOTUsMTAuNjY1MVM3NC4wOTk3OSw2Ljk2NDksNTguNDI3ODYsMjAuNDAwN0M1Mi4yNTE3NywyNS42OTU1LDQ4LjY4Njg3LDMzLjY4Njg3LDUyLDM3YTUuNDU4NjgsNS40NTg2OCwwLDAsMCw1LjEzNywxLjQwOTUxUzc0LDIwLDg1LjYzMTU5LDE2LjYzMTM1WiI+PC9wYXRoPjwvc3ZnPg==",
              unit = "L",
              quantity = 0
            }
        }
    }
end


















































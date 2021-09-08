local menuActive, currentCID, currentGang, currentLocation, Framework, Settings = false;

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    --RegisterKeyMapping('+gangsPress', 'Gangs General Use', 'keyboard', 'P')

	while Framework == nil do
		TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
		Citizen.Wait(500)
    end
    
    local playerData = Framework.Functions.GetPlayerData()
    while playerData == nil or playerData.citizenid == nil do
        playerData = Framework.Functions.GetPlayerData()
        Wait(1000)
    end

    currentCID = playerData.citizenid

    TriggerServerEvent("gangs:init")
end)

RegisterNetEvent('gangs:refresh')
AddEventHandler('gangs:refresh', function(data)
    if (not currentGang) or (currentGang.name ~= data.name) or (currentGang.grade ~= data.grade) then
        if menuActive then
            menuActive = false
            SetNuiFocus(menuActive, menuActive)
            SendNUIMessage({
                ['menu'] = false
            })
        end

        currentGang = data
    end
end)

RegisterNetEvent('gangs:settings')
AddEventHandler('gangs:settings', function(data, gang)
    Settings = data
    currentGang = gang
    
    if Settings then
        CreateThread(function()
            while true do
		local drawLocation = false
                local letSleep = true
                local gang = Settings.Gangs[currentGang.name]
                if gang and currentGang.name ~= "none" then
                    local plyPed = PlayerPedId()
                    local plyLocation = GetEntityCoords(plyPed)
                
                    for location, coords in pairs(gang['locations']) do
                        local locationData = Settings.Locations[location]
                        if locationData ~= nil then
                            local locationDist = Vdist(plyLocation, coords)
                            if locationDist < 5 then
                                letSleep = false
				DrawMarker(2, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, gang.color[1], gang.color[2], gang.color[3], 155, false, false, false, true, false, false, false)
				if locationDist < 2.5 then
					drawLocation = true
                                	currentLocation = locationData['event']
                                	DrawText3Ds(coords, locationData['help'])
				end
                            end
                        end
                    end
                end
        
                if not drawLocation then
                    currentLocation = nil
                end
        
                Wait(letSleep == true and 1000 or 1)
            end
        end)
    else
        --print("Failed to load settings table.")
    end
end)

RegisterCommand("+gangsPress", function()
    if currentLocation and not menuActive then
        TriggerEvent(currentLocation, currentGang.name, currentGang.grade)
    end
end)

RegisterNetEvent("gangs:requestOpenBoss")
AddEventHandler("gangs:requestOpenBoss", function(gang)
    menuActive = true
    TriggerServerEvent("gangs:refreshMoney")
    TriggerServerEvent("gangs:refreshMembers")

    local gang = Settings.Gangs[currentGang.name]
    local grades = {}
    local xIndex = Settings.Grades[currentGang.grade]

    for grade, index in pairs(Settings.Grades) do
        if (not xIndex or not index or index < xIndex) and index ~= 0 then
            grades[#grades+1] = grade
        end
    end

    SetNuiFocus(menuActive, menuActive)
    SendNUIMessage({
        ['menu'] = "management",
        ['grades'] = grades,
        ['isBoss'] = currentGang.grade == "boss" or currentGang.grade == "underboss",
        ['label'] = gang['label'],
        ['color'] = gang['color']
    })
end)

RegisterNetEvent("gangs:refreshMembers")
AddEventHandler("gangs:refreshMembers", function(members)
    SendNUIMessage({
        ['members'] = members,
    })
    RefreshNearbyPlayers()
end)

RegisterNetEvent("gangs:openStash")
AddEventHandler("gangs:openStash", function(gang)
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", gang, {
        maxweight = 4000000,
        slots = 500,
    })
    TriggerEvent("pepe-inventory:client:SetCurrentStash", gang)
end)

RegisterNetEvent("gangs:refreshNearby")
AddEventHandler("gangs:refreshNearby", function(members)
    SendNUIMessage({
        ['nearby'] = members
    })
end)

RegisterNetEvent("gangs:refreshMoney")
AddEventHandler("gangs:refreshMoney", function(gang, money)
    if currentGang.name == gang then
        SendNUIMessage({
            ['money'] = money
        })
    end
end)

RegisterNetEvent("gangs:vehiclesMenu")
AddEventHandler("gangs:vehiclesMenu", function(gang, money)
    menuActive = true
    SetNuiFocus(menuActive, menuActive)

    local items = Settings.Gangs[gang]['vehicles']
    if IsPedInAnyVehicle(PlayerPedId()) then
        items = {{ model = "store", label = "Store vehicle", icon = "fas fa-history" }}
    end

    SendNUIMessage({
        ['menu'] = "vehicles",
        ['vehicles'] = items
    })
end)

function DrawText3Ds(coords, text)

    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function RefreshNearbyPlayers()
    local players = Framework.Functions.GetPlayersFromCoords()
    local ready = {}

    for i=1, #players do
        local player = players[i]
        local serverID = GetPlayerServerId(player)
        ready[#ready+1] = serverID
    end

    TriggerServerEvent("gangs:refreshNearby", ready)
end

RegisterNUICallback("message", function(data)
    local action = data.action
    if action == "close" then
        menuActive = false
        SetNuiFocus(menuActive, menuActive)
        TriggerServerEvent("gangs:saveMoney")
    elseif action == "update_grade" then
        TriggerServerEvent("gangs:updateGrade", data.member, data.grade)
    elseif action == "withdraw" then
        local amount = tonumber(data.amount)
        if amount and amount > 0 then
            TriggerServerEvent("gangs:withdraw", amount)
        end
    elseif action == "deposit" then
        local amount = tonumber(data.amount)
        if amount and amount > 0 then
            TriggerServerEvent("gangs:deposit", amount)
        end
    elseif action == "spawn_vehicle" then
        if data.model == "store" then
            DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
        else
            --print(Settings)
            Framework.Functions.SpawnVehicle(data.model, function(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
 
                exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
               -- exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100.0, false)
                local color = Settings.Gangs[currentGang.name].color
                SetVehicleCustomPrimaryColour(vehicle, color[1], color[2] , color[3])
                SetVehicleCustomSecondaryColour(vehicle, color[1], color[2] , color[3])
                SetVehicleDirtLevel(vehicle, 0.0)
            end)
        end
    end
end)

RegisterNetEvent("gangs:notify")
AddEventHandler("gangs:notify", function(icon, label, gang)
    if gang and gang ~= currentGang.name then
        return false
    end

    SendNUIMessage({
        ['alert'] = {
            ['icon'] = "fas fa-user",
            ['label'] = label
        }
    })
end)

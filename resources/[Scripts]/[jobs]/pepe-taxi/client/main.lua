Framework = nil
local PlayerData = nil
local PlayerJob = nil
local onDuty = false
Citizen.CreateThread(function()
	while Framework == nil do
		TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
		Citizen.Wait(200)
	end

	-- while Framework.Functions.GetPlayerData() == nil do
	-- 	Wait(0)
	-- end

	-- while Framework.Functions.GetPlayerData().job == nil do
	-- 	Wait(0)
	-- end

	-- PlayerData = Framework.Functions.GetPlayerData()
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(450)
      Framework.Functions.GetPlayerData(function(PlayerData)
      PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
      isLoggedIn = true 
      end)
    end)
end)
-- RegisterNetEvent('Framework:Client:OnJobUpdate')
-- AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
--     PlayerData.job = JobInfo
-- end)
RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(Onduty)
 onDuty = Onduty
end)

-- Code

local isLoggedIn = false
local PlayerData = {}

local meterIsOpen = false

local meterActive = false
local currentTaxi = nil

local lastLocation = nil

local meterData = {
    fareAmount = 3,
    currentFare = 0,
    distanceTraveled = 0,
}

local dutyPlate = nil

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 180
}
-- function TimeoutNpc()
--     Citizen.CreateThread(function()
--         while NpcData.CountDown ~= 0 do
--             NpcData.CountDown = NpcData.CountDown - 1
--             Citizen.Wait(1000)
--         end
--         NpcData.CountDown = 180
--     end)
-- end

RegisterNetEvent('pepe-taxi:client:DoTaxiNpc')
AddEventHandler('pepe-taxi:client:DoTaxiNpc', function()
    if whitelistedVehicle() then
        --if NpcData.CountDown == 50 then
            if not NpcData.Active then
                NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.TakeLocations)
                if NpcData.LastNpc ~= nil then
                    while NpcData.LastNpc ~= NpcData.CurrentNpc do
                        NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.TakeLocations)
                    end
                end

                local Gender = math.random(1, #Config.NpcSkins)
                local PedSkin = math.random(1, #Config.NpcSkins[Gender])
                local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                NpcData.Npc = CreatePed(3, model, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z - 0.98, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].h, false, true)
                PlaceObjectOnGroundProperly(NpcData.Npc)
                FreezeEntityPosition(NpcData.Npc, true)
                if NpcData.NpcBlip ~= nil then
                    RemoveBlip(NpcData.NpcBlip)
                end
                Framework.Functions.Notify(_U("gpsset"), 'success')
                NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z)
                SetBlipColour(NpcData.NpcBlip, 3)
                SetBlipRoute(NpcData.NpcBlip, true)
                SetBlipRouteColour(NpcData.NpcBlip, 3)
                NpcData.LastNpc = NpcData.CurrentNpc
                NpcData.Active = true

                Citizen.CreateThread(function()
                    while not NpcData.NpcTaken do

                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local dist = GetDistanceBetweenCoords(pos, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, true)

                        if dist < 20 then
                            DrawMarker(2, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        
                            if dist < 5 then
                                local npccoords = GetEntityCoords(NpcData.Npc)
                                Framework.Functions.DrawText3D(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, '[E] NPC calls')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    local veh = GetVehiclePedIsIn(ped, 0)
                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                                    for i=maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(vehicle, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end

                                    meterIsOpen = true
                                    meterActive = true
                                    lastLocation = GetEntityCoords(PlayerPedId())
                                    SendNUIMessage({
                                        action = "openMeter",
                                        toggle = true,
                                        meterData = Config.Meter
                                    })
                                    SendNUIMessage({
                                        action = "toggleMeter"
                                    })

                                    ClearPedTasks(NpcData.Npc)
                                    FreezeEntityPosition(NpcData.Npc, false)
                                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                    Framework.Functions.Notify(_U("deliverlocation"))
                                    if NpcData.NpcBlip ~= nil then
                                        RemoveBlip(NpcData.NpcBlip)
                                    end
                                    GetDeliveryLocation()
                                    NpcData.NpcTaken = true
                                end
                            end
                        end

                        Citizen.Wait(1)
                    end
                end)
            else
                Framework.Functions.Notify(_U("alreadydriven"))
            end
        --else
        --    Framework.Functions.Notify(_U("nocstumes"))
        --end
    else
        Framework.Functions.Notify(_U("notaxicab"))
    end
end)

function GetDeliveryLocation()
    NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DeliverLocations)
    if NpcData.LastDeliver ~= nil then
        while NpcData.LastDeliver ~= NpcData.CurrentDeliver do
            NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DeliverLocations)
        end
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = NpcData.CurrentDeliver

    Citizen.CreateThread(function()
        while true do

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, true)

            if dist < 20 then
                DrawMarker(2, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            
                if dist < 5 then
                    local npccoords = GetEntityCoords(NpcData.Npc)
                    Framework.Functions.DrawText3D(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, '[E] NPC deliver')
                    if IsControlJustPressed(0, Keys["E"]) then
                        local veh = GetVehiclePedIsIn(ped, 0)
                        TaskLeaveVehicle(NpcData.Npc, veh, 0)
                        SetEntityAsMissionEntity(NpcData.Npc, false, true)
                        SetEntityAsNoLongerNeeded(NpcData.Npc)
                        local targetCoords = Config.NPCLocations.TakeLocations[NpcData.LastNpc]
                        TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                        SendNUIMessage({
                            action = "toggleMeter"
                        })
                        TriggerServerEvent('pepe-taxi:server:NpcPay', meterData.currentFare)
                        Framework.Functions.Notify(_U("customerarrived"), 'success')
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        local RemovePed = function(ped)
                            SetTimeout(60000, function()
                                DeletePed(ped)
                            end)
                        end
                        --TimeoutNpc()
                        RemovePed(NpcData.Npc)
                        ResetNpcTask()
                        break
                    end
                end
            end

            Citizen.Wait(1)
        end
    end)
end

function ResetNpcTask()
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
end

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = Framework.Functions.GetPlayerData()
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        calculateFareAmount()
    end
end)

function calculateFareAmount()
    if meterIsOpen and meterActive then
        start = lastLocation
        if start then
            current = GetEntityCoords(PlayerPedId())
            distance = CalculateTravelDistanceBetweenPoints(start, current)
            meterData['distanceTraveled'] = distance
    
            fareAmount = (meterData['distanceTraveled'] / 400.00) * meterData['fareAmount']
    
            meterData['currentFare'] = math.ceil(fareAmount)

            SendNUIMessage({
                action = "updateMeter",
                meterData = meterData
            })
        end
    end
end

Citizen.CreateThread(function()
    while true do

        inRange = false

        if Framework ~= nil then
            if isLoggedIn then

                if PlayerData.job.name == "taxi" then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)

                    local vehDist = GetDistanceBetweenCoords(pos, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

                    if vehDist < 5 then
                        inRange = true

                        DrawMarker(2, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"], 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if vehDist < 1.5 then
                            if whitelistedVehicle() then
                                Framework.Functions.DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, _U("epark"))
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    end
                                end
                            else
                                Framework.Functions.DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, _U("evehicles"))
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TaxiGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end
                    end

                    local BossDist = GetDistanceBetweenCoords(pos, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"])

                    if BossDist < 3 then
                        inRange = true

                        DrawMarker(2, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"], 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if BossDist < 1.5 and PlayerData.job.isboss then
                                Framework.Functions.DrawText3D(Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"] + 0.3, _U("ebossmenu"))
                                if IsControlJustReleased(0, Keys["E"]) then

                                    TriggerServerEvent("pepe-bossmenu:server:openMenu")

                                end
                        end
                    end

                    
                    local StashDist = GetDistanceBetweenCoords(pos, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"])

                    if StashDist < 3 then
                        inRange = true

                        DrawMarker(2, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"], 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if StashDist < 1.5 then
                                Framework.Functions.DrawText3D(Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"] + 0.3, _U("estash"))
                                if IsControlJustReleased(0, Keys["E"]) then

                                    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "taxi")
                                    TriggerEvent("pepe-inventory:client:SetCurrentStash", "taxi")

                                end
                        end
                    end
                    local DutyDist = GetDistanceBetweenCoords(pos, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"])

                    if DutyDist < 3 then
                        inRange = true
                        if DutyDist < 1.5 then
                            DrawMarker(2, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                            if not onDuty then
                                Framework.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, _U("induty"))
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TriggerServerEvent("Framework:ToggleDuty", true)
                                end
                            else
                                Framework.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, _U("offduty"))
                                if IsControlJustReleased(0, Config.Keys['E']) then
                                    TriggerServerEvent("Framework:ToggleDuty", false)
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(3000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('pepe-taxi:client:toggleMeter')
AddEventHandler('pepe-taxi:client:toggleMeter', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        if whitelistedVehicle() then
            if not meterIsOpen then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    meterData = Config.Meter
                })
                meterIsOpen = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                meterIsOpen = false
            end
        else
            Framework.Functions.Notify(_U("notaximeter"), 'error')
        end
    else
        Framework.Functions.Notify(_U("notinvehicle"), 'error')
    end
end)

RegisterNetEvent('pepe-taxi:client:enableMeter')
AddEventHandler('pepe-taxi:client:enableMeter', function()
    local ped = PlayerPedId()

    if meterIsOpen then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        Framework.Functions.Notify(_U("meternotactive"), 'error')
    end
end)

RegisterNUICallback('enableMeter', function(data)
    meterActive = data.enabled

    if not data.enabled then
        SendNUIMessage({
            action = "resetMeter"
        })
    end
    lastLocation = GetEntityCoords(PlayerPedId())
end)

RegisterNetEvent('pepe-taxi:client:toggleMuis')
AddEventHandler('pepe-taxi:client:toggleMuis', function()
    Citizen.Wait(400)
    if meterIsOpen then
        if not mouseActive then
            SetNuiFocus(true, true)
            mouseActive = true
        end
    else
        Framework.Functions.Notify(_U("meternotactive"), 'error')
    end
end)

RegisterNUICallback('hideMouse', function()
    SetNuiFocus(false, false)
    mouseActive = false
end)

function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    return retval
end

function TaxiGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList()
    ped = PlayerPedId();
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Config.AllowedVehicles) do
        Menu.addButton(Config.AllowedVehicles[k].label, "TakeVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Return", "TaxiGarage",nil)
end

function TakeVehicle(k)
    local coords = {x = Config.Locations["vehicle"]["x"], y = Config.Locations["vehicle"]["y"], z = Config.Locations["vehicle"]["z"]}
    Framework.Functions.SpawnVehicle(Config.AllowedVehicles[k].model, function(veh)
        SetVehicleNumberPlateText(veh, "TAXI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Config.Locations["vehicle"]["h"])
        closeMenuFull()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
        exports['pepe-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
        SetVehicleEngineOn(veh, true, true)
        dutyPlate = GetVehicleNumberPlateText(veh)
        SetVehicleExtra(veh, 2, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end
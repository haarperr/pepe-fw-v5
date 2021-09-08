Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Framework = nil
isLoggedIn = false
onDuty = false

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)
PlayerJob = {}

--- CODE

local inVehicleShop = false

vehicleCategorys = {
    ["coupes"] = {
        label = "Coupes",
        vehicles = {}
    },
    ["sedans"] = {
        label = "Sedans",
        vehicles = {}
    },
    ["muscle"] = {
        label = "Muscle",
        vehicles = {}
    },
    ["suvs"] = {
        label = "SUVs",
        vehicles = {}
    },
    ["compacts"] = {
        label = "Compacts",
        vehicles = {}
    },
    ["vans"] = {
        label = "Vans",
        vehicles = {}
    },
    ["super"] = {
        label = "Super",
        vehicles = {}
    },
    ["sports"] = {
        label = "Sports",
        vehicles = {}
    },
    ["sportsclassics"] = {
        label = "Sports Classics",
        vehicles = {}
    },
    ["motorcycles"] = {
        label = "Motorcycles",
        vehicles = {}
    },
    ["offroad"] = {
        label = "Offroad",
        vehicles = {}
    },
}

-- RegisterNetEvent('Framework:Client:OnPlayerLoaded')
-- AddEventHandler('Framework:Client:OnPlayerLoaded', function()
--     Framework.Functions.GetPlayerData(function(PlayerData)
--         PlayerJob = PlayerData.job
--     end)
--     isLoggedIn = true
-- end)

-- RegisterNetEvent('Framework:Client:OnJobUpdate')
-- AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
--     PlayerJob = JobInfo
-- end)

-- RegisterNetEvent('Framework:Client:SetDuty')
-- AddEventHandler('Framework:Client:SetDuty', function(Onduty)
--  onDuty = Onduty
-- end)



-- RegisterNetEvent('Framework:Client:OnPlayerLoaded')
-- AddEventHandler('Framework:Client:OnPlayerLoaded', function()
--     Citizen.SetTimeout(500, function()
--      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
--       Citizen.Wait(450)
--       Framework.Functions.GetPlayerData(function(PlayerData)
--       PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
--       isLoggedIn = true 
--       end)
      
-- 	PlayerData = Framework.Functions.GetPlayerData()
--     end)
-- end)

-- RegisterNetEvent('Framework:Client:OnPlayerLoaded')
-- AddEventHandler('Framework:Client:OnPlayerLoaded', function()
--     Citizen.SetTimeout(500, function()
--      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
--       Citizen.Wait(450)
--       Framework.Functions.GetPlayerData(function(PlayerData)
--       PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
--       isLoggedIn = true 
--       end)
--     end)
-- end)


RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
    TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
      Framework.Functions.GetPlayerData(function(PlayerData)
        PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
        isLoggedIn = true 
         onDuty = PlayerData.job.onduty
     end)
    end) 
end)

RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(Onduty)
 onDuty = Onduty
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(Framework.Shared.Vehicles) do
        if v["shop"] == "pdm" then
            for cat,_ in pairs(vehicleCategorys) do
                if Framework.Shared.Vehicles[k]["category"] == cat then
                    table.insert(vehicleCategorys[cat].vehicles, Framework.Shared.Vehicles[k])
                end
            end
        end
    end
end)

function openVehicleShop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        ui = bool
    })
end

function setupVehicles(vehs)
    SendNUIMessage({
        action = "setupVehicles",
        vehicles = vehs
    })
end

RegisterNUICallback('GetCategoryVehicles', function(data)
    setupVehicles(shopVehicles[data.selectedCategory])
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)

RegisterNUICallback('buyVehicle', function(data)
    local vehicleData = data.vehicleData
    local garage = data.garage

    TriggerServerEvent('pepe-vehicleshop:server:buyVehicle', vehicleData, garage)
    openVehicleShop(false)
end)

RegisterNetEvent('pepe-vehicleshop:client:spawnBoughtVehicle')
AddEventHandler('pepe-vehicleshop:client:spawnBoughtVehicle', function(vehicle)
    Framework.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, Pepe.SpawnPoint.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    end, Pepe.SpawnPoint, true)
end)


Citizen.CreateThread(function()
    while true do

        inRange = false

        if Framework ~= nil then
            if isLoggedIn then
                
            if (PlayerJob ~= nil) and PlayerJob.name == "cardealer" then
                    local ped = GetPlayerPed(-1)
                    local pos = GetEntityCoords(ped)

                    local BossDist = GetDistanceBetweenCoords(pos, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"])

                    if BossDist < 3 then
                        inRange = true

                        DrawMarker(2, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, true, false, false, false)

                        if BossDist < 1.5 then
                            Framework.Functions.DrawText3D(Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"] + 0.3, "Boss")
                                if IsControlJustReleased(0, Keys["E"]) then

                                    TriggerServerEvent("pepe-bossmenu:server:openMenu")

                                end
                        end
                    end

                    
                    local StashDist = GetDistanceBetweenCoords(pos, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"])

                    if StashDist < 3 then
                        inRange = true

                        DrawMarker(2, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, true, false, false, false)

                        if StashDist < 1.5 then
                                Framework.Functions.DrawText3D(Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"] + 0.3, "Closet")
                                if IsControlJustReleased(0, Keys["E"]) then

                                    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "cardealer")
                                    TriggerEvent("pepe-inventory:client:SetCurrentStash", "cardealer")

                                end
                        end
                    end
                    local DutyDist = GetDistanceBetweenCoords(pos, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"])

                    if DutyDist < 3 then
                        inRange = true
                        if DutyDist < 1.5 then
                            DrawMarker(2, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                            if not onDuty then
                                Framework.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, "Enter Duty")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TriggerServerEvent("Framework:ToggleDuty", true)
                                end
                            else
                                Framework.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, "Leave Duty")
                                if IsControlJustReleased(0, Keys['E']) then
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




-- Citizen.CreateThread(function()
--     for k, v in pairs(Pepe.VehicleShops) do
--         Dealer = AddBlipForCoord(Pepe.VehicleShops[k].x, Pepe.VehicleShops[k].y, Pepe.VehicleShops[k].z)

--         SetBlipSprite (Dealer, 326)
--         SetBlipDisplay(Dealer, 4)
--         SetBlipScale  (Dealer, 0.75)
--         SetBlipAsShortRange(Dealer, true)
--         SetBlipColour(Dealer, 3)

--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentSubstringPlayerName("Premium Deluxe Motorsports")
--         EndTextCommandSetBlipName(Dealer)
--     end
-- end)

-- Citizen.CreateThread(function()
--     QuickSell = AddBlipForCoord(Pepe.QuickSell.x, Pepe.QuickSell.y, Pepe.QuickSell.z)

--     SetBlipSprite (QuickSell, 108)
--     SetBlipDisplay(QuickSell, 4)
--     SetBlipScale  (QuickSell, 0.55)
--     SetBlipAsShortRange(QuickSell, true)
--     SetBlipColour(QuickSell, 3)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentSubstringPlayerName("PDM Quick Sell")
--     EndTextCommandSetBlipName(QuickSell)
-- end)
local CurrentShownPlants = {}
local Framework =  nil
local CurrentHouse = nil
local LoggedIn = false
local NearPlant = false
local PlacedPlant = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)
      Citizen.Wait(150)
      Framework.Functions.TriggerCallback('pepe-houseplants:server:get:config', function(ConfigData)
        Config = ConfigData
      end)
      LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    UnloadHousePlants()
    Citizen.SetTimeout(150, function()
        CurrentHouse = nil
        NearPlant = false
        LoggedIn = false
    end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
        if CurrentHouse ~= nil then
            if Config.Plants[CurrentHouse] ~= nil then
                NearPlant = false
                if PlacedPlant then
                    for k, v in pairs(Config.Plants[CurrentHouse]) do
                        local PlayerCoords = GetEntityCoords(PlayerPedId())
                        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                        if Distance < 0.8 then
                            NearPlant = true
                            ClosestPlant = k
                            if v['Gender'] == 'Man' then
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '| [~g~'..v['Name']..'~s~] | [~b~Male~s~] | [~r~Nutrition:~s~ '..v['Food'].. '%] | [~r~Health:~s~ '..v['Health']..'%] |')
                            else
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '| [~g~'..v['Name']..'~s~] | [~p~Female~s~] | [~r~Nutrition:~s~ '..v['Food'].. '%] | [~r~Health:~s~ '..v['Health']..'%] |')
                            end
                            if v['Health'] == 0 then
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] - 0.075, '~g~E~s~ - Destroy')
                                if IsControlJustReleased(0, 38) then
                                    DestroyDeadPlant(k)
                                end
                            elseif v['Progress'] >= 100 then
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] - 0.075, '~g~E~s~ - Harvest')
                                if IsControlJustReleased(0, 38) then
                                    PickSelectedPlant(k)
                                end
                            end
                        end
                    end
                end
                if not NearPlant then
                    Citizen.Wait(1500)
                    ClosestPlant = nil
                end
            end
        end
    end
end)

RegisterNetEvent('pepe-houseplants:client:sync:plant:data')
AddEventHandler('pepe-houseplants:client:sync:plant:data', function(ConfigData)
    Config.Plants = ConfigData
end)

RegisterNetEvent('pepe-houseplants:client:sync:plants')
AddEventHandler('pepe-houseplants:client:sync:plants', function(HouseId)
    if CurrentHouse ~= nil then
        if CurrentHouse == HouseId then
            PlacedPlant = false
            for k, v in pairs(CurrentShownPlants) do
                DeleteEntity(v)
                Citizen.Wait(50)
            end
            CurrentShownPlants = {}
            Citizen.SetTimeout(750, function()
                LoadHousePlants(CurrentHouse)
            end)
        end
    end
end)

RegisterNetEvent('pepe-houseplants:client:feed:plants')
AddEventHandler('pepe-houseplants:client:feed:plants', function()
    if CurrentHouse ~= nil then
        if ClosestPlant ~= nil then
            if Config.Plants[CurrentHouse][ClosestPlant]['Food'] < 100 then
                FeedSelectedPlant(ClosestPlant)
            else
                Framework.Functions.Notify("You trying to drown this plant or what..", "error")
            end 
        else
            Framework.Functions.Notify("No plant to water..", "error")
        end
    else
        Framework.Functions.Notify("Are you even in a house?", "error")
    end
end)

RegisterNetEvent('pepe-houseplants:client:plant')
AddEventHandler('pepe-houseplants:client:plant', function(PlantName, PlantType, ItemName)
    if CurrentHouse ~= nil then
        if ClosestPlant == nil then
            PlantPlantHere(PlantName, PlantType, ItemName)
        else
            Framework.Functions.Notify("No space available", "error")
        end
    else
        Framework.Functions.Notify("Are you even in a house?", "error")
    end
end)

function PlantPlantHere(PlantName, PlantType, ItemName)
    TriggerEvent('pepe-inventory:client:set:busy', true)
    Framework.Functions.Progressbar("plant-weed", "Planting..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        AddPlant(PlantName, PlantType, ItemName)
        TriggerEvent('pepe-inventory:client:set:busy', false)
        TriggerServerEvent('Framework:Server:RemoveItem', ItemName, 1)
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
        StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        TriggerEvent('pepe-inventory:client:set:busy', false)
        StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        Framework.Functions.Notify("Canceled..", "error")
    end)
end

function PickSelectedPlant(PlantId)
    Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
        if HasItem then
            Framework.Functions.Progressbar("pick-weed", "Harvesting..", 10000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@world_human_gardener_plant@male@base",
                anim = "base",
                flags = 16,
            }, {}, {}, function() -- Done
                TriggerServerEvent('pepe-houseplants:server:harvest:plant', CurrentHouse, PlantId, math.random(1, 5))
                StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end, function()
                StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                Framework.Functions.Notify("Canceled..", "error")
            end)
        else
            Framework.Functions.Notify("You are missing something..", "error")
        end
      end, 'plastic-bag')
end

function DestroyDeadPlant(PlantId)
    Framework.Functions.Progressbar("destroy-weed", "Destroying..", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        TriggerServerEvent('pepe-houseplants:server:destroy:plant', CurrentHouse, PlantId, true)
    end, function()
        StopAnimTask(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        Framework.Functions.Notify("Canceled..", "error")
    end)
end

function FeedSelectedPlant(PlantId)
    exports['pepe-assets']:RequestAnimationDict("weapon@w_sp_jerrycan")
    TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    Framework.Functions.Progressbar("feed-weed", "Fertilising.", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('pepe-houseplants:server:feed:plant', CurrentHouse, PlantId)
        StopAnimTask(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        StopAnimTask(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        Framework.Functions.Notify("Canceled..", "error")
    end)
end

function LoadHousePlants(HouseId)
    CurrentHouse = HouseId
    if not PlacedPlant then
       PlacedPlant = true
       Citizen.SetTimeout(650, function()
           if Config.Plants[CurrentHouse] ~= nil then
               for k, v in pairs(Config.Plants[CurrentHouse]) do
                 PlantObject = CreateObject(GetHashKey(Config.StageProps[v["Stage"]]), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
                 SetEntityAsMissionEntity(PlantObject, false, false)
                 FreezeEntityPosition(PlantObject, true)
                 PlaceObjectOnGroundProperly(PlantObject)
                 Citizen.Wait(20)
                 PlaceObjectOnGroundProperly(PlantObject)
                 table.insert(CurrentShownPlants, PlantObject)
                 Citizen.Wait(50)
               end
           end
       end)
    end
 end
  
function UnloadHousePlants()
    if PlacedPlant then
        PlacedPlant = false
        CurrentHouse = nil
        for k, v in pairs(CurrentShownPlants) do
            DeleteEntity(v)
            Citizen.Wait(50)
        end
        CurrentShownPlants = {}
    end
end

function AddPlant(PlantName, PlantType)
    local PlayerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0) GetEntityCoords(PlayerPedId())
    local RandomNum = math.random(1, 2)
    local Gender = 'Man'
    if RandomNum == 2 then Gender = 'Vrouw' end
    if CurrentHouse ~= nil then
        if Config.Plants[CurrentHouse] ~= nil then
            local Data = {['Name'] = PlantName, ['PlantId'] = math.random(1111,9999), ['Stage'] = 'Stage-A', ['Sort'] = PlantType, ['Gender'] = Gender, ['Food'] = 100, ['Health'] = 100, ['Progress'] = 0, ['SpeedMultiplier'] = 1, ['Coords'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}}
            table.insert(Config.Plants[CurrentHouse], Data)
            TriggerServerEvent('pepe-houseplants:server:add:plant', CurrentHouse, Config.Plants[CurrentHouse])
        else
            Config.Plants[CurrentHouse] = {[1] = {['Name'] = PlantName, ['PlantId'] = math.random(1111,9999), ['Stage'] = 'Stage-A', ['Sort'] = PlantType, ['Gender'] = Gender, ['Food'] = 100, ['Health'] = 100, ['Progress'] = 0, ['SpeedMultiplier'] = 1, ['Coords'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}}}
            TriggerServerEvent('pepe-houseplants:server:add:plant', CurrentHouse, Config.Plants[CurrentHouse])
        end
    end
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.30, 0.30)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end
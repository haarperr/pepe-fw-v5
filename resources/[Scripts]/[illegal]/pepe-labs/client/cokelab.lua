local NearAction = false
local CokeCrafting = {['X'] = 1093.03, ['Y'] = -3196.56, ['Z'] = -38.99}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAction = false
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Cokelab' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], true)
                if Distance < 2.0 then
                    NearAction = true
                    DrawText3D(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'] + 0.1, '~g~E~s~ - Action')
                    DrawMarker(2, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        local CokeLab = {}
                         CokeLab.label = "Cocaine Lab"
                         CokeLab.items = Config.Labs[CurrentLab]['Inventory']
                         CokeLab.slots = 2
                        TriggerServerEvent("pepe-inventory:server:OpenInventory", "lab", CurrentLab, CokeLab)
                    end
                end
                if not NearAction then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Cokelab' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CokeCrafting['X'], CokeCrafting['Y'], CokeCrafting['Z'], true)
                NearCraft = false
                if Distance < 1.2 then
                    NearCraft = true
                    DrawText3D(CokeCrafting['X'], CokeCrafting['Y'], CokeCrafting['Z'] + 0.1, '~g~E~s~ - Process')
                    DrawMarker(2, CokeCrafting['X'], CokeCrafting['Y'], CokeCrafting['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        local CokeCrafting = {}
		    			CokeCrafting.label = "Processing"
		    			CokeCrafting.items = GetCokeCraftingItems()
                        TriggerServerEvent('pepe-inventory:server:set:inventory:disabled', true)
		    			TriggerServerEvent("pepe-inventory:server:OpenInventory", "cokecrafting", math.random(1, 99), CokeCrafting)
                    end
                end
                if not NearCraft then
                    Citizen.Wait(1500)
                end
            end
        end
    end
end)

RegisterNetEvent('pepe-illegal:client:start:burner-call')
AddEventHandler('pepe-illegal:client:start:burner-call', function()
    if not DoingSomething then
        DoingSomething = true
        local RandomObjective = {}
        local RandomValue = math.random(1, 4)
        local RandomAmount = math.random(1, 2)
        local RandomItem = {[1] = 'meth-ingredient-2', [2] = 'packed-coke-brick', [3] = 'money-paper'}
        local RandomName = {[1] = 'Joke', [2] = 'Marc', [3] = 'Valentino', [4] = 'Montana', [5] = 'Keith', [6] = 'Tyrone', [7] = 'Cor', [8] = 'Steven'}
        Citizen.SetTimeout(1250, function()
            TriggerEvent('pepe-inventory:client:set:busy', true)
            exports['pepe-assets']:RequestAnimationDict("cellphone@")
            TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_text_to_call', 3.0, 3.0, -1, 50, 0, false, false, false)
            local Time = 5
            repeat
              Time = Time -1
              TriggerEvent("pepe-sound:client:play", "death", 0.2)
              Citizen.Wait(3500)
            until Time == 0
            if RandomValue == 1 then
                TriggerEvent("pepe-sound:client:play", "call-1", 0.5) 
            elseif RandomValue == 2 then
                TriggerEvent("pepe-sound:client:play", "call-1", 0.5) 
            elseif RandomValue == 3 then
                TriggerEvent("pepe-sound:client:play", "call-1", 0.5) 
            elseif RandomValue == 4 then
                TriggerEvent("pepe-sound:client:play", "call-1", 0.5) 
            end
            Citizen.SetTimeout(14000, function()
                RandomObjective = Config.RandomLocation[math.random(1, #Config.RandomLocation)]
                RandomObjective['Name'] = RandomName[math.random(1, #RandomName)]
                RandomObjective['Amount'] = RandomAmount
                RandomObjective['ItemName'] = RandomItem[math.random(1, #RandomItem)]
                TriggerServerEvent('Framework:Server:RemoveItem', 'burner-phone', 1)
                TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['burner-phone'], "remove")
                TriggerServerEvent('pepe-phone:server:sendNewMail', {
                    sender = RandomObjective['Name'],
                    subject = "Location",
                    message = "Here is all the information about your order, <br><br>Location: <b>"..RandomObjective["Street"].."</b><br>Order: <b>"..RandomObjective['Amount'].."x</b><br><br> Come alone, and hurry up a bit! <br><br>See u soon,<br><br><b>"..RandomObjective['Name']..'</b>',
                    button = {
                        enabled = true,
                        buttonEvent = "pepe-illegal:client:start:pickup:coke",
                        buttonData = RandomObjective
                    }
                })
                TriggerEvent('pepe-inventory:client:set:busy', false)
                ClearPedTasks(PlayerPedId())
            end)
        end)
    end
end)

RegisterNetEvent('pepe-illegal:client:start:pickup:coke')
AddEventHandler('pepe-illegal:client:start:pickup:coke', function(PickupData)
    local DoingJob = true
    local JobData = PickupData
    SetNewWaypoint(JobData['Coords']['X'], JobData['Coords']['Y'])
    while DoingJob do
        Citizen.Wait(4)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local Distance = GetDistanceBetweenCoords(PlayerCoords, JobData['Coords']['X'], JobData['Coords']['Y'], JobData['Coords']['Z'], true)
        if Distance <= 2.0 then
            DrawText3D(JobData['Coords']['X'], JobData['Coords']['Y'], JobData['Coords']['Z'] + 0.1, '~g~E~s~ - Order')
            DrawMarker(2, JobData['Coords']['X'], JobData['Coords']['Y'], JobData['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            if IsControlJustReleased(0, 38) then
                DoingJob = false
                local ItemShop = {label = JobData['Name'], slots = 1, items = {[1] = {name = JobData['ItemName'], price = 0, amount = JobData['Amount'], info = {}, type = "item", slot = 1}}}
                TriggerServerEvent("pepe-inventory:server:OpenInventory", "shop", "Cokebrick", ItemShop)
                DoingSomething = false
            end
        end
    end
end)

RegisterNetEvent('pepe-illegal:client:play:sound:coke')
AddEventHandler('pepe-illegal:client:play:sound:coke', function()
    if InsideLab and NearAction then
        TriggerEvent('pepe-sound:client:play', 'cutting', 0.4)
    end
end)

function GetCokeCraftingItems()
 local items = {}
 SetupCokeCrafting()
 for k, item in pairs(Config.CokeCrafting) do
     items[k] = Config.CokeCrafting[k]
 end
 return items
end
     
function SetupCokeCrafting()
 local items = {}
 for k, item in pairs(Config.CokeCrafting) do
     local itemInfo = Framework.Shared.Items[item.name:lower()]
     items[item.slot] = {
      name = itemInfo["name"],
      amount = tonumber(item.amount),
      info = item.info,
      label = itemInfo["label"],
      description = item.description,
      weight = itemInfo["weight"], 
      type = itemInfo["type"], 
      unique = itemInfo["unique"], 
      useable = itemInfo["useable"], 
      image = itemInfo["image"],
      slot = item.slot,
      costs = item.costs,
     }
 end
 Config.CokeCrafting = items
end
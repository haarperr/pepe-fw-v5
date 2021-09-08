local NearAction = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAction = false
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Money Printer' then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['ActionOne']['X'], Config.Labs[CurrentLab]['Coords']['ActionOne']['Y'], Config.Labs[CurrentLab]['Coords']['ActionOne']['Z'], true)
                if Distance < 2.0 then
                    NearAction = true
                    DrawText3D(Config.Labs[CurrentLab]['Coords']['ActionOne']['X'], Config.Labs[CurrentLab]['Coords']['ActionOne']['Y'], Config.Labs[CurrentLab]['Coords']['ActionOne']['Z'] + 0.1, 'Paper Stock: ~g~'..Config.Labs[CurrentLab]['Paper-Count']..'x\n~g~E~s~ - Add Paper')
                    if IsControlJustReleased(0, 38) then
                        FeedPaper()
                    end
                end

                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['ActionTwo']['X'], Config.Labs[CurrentLab]['Coords']['ActionTwo']['Y'], Config.Labs[CurrentLab]['Coords']['ActionTwo']['Z'], true)
                if Distance < 2.0 then
                    NearAction = true
                    DrawText3D(Config.Labs[CurrentLab]['Coords']['ActionTwo']['X'], Config.Labs[CurrentLab]['Coords']['ActionTwo']['Y'], Config.Labs[CurrentLab]['Coords']['ActionTwo']['Z'] + 0.1, 'Inkt Stock: ~g~'..Config.Labs[CurrentLab]['Inkt-Count']..'x\n~g~E~s~ - Add Ink')
                    if IsControlJustReleased(0, 38) then
                        FeedInkt()
                    end
                end

                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['ActionThree']['X'], Config.Labs[CurrentLab]['Coords']['ActionThree']['Y'], Config.Labs[CurrentLab]['Coords']['ActionThree']['Z'], true)
                if Distance < 2.0 then
                    NearAction = true
                    DrawText3D(Config.Labs[CurrentLab]['Coords']['ActionThree']['X'], Config.Labs[CurrentLab]['Coords']['ActionThree']['Y'], Config.Labs[CurrentLab]['Coords']['ActionThree']['Z'] + 0.1,  'Total Cash: ~g~$'..Config.Labs[CurrentLab]['Total-Money']..',-\n~g~E~s~ - Take Money')
                    if IsControlJustReleased(0, 38) then
                        GetTotalMoney()
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

function FeedPaper()
    Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
        if HasItem then
            TriggerServerEvent('Framework:Server:RemoveItem', 'money-paper', 1)
            TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['money-paper'], "remove")
            TriggerServerEvent('pepe-illegal:server:add:printer:item', CurrentLab, 'Paper-Count', 1)
        else
            Framework.Functions.Notify('Missing something..', 'error')
        end
    end, "money-paper")
end

function FeedInkt()
    Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
        if HasItem then
            TriggerServerEvent('Framework:Server:RemoveItem', 'money-inkt', 1)
            TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['money-inkt'], "remove")
            TriggerServerEvent('pepe-illegal:server:add:printer:item', CurrentLab, 'Inkt-Count', 1)
        else
            Framework.Functions.Notify('Missing something..', 'error')
        end
    end, "money-inkt")
end

function GetTotalMoney()
    if Config.Labs[CurrentLab]['Total-Money'] > 0 then
        TriggerServerEvent('pepe-illegal:server:get:money:printer:money')
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Config.Labs[3]['Paper-Count'] > 0 and Config.Labs[3]['Inkt-Count'] > 0 then
                TriggerServerEvent('pepe-illegal:server:remove:printer:item', CurrentLab, 'Inkt-Count', 1)
                TriggerServerEvent('pepe-illegal:server:remove:printer:item', CurrentLab, 'Paper-Count', 1)
                Citizen.Wait(60000)
                TriggerServerEvent('pepe-illegal:server:set:printer:money', CurrentLab, math.random(2500, 5000))
                Citizen.Wait(150)
            end
        end
    end
end)

RegisterNetEvent('pepe-illegal:client:sync:items')
AddEventHandler('pepe-illegal:client:sync:items', function(ItemType, ConfigData)
    Config.Labs[3][ItemType] = ConfigData
end)

RegisterNetEvent('pepe-illegal:client:sync:money')
AddEventHandler('pepe-illegal:client:sync:money', function(ConfigData)
    Config.Labs[3]['Total-Money'] = ConfigData
end)
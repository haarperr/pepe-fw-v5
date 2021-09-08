local InCornerZone = false
local HasNpcFound = false
local CurrentNpc = nil
local LastPed = {}

RegisterNetEvent('pepe-illegal:client:toggle:corner:selling')
AddEventHandler('pepe-illegal:client:toggle:corner:selling', function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.CornerSellingData['Coords']['X'], Config.CornerSellingData['Coords']['Y'], Config.CornerSellingData['Coords']['Z'], true)
    if Distance < 1250 then
        Framework.Functions.TriggerCallback('pepe-illegal:server:has:drugs', function(HasDrugs)
            if HasDrugs then
                if Config.IsCornerSelling then
                    CurrentNpc = nil
                    HasNpcFound = false
                    Config.IsCornerSelling = false
                    Framework.Functions.Notify('Corner Selling disabled..', 'error')
                elseif not Config.IsCornerSelling then
                    Config.IsCornerSelling = true
                    Framework.Functions.Notify('Corner Selling enabled..', 'success')
                end
            else
                CurrentNpc = nil
                HasNpcFound = false
                Config.IsCornerSelling = false
                Framework.Functions.Notify('You do not even have any drugs..', 'error')
            end
        end)
    else
        CurrentNpc = nil
        HasNpcFound = false
        Config.IsCornerSelling = false
        Framework.Functions.Notify('Too far away from location..', 'error')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if LoggedIn then
            if Config.IsCornerSelling then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.CornerSellingData['Coords']['X'], Config.CornerSellingData['Coords']['Y'], Config.CornerSellingData['Coords']['Z'], true)
                InCornerZone = false
                if Distance < 1250 then
                    InCornerZone = true
                    local ClosestNpcPed, ClosestNpcDistance = Framework.Functions.GetClosestPed(PlayerCoords, GetActiveServerPlayers())
                    if ClosestNpcPed ~= 0 and ClosestNpcDistance < 3.0 then
                        TryToSellToNpc(ClosestNpcPed, ClosestNpcDistance)
                        Citizen.Wait(45)
                    else
                        Citizen.Wait(450)
                    end
                end
                if not InCornerZone then
                    Citizen.Wait(1500)
                    if Config.IsCornerSelling then
                        Config.IsCornerSelling = false
                        CurrentNpc = nil
                        HasNpcFound = false
                        Framework.Functions.Notify('Corner Selling disabled, you are too far away from location..', 'error')
                    end
                end
            else
                Citizen.Wait(1500)
            end
        end
    end
end)

function TryToSellToNpc(NpcPed, NpcPedDistance)
    if not HasNpcFound then
        HasNpcFound = true
        for k, v in pairs(LastPed) do
            if v == NpcPed then
                HasNpcFound = false
                CurrentNpc = nil
                return
            end
        end
        while HasNpcFound do  
            Citizen.Wait(4)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local NpcPedCoords = GetEntityCoords(NpcPed)    
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, NpcPedCoords.x, NpcPedCoords.y, NpcPedCoords.z, true)    
            if Distance < 5.0 then
                SetEveryoneIgnorePlayer(PlayerId(), true)
                TaskGoStraightToCoord(NpcPed, PlayerCoords, 1.2, -1, 0.0, 0.0)
                TaskLookAtEntity(NpcPed, PlayerPedId(), 5500.0, 2048, 3)
                TaskTurnPedToFaceEntity(NpcPed, PlayerPedId(), 5500)
                CurrentNpc = NpcPed
                Citizen.Wait(50)
            else
                SetEveryoneIgnorePlayer(PlayerId(), false)
                Citizen.Wait(250)
                TaskSmartFleePed(NpcPed, PlayerPedId(), 100.0, 15000)
                table.insert(LastPed, NpcPed) 
                CurrentNpc = nil
                HasNpcFound = false
                Citizen.Wait(4)
            end
        end  
    end
end

RegisterNetEvent('pepe-illegal:client:sell:to:ped')
AddEventHandler('pepe-illegal:client:sell:to:ped', function()
    if CurrentNpc ~= nil and Config.IsCornerSelling then
        Framework.Functions.TriggerCallback('pepe-illegal:server:get:drugs:items', function(DrugsResult)
            local DrugItem = math.random(1, #DrugsResult)
            local DrugItemName = DrugsResult[DrugItem]['Item']
            local BagAmount = math.random(1, DrugsResult[DrugItem]['Amount'])
            local SuccesChance = math.random(1, 35)
            local ScamChance = math.random(1, 20)
            local RandomPrice = math.random(15, 24) * BagAmount + Config.SellDrugs[DrugItemName]['SellAMount']
            if BagAmount > 15 then
                BagAmount = math.random(9, 15)
            end
            if ScamChance == 20 then
                RandomPrice = math.random(3, 10) * BagAmount
            end
            if SuccesChance <= 30 then
                PlayAmbientSpeech1(CurrentNpc, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL")
                TaskStartScenarioInPlace(CurrentNpc, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
                HasOffer = true
                while HasOffer do
                    Citizen.Wait(0)
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local NpcPedCoords = GetEntityCoords(CurrentNpc)
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, NpcPedCoords.x, NpcPedCoords.y, NpcPedCoords.z, true)
                    if Distance < 2.0 then
                        DrawText3D(NpcPedCoords.x, NpcPedCoords.y, NpcPedCoords.z, '~g~E~w~ - '..BagAmount..'x '..Framework.Shared.Items[DrugItemName].label..' for ~g~$'..RandomPrice..'~s~? / ~g~H~w~ - Decline offer')
                    else
                        SetEveryoneIgnorePlayer(PlayerId(), false)
                        Citizen.Wait(250)
                        ClearPedTasks(CurrentNpc)
                        TaskSmartFleePed(CurrentNpc, PlayerPedId(), 100.0, 15000)
                        table.insert(LastPed, CurrentNpc) 
                        HasNpcFound = false
                        HasOffer = false
                        CurrentNpc = nil
                    end
                    if IsControlJustReleased(0, 74) then
                        SetEveryoneIgnorePlayer(PlayerId(), false)
                        Citizen.Wait(250)
                        TaskSmartFleePed(CurrentNpc, PlayerPedId(), 100.0, 15000)
                        table.insert(LastPed, CurrentNpc)
                        HasNpcFound = false
                        HasOffer = false
                        CurrentNpc = nil
                    end
                    if IsControlJustReleased(0, 38) then
                        HasOffer = false
                        SellNowToPed(RandomPrice, DrugItemName, BagAmount)
                    end
                end
            else
                HasOffer = false
                HasNpcFound = false
                TriggerServerEvent('pepe-police:server:alert:cornerselling', GetEntityCoords(CurrentNpc), Framework.Functions.GetStreetLabel())
                SetEveryoneIgnorePlayer(PlayerId(), false)
                Citizen.Wait(150)
                TaskSmartFleePed(CurrentNpc, PlayerPedId(), 100.0, 15000)
                table.insert(LastPed, CurrentNpc) 
                CurrentNpc = nil
            end
        end)
    else
        Framework.Functions.Notify('Corner selling is disabled...', 'error')
    end
end)

function SellNowToPed(Price, Item, Amount)
    FreezeEntityPosition(CurrentNpc, true)
    SetEveryoneIgnorePlayer(PlayerId(), true)
    TriggerEvent('pepe-inventory:client:set:busy', true)
    Framework.Functions.Progressbar("open-brick", "Making deal..", 7500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "oddjobs@assassinate@vice@hooker",
        anim = "argue_a",
        flags = 49,
    }, {}, {}, function() -- Done
        table.insert(LastPed, CurrentNpc)
        ClearPedTasks(CurrentNpc)
        FreezeEntityPosition(CurrentNpc, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        TriggerEvent('pepe-inventory:client:set:busy', false)
        TriggerServerEvent('pepe-illegal:server:finish:corner:selling', Price, Item, Amount)
        StopAnimTask(PlayerPedId(), "oddjobs@assassinate@vice@hooker", "argue_a", 1.0)
        Framework.Functions.TriggerCallback('pepe-illegal:server:has:drugs', function(HasDrugs)
            if not HasDrugs then
                Config.IsCornerSelling = false
                Framework.Functions.Notify('You ran out of supply..', 'error')
            end
        end)
        HasNpcFound = false
        CurrentNpc = nil
    end, function()
        table.insert(LastPed, CurrentNpc) 
        ClearPedTasks(CurrentNpc)
        FreezeEntityPosition(CurrentNpc, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        TriggerEvent('pepe-inventory:client:set:busy', false)
        Framework.Functions.Notify("Canceled..", "error")
        StopAnimTask(PlayerPedId(), "oddjobs@assassinate@vice@hooker", "argue_a", 1.0)
        CurrentNpc = nil
        HasNpcFound = false
    end)
end

function ResetCornerSelling()
    LastPed = {}
    CurrentNpc = nil
    HasNpcFound = false
    Config.IsCornerSelling = false
end
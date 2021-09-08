Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local robberyBusy = false
local timeOut = false
local blackoutActive = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 10)
        if blackoutActive then
            TriggerEvent("pepe-weathersync:server:toggleBlackout")
            TriggerClientEvent("police:client:EnableAllCameras", -1)
            TriggerClientEvent("pepe-humanlabs:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("pepe-humanlabs:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('pepe-humanlabs:server:setLabState')
AddEventHandler('pepe-humanlabs:server:setLabState', function(bankId, state)
        if not robberyBusy then
            Config.Lab["isOpened"] = state
			Config.Lab["explosive"]["isOpened"] = state
            TriggerClientEvent('pepe-humanlabs:client:setLabState', -1, bankId, state)
            TriggerEvent('pepe-scoreboard:server:SetActivityBusy', "humanelabs", true)
            TriggerEvent('pepe-humanlabs:server:setTimeout')
        else
            Config.Lab["isOpened"] = state
			Config.Lab["explosive"]["isOpened"] = state
            TriggerClientEvent('pepe-humanlabs:client:setLabState', -1, bankId, state)
        end
    robberyBusy = true
end)


RegisterServerEvent('pepe-humanlabs:server:Openkluisjes')
AddEventHandler('pepe-humanlabs:server:Openkluisjes', function(bool)

    Config.Lab["isOpened"] = bool

    TriggerClientEvent('pepe-humanlabs:client:setLabState', -1, bool)
end)

RegisterServerEvent('pepe-humanlabs:server:setLockerState')
AddEventHandler('pepe-humanlabs:server:setLockerState', function(lockerId, state, bool)

        Config.Lab["lockers"][lockerId][state] = bool

    TriggerClientEvent('pepe-humanlabs:client:setLockerState', -1, lockerId, state, bool)
end)

RegisterServerEvent('pepe-humanlabs:server:setCabinetState')
AddEventHandler('pepe-humanlabs:server:setCabinetState', function(cabinetId, state, bool)

        Config.Lab["lockers"][lockerId][state] = bool

    TriggerClientEvent('pepe-humanlabs:client:setCabinetState', -1, cabinetId, state, bool)
end)

RegisterServerEvent('pepe-humanlabs:server:cabinetItem')
AddEventHandler('pepe-humanlabs:server:cabinetItem', function(type)
    local src = source
    local ply = Framework.Functions.GetPlayer(src)

        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 25 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 75 then tier = 3 elseif tierChance >=75 and tierChance <85 then tier = 4 end
            if tier ~= 4 then
                local item = Config.CabinetRewards["tier"..tier][math.random(#Config.CabinetRewards["tier"..tier])]
                local itemAmount = math.random(item.maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('pepe-inventory:client:ItemBox', ply.PlayerData.source, Framework.Shared.Items[item.item], 'add')

            else
                ply.Functions.AddItem('pistol-ammo', 2)
                TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['pistol-ammo'], "add")
            end   
    end)

RegisterServerEvent('pepe-humanlabs:server:recieveItem')
AddEventHandler('pepe-humanlabs:server:recieveItem', function(type)
    local src = source
    local ply = Framework.Functions.GetPlayer(src)

        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 100)
        local odd1 = math.random(1, 100)
        local odd2 = math.random(1, 100)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 10 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 or WeaponChance ~= odd2 then
            if tier ~= 4 then
                if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]
                    local maxAmount = item.maxAmount
                    if tier == 3 then maxAmount = 7 elseif tier == 2 then maxAmount = 18 else maxAmount = 25 end
                    local itemAmount = math.random(maxAmount)

                    ply.Functions.AddItem(item.item, itemAmount)
                    
        TriggerClientEvent('pepe-inventory:client:ItemBox', ply.PlayerData.source, Framework.Shared.Items[item.item], 'add')
                elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {worth = math.random(3500, 12500)}
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['markedbills'], "add")
                end
            else
                --local info = {
                --    crypto = math.random(1, 3)
                --}
                --ply.Functions.AddItem("cryptostick", 1, false, info)
                --TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items['cryptostick'], "add")
            end
        else
            local chance = math.random(1, 2)
            local odd = math.random(1, 2)
           if chance == odd then
               ply.Functions.AddItem('pistol-ammo', 1)
               TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items['pistol-ammo'], "add")
            --else
            --    ply.Functions.AddItem('weapon_minismg', 1)
            --    TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items['weapon_minismg'], "add")
            end
        end
end)

Framework.Functions.CreateCallback('pepe-humanlabs:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

Framework.Functions.CreateCallback('pepe-humanlabs:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-humanlabs:server:setTimeout')
AddEventHandler('pepe-humanlabs:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(30 * (60 * 1000))
                timeOut = false
                robberyBusy = false
                TriggerEvent('pepe-scoreboard:server:SetActivityBusy', "humanelabs", false)

                for k, v in pairs(Config.Labs["lockers"]) do
                    Config.Labs["lockers"][k]["isBusy"] = false
                    Config.Labs["lockers"][k]["isOpened"] = false
                    Config.Labs["explosive"]["isOpened"] = false
                end

                TriggerClientEvent('pepe-humanlabs:client:ClearTimeoutDoors', -1)
                Config.Labs["isOpened"] = false
            end)
        end
    end
end)

Framework.Functions.CreateCallback('pepe-humanlabs:server:PoliceAlertMessage', function(source, cb, title, coords, blip)
	local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Overval gestart op Human Lbas<br>Beschikbare camera's: Geen.",
    }

    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("pepe-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("pepe-humanlabs:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("pepe-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("pepe-humanlabs:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

RegisterServerEvent('pepe-humanlabs:server:SetStationStatus')
AddEventHandler('pepe-humanlabs:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("pepe-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("pepe-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("pepe-bankrobbery:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

Framework.Functions.CreateUseableItem("explosive", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('lighter') ~= nil then
        TriggerClientEvent("explosive:UseExplosive", source)
        
        TriggerEvent('pepe-scoreboard:server:SetActivityBusy', "humanelabs", true)
    else
        TriggerClientEvent('Framework:Notify', source, "Je mist iets om het mee te vlammen..", "error")
    end
end)


Framework.Functions.CreateUseableItem("electronickit", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('electronickit') ~= nil then
        TriggerClientEvent("electronickit:UseElectronickit", source)
    else
        TriggerClientEvent('Framework:Notify', source, "You dont have any electronic kit", "error")
    end
end)

RegisterServerEvent('pepe-bankrobbery:maze:server:DoSmokePfx')
AddEventHandler('pepe-bankrobbery:maze:server:DoSmokePfx', function()
    TriggerClientEvent('pepe-bankrobbery:maze:client:DoSmokePfx', -1)
end)
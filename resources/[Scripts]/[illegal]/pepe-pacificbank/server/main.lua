Framework = nil
local IsBankBeingRobbed = false
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
            TriggerClientEvent("pepe-pacific:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 30)
        TriggerClientEvent("pepe-pacific:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('pepe-pacific:server:set:trolly:state')
AddEventHandler('pepe-pacific:server:set:trolly:state', function(TrollyNumber, bool)
 Config.Trollys[TrollyNumber]['Open-State'] = bool
 TriggerClientEvent('pepe-pacific:client:set:trolly:state', -1, TrollyNumber, bool)
end)

Framework.Functions.CreateCallback("pepe-pacific:server:get:status", function(source, cb)
    cb(IsBankBeingRobbed)
  end)

RegisterServerEvent('pepe-pacific:server:Klapdebank')
AddEventHandler('pepe-pacific:server:Klapdebank', function(state)
        if not robberyBusy then
			Config.PacificB["explosive"]["isOpened"] = state
            TriggerClientEvent('pepe-pacific:client:Klapdebank', state)
            IsBankBeingRobbed = true
            TriggerEvent('pepe-pacific:server:setTimeout')
        else
			Config.PacificB["explosive"]["isOpened"] = state
            IsBankBeingRobbed = false
            TriggerClientEvent('pepe-pacific:client:Klapdebank', state)
        end
    robberyBusy = true
end)

RegisterServerEvent('pepe-pacific:server:set:lights')
AddEventHandler('pepe-pacific:server:set:lights', function(bool)
 Config.PacificB['lights'] = bool
 TriggerClientEvent('pepe-pacific:client:set:lights:state', -1, bool)
end)


RegisterServerEvent('pepe-pacific:server:set:trollyz')
AddEventHandler('pepe-pacific:server:set:trollyz', function(bool)
    Config.PacificB["isOpened"] = bool
 TriggerClientEvent('pepe-pacific:client:set:trol:state', -1, bool)
end)


RegisterServerEvent('pepe-pacific:server:cabinetItem')
AddEventHandler('pepe-pacific:server:cabinetItem', function(type)
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

RegisterServerEvent('pepe-pacific:server:recieveItem')
AddEventHandler('pepe-pacific:server:recieveItem', function(type)
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
                    local moneyAmount = math.random(1200, 7000)
                    local info = {
                        worth = math.random(19000, 21000)
                    }
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('pepe-inventory:client:ItemBox', ply.PlayerData.source, Framework.Shared.Items['markedbills'], 'add')
                end
            else
                local info = {
                    worth = math.random(1, 3)
                }
                ply.Functions.AddItem("money-roll", 1, false, info)
                TriggerClientEvent('pepe-inventory:client:ItemBox', src, ply.PlayerData.source, Framework.Shared.Items['money-roll'], "add")
            end
        else
            local chance = math.random(1, 2)
            local odd = math.random(1, 2)
           -- if chance == odd then
            --    ply.Functions.AddItem('weapon_microsmg', 1)
            --    TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items['weapon_microsmg'], "add")
            --else
            --    ply.Functions.AddItem('weapon_minismg', 1)
            --    TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items['weapon_minismg'], "add")
            --end
        end
end)

Framework.Functions.CreateCallback('pepe-pacific:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

Framework.Functions.CreateCallback('pepe-pacific:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-pacific:server:setTimeout')
AddEventHandler('pepe-pacific:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(30 * (60 * 1000))
                timeOut = false
                robberyBusy = false
                TriggerEvent('pepe-scoreboard:server:SetActivityBusy', "humanelabs", false)
                Config.PacificB["explosive"]["isOpened"] = false
                Config.PacificB["lights"] =false
                Config.PacificB["isOpened"] = false
                -- for k, v in pairs(Config.PacificBs["lockers"]) do
                --     Config.PacificBs["lockers"][k]["isBusy"] = false
                --     Config.PacificBs["lockers"][k]["isOpened"] = false
                --     Config.PacificBs["explosive"]["isOpened"] = false
                -- end

                TriggerClientEvent('pepe-pacific:client:ClearTimeoutDoors', -1)
            end)
        end
    end
end)

Framework.Functions.CreateCallback('pepe-pacific:server:PoliceAlertMessage', function(source, cb, title, coords, blip)
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
                        TriggerClientEvent("pepe-pacific:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("pepe-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("pepe-pacific:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

RegisterServerEvent('pepe-pacific:server:SetStationStatus')
AddEventHandler('pepe-pacific:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("pepe-pacific:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("pepe-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("pepe-pacific:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

Framework.Commands.Add("bankreset", "Bank reset", {}, false, function(source, args)
    local group = Framework.Functions.GetPermission(source)
    if group == "god"  then
        TriggerEvent('pepe-pacific:server:setTimeout', source)
	end
end)

Framework.Functions.CreateCallback('pepe-pacificbank:server:HasItem', function(source, cb, ItemName)
    local Player = Framework.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(ItemName)
    if Player ~= nil then
       if Item ~= nil then
         cb(true)
       else
         cb(false)
       end
    end
  end)

  
RegisterServerEvent('pepe-pacific:server:rob:pacific:money')
AddEventHandler('pepe-pacific:server:rob:pacific:money', function()
  local Player = Framework.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  Player.Functions.AddMoney('cash', math.random(1500, 11000), "Bank Robbery")
if RandomValue > 15 and  RandomValue < 20 then
     Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(12500, 20000)})
     TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['markedbills'], "add")
    else
    Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(1250, 20000)})
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['markedbills'], "add")
  end

end)

RegisterServerEvent('pepe-pacific:maze:server:DoSmokePfx')
AddEventHandler('pepe-pacific:maze:server:DoSmokePfx', function()
    TriggerClientEvent('pepe-pacific:maze:client:DoSmokePfx', -1)
end)

Framework.Functions.CreateUseableItem("red-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-bankrobbery:client:use:card', source, 'red-card')
    end
end)

Framework.Functions.CreateUseableItem("purple-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-bankrobbery:client:use:card', source, 'purple-card')
    end
end)

Framework.Functions.CreateUseableItem("black-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-pacificbank:client:use:black-card', source, 'purple-card')
    end
end)

Framework.Functions.CreateUseableItem("blue-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-bankrobbery:client:use:card', source, 'blue-card')
    end
end)
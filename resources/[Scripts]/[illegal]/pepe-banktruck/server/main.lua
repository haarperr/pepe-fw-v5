Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-banktruck:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-banktruck:server:OpenTruck')
AddEventHandler('pepe-banktruck:server:OpenTruck', function(Veh) 
    TriggerClientEvent('pepe-banktruck:client:OpenTruck', source, Veh)
end)

RegisterServerEvent('pepe-banktruck:server:updateplates')
AddEventHandler('pepe-banktruck:server:updateplates', function(Plate)
 Config.RobbedPlates[Plate] = true
 TriggerClientEvent('pepe-banktruck:plate:table', -1, Plate)
end)

RegisterServerEvent('pepe-banktruck:sever:send:cop:alert')
AddEventHandler('pepe-banktruck:sever:send:cop:alert', function(coords, veh, plate)
    local msg = "A bank truck is being robbed.<br>"..plate
    local alertData = {
        title = "Bank truck Alarm",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("pepe-banktruck:client:send:cop:alert", -1, coords, veh, plate)
    TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('pepe-bankrob:server:remove:card')
AddEventHandler('pepe-bankrob:server:remove:card', function()
local Player = Framework.Functions.GetPlayer(source)
 Player.Functions.RemoveItem('green-card', 1)
 TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['green-card'], "remove")
end)

RegisterServerEvent('blijf:uit:mijn:scripts:rewards')
AddEventHandler('blijf:uit:mijn:scripts:rewards', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
    local info = {worth = math.random(7500, 12500)}
    Player.Functions.AddItem('markedbills', 1, false, info)
    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['markedbills'], "add")
    TriggerEvent("pepe-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Marked Bills\n**Waarde: **"..info.worth)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        local AmountGoldStuff = math.random(6,19)
        Player.Functions.AddItem('gold-rolex', AmountGoldStuff)
        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['gold-rolex'], "add")
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        local AmountGoldStuff = math.random(6,19)
        Player.Functions.AddItem('gold-necklace', AmountGoldStuff)
        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['gold-necklace'], "add")
        TriggerEvent("pepe-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Golden Chain\n**Amount: **"..AmountGoldStuff)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        local RandomAmount = math.random(2,6)
        Player.Functions.AddItem('gold-bar', RandomAmount)
        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['gold-bar'], "add") 
        TriggerEvent("pepe-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Gold Bar\n**Amount: **"..RandomAmount)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('yellow-card', 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['yellow-card'], "add") 
        TriggerEvent("pepe-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Player:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Recieved: **Yellow Card\n**Amount:** 1x")
    end
end)

Framework.Functions.CreateUseableItem("green-card", function(source, item)
    TriggerClientEvent("pepe-truckrob:client:UseCard", source)
end)
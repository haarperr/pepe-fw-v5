Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local PaymentTax = 15

local Bail = {}

RegisterServerEvent('pepe-trucker:server:DoBail')
AddEventHandler('pepe-trucker:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('Framework:Notify', src, 'You paid the deposit of 1000,-', 'success')
            TriggerClientEvent('pepe-trucker:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('Framework:Notify', src, 'You paid the deposit of $1000,- (Bank)', 'success')
            TriggerClientEvent('pepe-trucker:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('Framework:Notify', src, 'You dont have enough cash you need $1000,-', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('Framework:Notify', src, 'You recieved your deposit of $1000,-', 'success')
        end
    end
end)

RegisterNetEvent('pepe-trucker:server:01101110')
AddEventHandler('pepe-trucker:server:01101110', function(drops)
    local src = source 
    local Player = Framework.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(3000, 5000)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5) + 100
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7) + 300
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10) + 400
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12) + 500
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    -- Player.Functions.AddJobReputation(1)
    Player.Functions.AddMoney("cash", payment, "trucker-salary")
    TriggerClientEvent('chatMessage', source, "JOB", "warning", "Salary recieved  $"..payment..", total: $"..price.." (from which $"..bonus.." has been bonus pay) and $"..taxAmount.." has been taxed ("..PaymentTax.."%)")
end)

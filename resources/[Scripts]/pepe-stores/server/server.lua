Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-stores:server:update:store:items')
AddEventHandler('pepe-stores:server:update:store:items', function(Shop, ItemData, Amount)
    Config.Shops[Shop]["Product"][ItemData.slot].amount = Config.Shops[Shop]["Product"][ItemData.slot].amount - Amount
    TriggerClientEvent('pepe-stores:client:set:store:items', -1, ItemData, Amount, Shop)
end)
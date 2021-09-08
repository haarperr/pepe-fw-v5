Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

RegisterServerEvent('pepe-alerts:server:send:alert')
AddEventHandler('pepe-alerts:server:send:alert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('pepe-alerts:client:send:alert', -1, data, forBoth)
end)
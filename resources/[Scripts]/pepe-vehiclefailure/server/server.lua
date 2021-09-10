Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("fix", "Xe đã được sử chữa", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:fix:veh', source)
end, "admin")
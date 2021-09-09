Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)


Framework.Commands.Add("cash", "Kiểm tra tiền mặt", {}, false, function(source, args)
	TriggerClientEvent('hud:client:ShowMoney', source, "cash")
end)
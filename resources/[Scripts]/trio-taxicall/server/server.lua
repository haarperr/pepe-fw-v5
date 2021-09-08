Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)


RegisterServerEvent('fs_taxi:payCab')
AddEventHandler('fs_taxi:payCab', function(meters)
	local src = source
	local xPlayer = Framework.Functions.GetPlayer(src)
	xPlayer.Functions.RemoveMoney('bank', 100, nil)
	TriggerClientEvent('Framework:Notify', src, 'That will be $100')
	--TriggerClientEvent('esx:showNotification', _source, 'Isso faz então ~g~$'..price..'~s~. Muito Obrigado')
end)

Framework.Commands.Add("taxi", "Call a taxi to your location", {}, false, function(source, args)
	--TriggerClientEvent("5q-aiTaxi:callTaxi", source)
end)
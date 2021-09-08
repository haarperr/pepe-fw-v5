Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Oxy Run
RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function()
	local src = source
    local Player = Framework.Functions.GetPlayer(src)

	if Player.PlayerData.money.cash >= Config.StartOxyPayment then
		Player.Functions.RemoveMoney('cash', Config.StartOxyPayment)
		
		TriggerClientEvent("oxydelivery:startDealing", source)
	else
		TriggerClientEvent('Framework:Notify', src, "You dont have enough money to start an oxy run", "error")
	end
end)

RegisterServerEvent('oxydelivery:receiveBigRewarditem')
AddEventHandler('oxydelivery:receiveBigRewarditem', function()
	local src = source
    local Player = Framework.Functions.GetPlayer(src)

	Player.Functions.AddItem(Config.BigRewarditem, 1)
	TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items["green-card"], 'add')
end)

RegisterServerEvent('oxydelivery:receiveoxy')
AddEventHandler('oxydelivery:receiveoxy', function()
	local src = source
    local Player = Framework.Functions.GetPlayer(src)
    pay = math.floor(Config.Payment / 2)
	Player.Functions.AddMoney('cash',pay)
	Player.Functions.AddItem("oxy", Config.OxyAmount)
	TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items["oxy"], 'add')

    TriggerClientEvent('Framework:Notify', src, "You were handed $ "..pay.. " and some oxy!", "success")
end)

RegisterServerEvent('oxydelivery:receivemoneyyy')
AddEventHandler('oxydelivery:receivemoneyyy', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	
	TriggerClientEvent('Framework:Notify', src, "You were handed $ "..Config.Payment)

	Player.Functions.AddMoney('cash',Config.Payment)
end)

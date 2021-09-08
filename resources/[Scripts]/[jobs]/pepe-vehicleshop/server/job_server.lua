Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-cardealer:job:pay')
AddEventHandler('pepe-cardealer:job:pay', function(type)
	local payment = type
	local xPlayer = Framework.Functions.GetPlayer(source)
	if payment == 'bestpay' then
		xPlayer.Functions.AddMoney('cash', 1500)
	elseif payment == 'womenpayxd' then
		xPlayer.Functions.AddMoney('cash', 500)
	elseif payment == 'shitpay' then
		xPlayer.Functions.AddMoney('cash', 300)
	elseif payment == 'Lpay' then
		xPlayer.Functions.AddMoney('cash', 100)
	end
end)
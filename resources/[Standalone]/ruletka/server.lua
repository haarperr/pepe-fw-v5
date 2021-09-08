Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('esx_roulette:removemoney')
AddEventHandler('esx_roulette:removemoney', function(amount)
	local amount = amount
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)
	xPlayer.Functions.RemoveMoney("cash", amount)
	-- --xPlayer.removeInventoryItem('zetony', amount)
	-- xPlayer.Functions.AddItem("casinochips", amount)
	-- 	TriggerClientEvent('inventory:client:ItemBox', src, "casinochips", 'add')
end)

RegisterServerEvent('esx_roulette:givemoney')
AddEventHandler('esx_roulette:givemoney', function(action, amount)
	local aciton = aciton
	local amount = amount
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)
	if action == 'black' or action == 'red' then
		local win = amount*2

        xPlayer.Functions.AddMoney("cash", win)
		-- xPlayer.Functions.AddItem("casinochips", amount)
		-- TriggerClientEvent('inventory:client:ItemBox', src, "casinochips", 'add')
	elseif action == 'green' then
		local win = amount*14
        xPlayer.Functions.AddMoney("cash", win)
		--xPlayer.Functions.AddItem("casinochips", amount)
		--TriggerClientEvent('inventory:client:ItemBox', src, "casinochips", 'add')
	else
	end
end)

-- Framework.Functions.CreateCallback('esx_roulette:check_money', function(source, cb)
-- 	local src = source
-- 	local xPlayer = Framework.Functions.GetPlayer(src)
-- 	local quantity = xPlayer.Functions.GetItemByName('casinochips').amount
	
-- 	cb(quantity)
-- end)
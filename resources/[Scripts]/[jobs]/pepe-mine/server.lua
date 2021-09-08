Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-mine:getItem')
AddEventHandler('pepe-mine:getItem', function()
	local xPlayer, randomItem = Framework.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName(randomItem)
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
		else	
		if Item.amount < 35 then
        
        xPlayer.Functions.AddItem(randomItem, 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
		else
			TriggerClientEvent('Framework:Notify', source, 'Inventory full', "error")  
		end
	    end
    end
end)



RegisterServerEvent('pepe-mine:sell')
AddEventHandler('pepe-mine:sell', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    
if Player ~= nil then

    if Player.Functions.RemoveItem("steel", 1) then
        TriggerClientEvent("Framework:Notify", src, "You sold 1x Steel", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.steel)
        Citizen.Wait(200)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['steel'], 'remove')
    else
        TriggerClientEvent("Framework:Notify", src, "You have nothing to offer.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("iron", 1) then
        TriggerClientEvent("Framework:Notify", src, "You sold 1x Iron", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.iron)
        Citizen.Wait(200)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['iron'], 'remove')
    else
        TriggerClientEvent("Framework:Notify", src, "You have nothing to offer.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("copper", 1) then
        TriggerClientEvent("Framework:Notify", src, "You sold 1x Copper", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.copper)
        Citizen.Wait(200)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['copper'], 'remove')
    else
        TriggerClientEvent("Framework:Notify", src, "You have nothing to offer.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("diamond", 1) then
        TriggerClientEvent("Framework:Notify", src, "You sold 1x Diamond", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.diamond)
        Citizen.Wait(200)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['diamond'], 'remove')
    else
        TriggerClientEvent("Framework:Notify", src, "You have nothing to offer.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("emerald", 1) then
        TriggerClientEvent("Framework:Notify", src, "You sold 1x Emerald", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.emerald)
        Citizen.Wait(200)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['emerald'], 'remove')
    else
        TriggerClientEvent("Framework:Notify", src, "You have nothing to offer.", "error", 1000)
    end
end
end)

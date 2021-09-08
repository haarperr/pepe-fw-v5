
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)


RegisterServerEvent('wood:getItem')
AddEventHandler('wood:getItem', function()
	local xPlayer, randomItem = Framework.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName('wood_cut')
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
			TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items[randomItem], "add")
		else	
		if Item.amount < 20 then
		xPlayer.Functions.AddItem(randomItem, 1)
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items[randomItem], "add")
		else
			TriggerClientEvent('Framework:Notify', source, 'Inventory full, you can not carry more!', "error")  
		end
	    end
    end
end)

RegisterServerEvent('wood_weed:processweed2')
AddEventHandler('wood_weed:processweed2', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName('wood_cut') then
		local chance = math.random(1, 8)
		if chance == 1 or chance == 2 or chance == 3 or chance == 4 or chance == 5 or chance == 6 or chance == 7 or chance == 8 then
			Player.Functions.RemoveItem('wood_cut', 1)
			Player.Functions.AddItem('wood_proc', 1)
			TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_cut'], "remove")
			TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_proc'], "add")
			TriggerClientEvent('Framework:Notify', src, 'Wood processed', "success")  
		else
			
		end 
	else
		TriggerClientEvent('Framework:Notify', src, 'You do not have the right itemsm', "error") 
	end
end)


RegisterServerEvent('wood:sell')
AddEventHandler('wood:sell', function()

    local xPlayer = Framework.Functions.GetPlayer(source)
	local Item = xPlayer.Functions.GetItemByName('wood_proc')
   
	
	if Item == nil then
       TriggerClientEvent('Framework:Notify', source, 'wood_proc', "error")  
	else
	 for k, v in pairs(Config.Prices) do
        
		
		if Item.amount > 0 then
            local reward = 0
            for i = 1, Item.amount do
                --reward = reward + math.random(v[1], v[2])
                reward = reward + math.random(1, 2)
            end
			xPlayer.Functions.RemoveItem('wood_proc', 1)
			TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_proc'], "remove")
			xPlayer.Functions.AddMoney("cash", reward, "sold-pawn-items")
			TriggerClientEvent('Framework:Notify', source, '1x Sold', "success")  
			--end
        end
		
		
     end
	end
	
		
	
end)


local prezzo = 10
RegisterServerEvent('pepe-jobwood:server:truck')
AddEventHandler('pepe-jobwood:server:truck', function(boatModel, BerthId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local plate = "WOOD"..math.random(1111, 9999)
    
	TriggerClientEvent('pepe-jobwood:Auto', src, boatModel, plate)
end)

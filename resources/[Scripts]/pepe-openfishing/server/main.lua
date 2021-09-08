Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-openfishing:GetItemData', function(source, cb, itemName)
	local retval = false
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	
	cb(retval)
end)	

Framework.Functions.CreateUseableItem("fishrod", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)

    TriggerClientEvent('pepe-openfishing:tryToFish', source)
end)

RegisterServerEvent('pepe-openfishing:receiveFish')
AddEventHandler('pepe-openfishing:receiveFish', function(cabin, house)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local luck = math.random(1, 100)
    local itemFound = true
    local itemCount = 1

    if itemFound then
        for i = 1, itemCount, 1 do
            local randomItem = Config.FishingItems["type"]math.random(1, 2)
            local itemInfo = Framework.Shared.Items[randomItem]
            if luck == 100 then
                randomItem = "killerwhalemeat"
                itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 99 and luck <= 100 then
				randomItem = "stingraymeat"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 98 and luck <= 99 then
				randomItem = "tigersharkmeat"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 97 and luck <= 98 then
				randomItem = "catfish"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 95 and luck <= 97 then
				randomItem = "salmon"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 93 and luck <= 95 then
				randomItem = "largemouthbass"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 90 and luck <= 93 then
				randomItem = "goldfish"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 85 and luck <= 90 then
				randomItem = "redfish"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 80 and luck <= 85 then
				randomItem = "bluefish"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 70 and luck <= 80 then
				randomItem = "stripedbass"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
			elseif luck >= 0 and luck <= 70 then
				randomItem = "fish"
				itemInfo = Framework.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 1)
				TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "add")
            end
            Citizen.Wait(500)
        end
    end
end)

RegisterServerEvent("pepe-openfishing:sellFish")
AddEventHandler("pepe-openfishing:sellFish", function()
    local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "fish" then 
                    price = price + (Config.FishingItems["fish"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("fish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "stripedbass" then 
                    price = price + (Config.FishingItems["stripedbass"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("stripedbass", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "bluefish" then 
                    price = price + (Config.FishingItems["bluefish"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("bluefish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "redfish" then 
                    price = price + (Config.FishingItems["redfish"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("redfish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "goldfish" then 
                    price = price + (Config.FishingItems["goldfish"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("goldfish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "largemouthbass" then 
                    price = price + (Config.FishingItems["largemouthbass"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("largemouthbass", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "salmon" then 
                    price = price + (Config.FishingItems["salmon"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("salmon", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "catfish" then 
                    price = price + (Config.FishingItems["catfish"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("catfish", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "stingraymeat" then 
                    price = price + (Config.FishingItems["stingraymeat"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("stingraymeat", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "tigersharkmeat" then 
                    price = price + (Config.FishingItems["tigersharkmeat"]["price"] * Player.PlayerData.items[k].amount)
					Player.Functions.RemoveItem("tigersharkmeat", Player.PlayerData.items[k].amount, k)
				elseif Player.PlayerData.items[k].name == "killerwhalemeat" then 
                    price = price + (Config.FishingItems["killerwhalemeat"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("killerwhalemeat", Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-fish")
		TriggerClientEvent('Framework:Notify', src, "You have sold your fish", 'success')
	end
end)
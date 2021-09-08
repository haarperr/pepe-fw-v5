Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Drops = {}
Trunks = {}
Gloveboxes = {}
Stashes = {}
ShopItems = {}

RegisterServerEvent("pepe-inventory:server:LoadDrops")
AddEventHandler('pepe-inventory:server:LoadDrops', function()
	local src = source
	if next(Drops) ~= nil then
		TriggerClientEvent("pepe-inventory:client:AddDropItem", -1, dropId, source)
		TriggerClientEvent("pepe-inventory:client:AddDropItem", src, Drops)
	end
end)

RegisterServerEvent("pepe-inventory:server:addTrunkItems")
AddEventHandler('pepe-inventory:server:addTrunkItems', function(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end)

RegisterServerEvent("pepe-inventory:server:set:inventory:disabled")
AddEventHandler('pepe-inventory:server:set:inventory:disabled', function(bool)
	local Player = Framework.Functions.GetPlayer(source)
	Player.Functions.SetMetaData("inventorydisabled", bool)
end)

function Craftable(item)
    for _, check in pairs(Config.WhitelistedItems) do
        if check == item then
            return true
        end
    end
    return false
end

RegisterServerEvent("pepe-inventory:server:combineItem")
AddEventHandler('pepe-inventory:server:combineItem', function(item, fromItem, toItem, RemoveToItem)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local CombineFrom = Player.Functions.GetItemByName(fromItem)
	local CombineTo = Player.Functions.GetItemByName(toItem)
	local GetItemData = Framework.Shared.Items[item]

	if CombineFrom ~= nil and CombineTo ~= nil then
		if Craftable(item) then

				if GetItemData['type'] == 'weapon' then
					local Info = {quality = 100.0, melee = false, ammo = 2}
					if GetItemData['ammotype'] == nil or GetItemData['ammotype'] == 'nil' then
						Info = {quality = 100.0, melee = true}
						Player.Functions.AddItem(item, 1, false, Info)
					else
						Player.Functions.AddItem(item, 1, false, Info)
					end
				else
					Player.Functions.AddItem(item, 1)
				end
				Player.Functions.RemoveItem(fromItem, 1)
			if RemoveToItem then
				Player.Functions.RemoveItem(toItem, 1)
			end
			Player.Functions.SetMetaData("inventorydisabled", false)
			TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[item], 'add')
		else
		Framework.Functions.BanInjection(source, 'Items spawned that were not whitelisted.')
		end
	else
	  TriggerClientEvent('Framework:Notify', src, "How are you supposed to do this with out the needed items?", "error")
	end
end)

RegisterServerEvent("pepe-inventory:server:CraftItems")
AddEventHandler('pepe-inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("inventorydisabled", false)
		if points ~= nil then
			Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"]+(points*amount))
		end
		TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterServerEvent("pepe-inventory:server:CraftWeapon")
AddEventHandler('pepe-inventory:server:CraftWeapon', function(ItemName, itemCosts, amount, toSlot, ItemType)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if ItemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		if ItemType == 'weapon' then
		  Player.Functions.AddItem(ItemName, amount, toSlot, {serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4)), ammo = 1, quality = 100.0})
		else
		  Player.Functions.AddItem(ItemName, amount, toSlot)
		end
		Player.Functions.SetMetaData("inventorydisabled", false)
		TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterServerEvent("pepe-inventory:server:SetIsOpenState")
AddEventHandler('pepe-inventory:server:SetIsOpenState', function(IsOpen, type, id)
	if not IsOpen then
		if type == "stash" then
			Stashes[id].isOpen = false
		elseif type == "trunk" then
			Trunks[id].isOpen = false
		elseif type == "glovebox" then
			Gloveboxes[id].isOpen = false
		end
	end
end)

RegisterServerEvent("pepe-inventory:server:OpenInventory")
AddEventHandler('pepe-inventory:server:OpenInventory', function(name, id, other)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
		if name ~= nil and id ~= nil then
			local secondInv = {}
			if name == "stash" then
				if Stashes[id] ~= nil then
					if Stashes[id].isOpen then
						local Target = Framework.Functions.GetPlayer(Stashes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('pepe-inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
						else
							Stashes[id].isOpen = false
						end
					end
				end
				local maxweight = 1000000
				local slots = 50
				if other ~= nil then 
					maxweight = other.maxweight ~= nil and other.maxweight or 1000000
					slots = other.slots ~= nil and other.slots or 50
				end
				secondInv.name = "stash-"..id
				secondInv.label = "Stash-"..id
				secondInv.maxweight = maxweight
				secondInv.inventory = {}
				secondInv.slots = slots
				if Stashes[id] ~= nil and Stashes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Stash-Geen"
					secondInv.maxweight = 1000000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local stashItems = GetStashItems(id)
					if next(stashItems) ~= nil then
						secondInv.inventory = stashItems
						Stashes[id] = {}
						Stashes[id].items = stashItems
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					else
						Stashes[id] = {}
						Stashes[id].items = {}
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					end
				end
			elseif name == "trunk" then
				if Trunks[id] ~= nil then
					if Trunks[id].isOpen then
						local Target = Framework.Functions.GetPlayer(Trunks[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('pepe-inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
						else
							Trunks[id].isOpen = false
						end
					end
				end
				secondInv.name = "trunk-"..id
				secondInv.label = "Trunk-"..id
				secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = other.slots ~= nil and other.slots or 50
				if (Trunks[id] ~= nil and Trunks[id].isOpen) or (Framework.Shared.SplitStr(id, "PLZI")[2] ~= nil and Player.PlayerData.job.name ~= "police") then
					secondInv.name = "none-inv"
					secondInv.label = "Trunk-Geen"
					secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					if id ~= nil then 
						local ownedItems = GetOwnedVehicleItems(id)
						if IsVehicleOwned(id) and next(ownedItems) ~= nil then
							secondInv.inventory = ownedItems
							Trunks[id] = {}
							Trunks[id].items = ownedItems
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						elseif Trunks[id] ~= nil and not Trunks[id].isOpen then
							secondInv.inventory = Trunks[id].items
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						else
							Trunks[id] = {}
							Trunks[id].items = {}
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						end
					end
				end
			elseif name == "glovebox" then
				if Gloveboxes[id] ~= nil then
					if Gloveboxes[id].isOpen then
						local Target = Framework.Functions.GetPlayer(Gloveboxes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('pepe-inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
						else
							Gloveboxes[id].isOpen = false
						end
					end
				end
				secondInv.name = "glovebox-"..id
				secondInv.label = "Dashboard-"..id
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 5
				if Gloveboxes[id] ~= nil and Gloveboxes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Dashboard-Geen"
					secondInv.maxweight = 10000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local ownedItems = GetOwnedVehicleGloveboxItems(id)
					if Gloveboxes[id] ~= nil and not Gloveboxes[id].isOpen then
						secondInv.inventory = Gloveboxes[id].items
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) ~= nil then
						secondInv.inventory = ownedItems
						Gloveboxes[id] = {}
						Gloveboxes[id].items = ownedItems
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					else
						Gloveboxes[id] = {}
						Gloveboxes[id].items = {}
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					end
				end
			elseif name == "shop" then
				secondInv.name = "itemshop-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = SetupShopItems(id, other.items)
				ShopItems[id] = {}
				ShopItems[id].items = other.items
				secondInv.slots = #other.items
			elseif name == "crafting" then
				secondInv.name = "crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "methcrafting" then
				secondInv.name = "methcrafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "cokecrafting" then
				secondInv.name = "cokecrafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "crafting_weapon" then
				secondInv.name = "crafting_weapon"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "lab" then
				secondInv.name = "lab-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = other.slots
			elseif name == "otherplayer" then
				local OtherPlayer = Framework.Functions.GetPlayer(tonumber(id))
				if OtherPlayer ~= nil then
					secondInv.name = "otherplayer-"..id
					secondInv.label = "Player-"..id
					secondInv.maxweight = Framework.Config.Player.MaxWeight
					secondInv.inventory = OtherPlayer.PlayerData.items
					secondInv.slots = Config.MaxInventorySlots
					Citizen.Wait(250)
				end
			else
				if Drops[id] ~= nil and not Drops[id].isOpen then
					secondInv.name = id
					secondInv.label = "Ground-"..tostring(id)
					secondInv.maxweight = 100000
					secondInv.inventory = Drops[id].items
					secondInv.slots = 15
					Drops[id].isOpen = src
					Drops[id].label = secondInv.label
				else
					secondInv.name = "none-inv"
					secondInv.label = "Ground-Geen"
					secondInv.maxweight = 100000
					secondInv.inventory = {}
					secondInv.slots = 0
				end
			end
			TriggerClientEvent("pepe-inventory:client:OpenInventory", src, Player.PlayerData.items, secondInv)
		else
			TriggerClientEvent("pepe-inventory:client:OpenInventory", src, Player.PlayerData.items)
		end
end)

RegisterServerEvent("pepe-inventory:server:SaveInventory")
AddEventHandler('pepe-inventory:server:SaveInventory', function(type, id)
	if type == "trunk" then
		if (IsVehicleOwned(id)) then
			SaveOwnedVehicleItems(id, Trunks[id].items)
		else
			Trunks[id].isOpen = false
		end
	elseif type == "glovebox" then
		if (IsVehicleOwned(id)) then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == "stash" then
		SaveStashItems(id, Stashes[id].items)
	elseif type == "drop" then
		if Drops[id] ~= nil then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent("pepe-inventory:client:RemoveDropItem", -1, id)
			end
		end
	end
end)

RegisterServerEvent("pepe-inventory:server:UseItemSlot")
AddEventHandler('pepe-inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData ~= nil then
		local itemInfo = Framework.Shared.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality ~= nil then
				if itemData.info.quality ~= 0 then
					TriggerClientEvent("pepe-inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent('Framework:Notify', src, "Weapon is broken.", "error")
				end
			else
				TriggerClientEvent('Framework:Notify', src, "No weapon quality found.", "info")
			end
			TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			TriggerClientEvent("Framework:Client:UseItem", src, itemData)
			TriggerClientEvent('pepe-inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)

RegisterServerEvent("pepe-inventory:server:UseItem")
AddEventHandler('pepe-inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData ~= nil then
			TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[itemData.name], "use")
			TriggerClientEvent("Framework:Client:UseItem", src, itemData)
		end
	end
end)

RegisterServerEvent("pepe-inventory:server:SetInventoryData")
AddEventHandler('pepe-inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local fromSlot = tonumber(fromSlot)
	local toSlot = tonumber(toSlot)

	if (fromInventory == "player" or fromInventory == "hotbar") and (Framework.Shared.SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting") then
		return
	end

	if fromInventory == "player" or fromInventory == "hotbar" then
		local fromItemData = Player.Functions.GetItemBySlot(fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			elseif Framework.Shared.SplitStr(toInventory, "-")[1] == "otherplayer" then
				local playerId = tonumber(Framework.Shared.SplitStr(toInventory, "-")[2])
				local OtherPlayer = Framework.Functions.GetPlayer(playerId)
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, fromSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "robbing", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** to player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
					end
				else
					local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("pepe-logs:server:SendLog", "robbing", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** to player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				OtherPlayer.Functions.AddItem(itemInfo["name"], fromAmount, toSlot, fromItemData.info)
			elseif Framework.Shared.SplitStr(toInventory, "-")[1] == "trunk" then
				local plate = Framework.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Trunks[plate].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromTrunk(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "trunk", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
					end
				else
					local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("pepe-logs:server:SendLog", "trunk", "dropped Item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif Framework.Shared.SplitStr(toInventory, "-")[1] == "glovebox" then
				local plate = Framework.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Gloveboxes[plate].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "glovebox", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
					end
				else
					local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("pepe-logs:server:SendLog", "glovebox", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif Framework.Shared.SplitStr(toInventory, "-")[1] == "stash" then
				local stashId = Framework.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Stashes[stashId].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromStash(stashId, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "stash", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
					end
				else
					local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
					TriggerEvent("pepe-logs:server:SendLog", "stash", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif Framework.Shared.SplitStr(toInventory, "-")[1] == "lab" then
				local LabId = Framework.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = exports['pepe-labs']:GetInventoryData(LabId, toSlot)
				local IsItemValid = exports['pepe-labs']:CanItemBePlaced(fromItemData.name:lower())
				if IsItemValid then
					TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							exports['pepe-labs']:RemoveProduct(LabId, fromSlot, itemInfo["name"], toAmount)
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info, false)
						end
					end
					local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
					if toSlot ~= 2 then
						Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
						exports['pepe-labs']:AddProduct(LabId, toSlot, itemInfo["name"], fromAmount, fromItemData.info, true)
					else
						TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
						TriggerClientEvent("pepe-inventory:client:close:inventory", src)
					end
				else
					TriggerClientEvent('Framework:Notify', src, "This can not go in here..", 'error')
					TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent("pepe-inventory:client:close:inventory", src)
				end
			else
				-- drop
				toInventory = tonumber(toInventory)
				if toInventory == nil or toInventory == 0 then
					CreateNewDrop(src, fromSlot, toSlot, fromAmount)
				else
					local toItemData = Drops[toInventory].items[toSlot]
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent("pepe-inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
							RemoveFromDrop(toInventory, fromSlot, itemInfo["name"], toAmount)
							TriggerEvent("pepe-logs:server:SendLog", "drop", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
						end
					else
						local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
						TriggerEvent("pepe-logs:server:SendLog", "drop", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
					end
					local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
					AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
					if itemInfo["name"] == "radio" then
					TriggerClientEvent('pepe-radio:drop:radio', src)
					end
				end
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Je hebt dit item niet!", "error")
		end
	elseif Framework.Shared.SplitStr(fromInventory, "-")[1] == "otherplayer" then
		local playerId = tonumber(Framework.Shared.SplitStr(fromInventory, "-")[2])
		local OtherPlayer = Framework.Functions.GetPlayer(playerId)
		local fromItemData = OtherPlayer.PlayerData.items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				OtherPlayer.Functions.RemoveItem(itemInfo["name"], fromAmount, fromSlot)
				TriggerClientEvent("pepe-inventory:client:CheckWeapon", OtherPlayer.PlayerData.source, fromItemData.name)
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "robbing", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
					end
				else
					TriggerEvent("pepe-logs:server:SendLog", "robbing", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) took item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				OtherPlayer.Functions.RemoveItem(itemInfo["name"], fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, toSlot)
						OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				OtherPlayer.Functions.AddItem(itemInfo["name"], fromAmount, toSlot, fromItemData.info)
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Item does not exist", "error")
		end
	elseif Framework.Shared.SplitStr(fromInventory, "-")[1] == "trunk" then
		local plate = Framework.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Trunks[plate].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "trunk", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** Registration number: *" .. plate .. "*")
					else
						TriggerEvent("server:sendLog", Player.PlayerData.citizenid, "itemswapped", {type="2trunk3", name=toItemData.name, amount=toAmount, target=plate})
						TriggerEvent("pepe-logs:server:SendLog", "trunk", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from Registration number: *" .. plate .. "*")
					end
				else
					TriggerEvent("pepe-logs:server:SendLog", "trunk", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** Registration number: *" .. plate .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Trunks[plate].items[toSlot]
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						RemoveFromTrunk(plate, toSlot, itemInfo["name"], toAmount)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Item does not exist??", "error")
		end
	elseif Framework.Shared.SplitStr(fromInventory, "-")[1] == "glovebox" then
		local plate = Framework.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Gloveboxes[plate].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "glovebox", "Gewisseld", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src..")* Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** Registration number: *" .. plate .. "*")
					else
						TriggerEvent("pepe-logs:server:SendLog", "glovebox", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item: name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from Registration number: *" .. plate .. "*")
					end
				else
					TriggerEvent("pepe-logs:server:SendLog", "glovebox", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** Registration number: *" .. plate .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Gloveboxes[plate].items[toSlot]
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						RemoveFromGlovebox(plate, toSlot, itemInfo["name"], toAmount)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Item does not exist??", "error")
		end
	elseif Framework.Shared.SplitStr(fromInventory, "-")[1] == "stash" then
		local stashId = Framework.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Stashes[stashId].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("pepe-logs:server:SendLog", "stash", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
					else
						TriggerEvent("pepe-logs:server:SendLog", "stash", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. stashId .. "*")
					end
				else
					TriggerEvent("pepe-logs:server:SendLog", "stash", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. stashId .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Item does not exist??", "error")
		end
	elseif Framework.Shared.SplitStr(fromInventory, "-")[1] == "lab" then
		local LabId = Framework.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = exports['pepe-labs']:GetInventoryData(LabId, fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				exports['pepe-labs']:RemoveProduct(LabId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						if toSlot ~= 2 then
							Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
							exports['pepe-labs']:AddProduct(LabId, fromSlot, itemInfo["name"], toAmount, toItemData.info, true)
							TriggerEvent("pepe-logs:server:SendLog", "stash", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. LabId .. "*")
						else
							TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
						end
					else
						TriggerEvent("pepe-logs:server:SendLog", "stash", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. LabId .. "*")
					end
				else
					TriggerEvent("pepe-logs:server:SendLog", "stash", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. LabId .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = exports['pepe-labs']:GetInventoryData(LabId, toSlot)
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						exports['pepe-labs']:RemoveProduct(LabId, toSlot, itemInfo["name"], toAmount)
						exports['pepe-labs']:AddProduct(LabId, fromSlot, itemInfo["name"], toAmount, toItemData.info, true)
					end
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				if toSlot ~= 2 then
					exports['pepe-labs']:RemoveProduct(LabId, fromSlot, itemInfo["name"], fromAmount)
					exports['pepe-labs']:AddProduct(LabId, toSlot, itemInfo["name"], fromAmount, fromItemData.info, src)
				else
					TriggerClientEvent("pepe-inventory:client:close:inventory", src)
					TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
				end
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Item does not exist??", "error")
		end
	elseif Framework.Shared.SplitStr(fromInventory, "-")[1] == "itemshop" then
		local shopType = Framework.Shared.SplitStr(fromInventory, "-")[2]
		local itemData = ShopItems[shopType].items[fromSlot]
		local itemInfo = Framework.Shared.Items[itemData.name:lower()]
		local bankBalance = Player.PlayerData.money["bank"]
		local price = tonumber((itemData.price*fromAmount))
		if Framework.Shared.SplitStr(shopType, "_")[1] == "Dealer" then
			if Framework.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
				price = tonumber(itemData.price)
				if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
					itemData.info.quality = 100.0
				    itemData.info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
					Player.Functions.AddItem(itemData.name, 1, toSlot, itemData.info)
					TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
					TriggerClientEvent('pepe-dealers:client:update:dealer:items', src, itemData, 1)
					TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
					TriggerEvent("pepe-logs:server:SendLog", "dealers", "Dealer item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
				else
					TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent('Framework:Notify', src, "You do not have enough cash", "error")
				end
			else
				if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
					Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
					TriggerClientEvent('pepe-dealers:client:update:dealer:items', src, itemData, fromAmount)
					TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
					TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
					TriggerEvent("pepe-logs:server:SendLog", "dealers", "Dealer item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
				else
					TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent('Framework:Notify', src, "You do not have enough cash", "error")
				end
			end
		elseif Framework.Shared.SplitStr(shopType, "_")[1] == "custom" then
			if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
			else
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('Framework:Notify', src, "You do not have enough cash", "error")
			end
		elseif Framework.Shared.SplitStr(shopType, "_")[1] == "police" then
			if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
			else
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('Framework:Notify', src, "You do not have enough cash", "error")
			end
		elseif Framework.Shared.SplitStr(shopType, "_")[1] == "Itemshop" then
			if Player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
				if itemData.name == 'duffel-bag' then itemData.info.bagid = math.random(11111,99999) elseif itemData.name == 'burger-box' then itemData.info.boxid = math.random(11111,99999) end	
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('pepe-stores:client:update:store', src, itemData, fromAmount)
				TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
				TriggerEvent("pepe-logs:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('Framework:Notify', src, "You do not have enough cash", "error")
			end
		elseif Framework.Shared.SplitStr(shopType, "_")[1] == "Cokebrick" then
			if Player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("pepe-inventory:client:close:inventory", src)
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
				TriggerEvent("pepe-logs:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
			end
		elseif Framework.Shared.SplitStr(shopType, "_")[1] == "StreetDealer" then
			if Player.Functions.RemoveItem('money-roll', price) then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
				TriggerEvent("pepe-logs:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('Framework:Notify', src, "You do not have enough money rolls", "error")
			end
		else
			if Player.Functions.RemoveMoney("cash", price, "unkown-itemshop-bought-item") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent('Framework:Notify', src, itemInfo["label"] .. " purchased!", "success")
				TriggerEvent("pepe-logs:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('Framework:Notify', src, "You do not have enough cash", "error")
			end
		end
	elseif fromInventory == "crafting" then
		local itemData = exports['pepe-crafting']:GetCraftingConfig(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("pepe-inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('Framework:Notify', src, "You do not have the required items", "error")
		end
	elseif fromInventory == "crafting_weapon" then
		local itemData = exports['pepe-crafting']:GetWeaponCraftingConfig(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("pepe-inventory:client:CraftWeapon", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.type)
		else
			TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('Framework:Notify', src, "You do not have the required items", "error")
		end
	elseif fromInventory == "cokecrafting" then
		local itemData = exports['pepe-labs']:GetCokeCrafting(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("pepe-inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.type)
		else
			TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('Framework:Notify', src, "You do not have the required items", "error")
		end
	elseif fromInventory == "methcrafting" then
		local itemData = exports['pepe-labs']:GetMethCrafting(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("pepe-inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.type)
		else
			TriggerClientEvent("pepe-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('Framework:Notify', src, "You do not have the required items", "error")
		end
	else
		-- drop
		fromInventory = tonumber(fromInventory)
		local fromItemData = Drops[fromInventory].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToDrop(fromInventory, toSlot, itemInfo["name"], toAmount, toItemData.info)
						if itemInfo["name"] == "radio" then
						TriggerClientEvent('pepe-radio:drop:radio', src)
						end
						TriggerEvent("pepe-logs:server:SendLog", "drop", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** - dropid: *" .. fromInventory .. "*")
					else
						TriggerEvent("pepe-logs:server:SendLog", "drop", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** - from dropid: *" .. fromInventory .. "*")
					end
				else
					TriggerEvent("pepe-logs:server:SendLog", "drop", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** -  dropid: *" .. fromInventory .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				toInventory = tonumber(toInventory)
				local toItemData = Drops[toInventory].items[toSlot]
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = Framework.Shared.Items[toItemData.name:lower()]
						RemoveFromDrop(toInventory, toSlot, itemInfo["name"], toAmount)
						AddToDrop(fromInventory, fromSlot, itemInfo["name"], toAmount, toItemData.info)
						if itemInfo["name"] == "radio" then
						TriggerClientEvent('pepe-radio:drop:radio', src)
						end
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = Framework.Shared.Items[fromItemData.name:lower()]
				AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
				if itemInfo["name"] == "radio" then
			    TriggerClientEvent('pepe-radio:drop:radio', src)
				end
			end
		else
			TriggerClientEvent("Framework:Notify", src, "Item does not exist", "error")
		end
	end
end)

function hasCraftItems(source, CostItems, amount)
	local Player = Framework.Functions.GetPlayer(source)
	for k, v in pairs(CostItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			if Player.Functions.GetItemByName(k).amount < (v * amount) then
				return false
			end
		else
			return false
		end
	end
	return true
end

function IsVehicleOwned(plate)
	local val = false
	Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end

-- Shop Items
function SetupShopItems(shop, shopItems)
	local items = {}
	if shopItems ~= nil and next(shopItems) ~= nil then
		for k, item in pairs(shopItems) do
			local itemInfo = Framework.Shared.Items[item.name:lower()]
			items[item.slot] = {
				name = itemInfo["name"],
				amount = tonumber(item.amount),
				info = item.info ~= nil and item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				price = item.price,
				image = itemInfo["image"],
				slot = item.slot,
			}
		end
	end
	return items
end

-- Stash Items
function GetStashItems(stashId)
	local items = {}
		Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_inventory-stash` WHERE `stash` = '"..stashId.."'", function(result)
			if result[1] ~= nil then 
				if result[1].items ~= nil then
					result[1].items = json.decode(result[1].items)
					if result[1].items ~= nil then 
						for k, item in pairs(result[1].items) do
							local itemInfo = Framework.Shared.Items[item.name:lower()]
							items[item.slot] = {
								name = itemInfo["name"],
								amount = tonumber(item.amount),
								info = item.info ~= nil and item.info or "",
								label = itemInfo["label"],
								description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
								weight = itemInfo["weight"], 
								type = itemInfo["type"], 
								unique = itemInfo["unique"], 
								useable = itemInfo["useable"], 
								image = itemInfo["image"],
								slot = item.slot,
							}
						end
					end
				end
			end
		end)
	return items
end

Framework.Functions.CreateCallback('pepe-inventory:server:GetStashItems', function(source, cb, stashId)
	cb(GetStashItems(stashId))
end)

RegisterServerEvent('pepe-inventory:server:SaveStashItems')
AddEventHandler('pepe-inventory:server:SaveStashItems', function(stashId, items)
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_inventory-stash` WHERE `stash` = '"..stashId.."'", function(result)
		if result[1] ~= nil then
			Framework.Functions.ExecuteSql(false, "UPDATE `characters_inventory-stash` SET `items` = '"..json.encode(items).."' WHERE `stash` = '"..stashId.."'")
		else
			Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_inventory-stash` (`stash`, `items`) VALUES ('"..stashId.."', '"..json.encode(items).."')")
		end
	end)
end)

function SaveStashItems(stashId, items)
	if Stashes[stashId].label ~= "Stash-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end
			Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_inventory-stash` WHERE `stash` = '"..stashId.."'", function(result)
				if result[1] ~= nil then
					Framework.Functions.ExecuteSql(false, "UPDATE `characters_inventory-stash` SET `items` = '"..json.encode(items).."' WHERE `stash` = '"..stashId.."'")
					Stashes[stashId].isOpen = false
				else
					Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_inventory-stash` (`stash`, `items`) VALUES ('"..stashId.."', '"..json.encode(items).."')")
					Stashes[stashId].isOpen = false
				end
			end)
		end
	end
end

function AddToStash(stashId, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = Framework.Shared.Items[itemName]
	if not ItemData.unique then
		if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount + amount
		else
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Stashes[stashId].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromStash(stashId, slot, itemName, amount)
	local amount = tonumber(amount)
	if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].amount > amount then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount - amount
		else
			Stashes[stashId].items[slot] = nil
			if next(Stashes[stashId].items) == nil then
				Stashes[stashId].items = {}
			end
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

-- Trunk items
function GetOwnedVehicleItems(plate)
	local items = {}
	   Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_inventory-vehicle` WHERE `plate` = '"..plate.."'", function(result)
	   	if result[1] ~= nil then
	   		if result[1].trunkitems ~= nil then
	   			result[1].trunkitems = json.decode(result[1].trunkitems)
	   			if result[1].trunkitems ~= nil then 
	   				for k, item in pairs(result[1].trunkitems) do
	   					local itemInfo = Framework.Shared.Items[item.name:lower()]
	   					items[item.slot] = {
	   						name = itemInfo["name"],
	   						amount = tonumber(item.amount),
	   						info = item.info ~= nil and item.info or "",
	   						label = itemInfo["label"],
	   						description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
	   						weight = itemInfo["weight"], 
	   						type = itemInfo["type"], 
	   						unique = itemInfo["unique"], 
	   						useable = itemInfo["useable"], 
	   						image = itemInfo["image"],
	   						slot = item.slot,
	   					}
	   				end
	   			end
	   		end
	   	end
	   end)
	return items
end

function SaveOwnedVehicleItems(plate, items)
	if Trunks[plate].label ~= "Trunk-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end

			Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_inventory-vehicle` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					Framework.Functions.ExecuteSql(false, "UPDATE `characters_inventory-vehicle` SET `trunkitems` = '"..json.encode(items).."' WHERE `plate` = '"..plate.."'", function(result) 
						Trunks[plate].isOpen = false
					end)
				else
					Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_inventory-vehicle` (`plate`, `trunkitems`) VALUES ('"..plate.."', '"..json.encode(items).."')", function(result) 
						Trunks[plate].isOpen = false
					end)
				end
			end)
		end
	end
end

function AddToTrunk(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = Framework.Shared.Items[itemName]

	if not ItemData.unique then
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Trunks[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromTrunk(plate, slot, itemName, amount)
	if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].amount > amount then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
		else
			Trunks[plate].items[slot] = nil
			if next(Trunks[plate].items) == nil then
				Trunks[plate].items = {}
			end
		end
	else
		Trunks[plate].items[slot]= nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
end

-- Glovebox items
function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
		Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_inventory-vehicle` WHERE `plate` = '"..plate.."'", function(result)
			if result[1] ~= nil then 
				if result[1].gloveboxitems ~= nil then
					result[1].gloveboxitems = json.decode(result[1].gloveboxitems)
					if result[1].gloveboxitems ~= nil then 
						for k, item in pairs(result[1].gloveboxitems) do
							local itemInfo = Framework.Shared.Items[item.name:lower()]
							items[item.slot] = {
								name = itemInfo["name"],
								amount = tonumber(item.amount),
								info = item.info ~= nil and item.info or "",
								label = itemInfo["label"],
								description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
								weight = itemInfo["weight"], 
								type = itemInfo["type"], 
								unique = itemInfo["unique"], 
								useable = itemInfo["useable"], 
								image = itemInfo["image"],
								slot = item.slot,
							}
						end
					end
				end
			end
		end)
	return items
end

function SaveOwnedGloveboxItems(plate, items)
	if Gloveboxes[plate].label ~= "Glovebox-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end

			Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_inventory-vehicle` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					Framework.Functions.ExecuteSql(false, "UPDATE `characters_inventory-vehicle` SET `gloveboxitems` = '"..json.encode(items).."' WHERE `plate` = '"..plate.."'", function(result) 
						Gloveboxes[plate].isOpen = false
					end)
				else
					Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_inventory-vehicle` (`plate`, `gloveboxitems`) VALUES ('"..plate.."', '"..json.encode(items).."')", function(result) 
						Gloveboxes[plate].isOpen = false
					end)
				end
			end)
		end
	end
end

function AddToGlovebox(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = Framework.Shared.Items[itemName]

	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = Framework.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromGlovebox(plate, slot, itemName, amount)
	if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].amount > amount then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
		else
			Gloveboxes[plate].items[slot] = nil
			if next(Gloveboxes[plate].items) == nil then
				Gloveboxes[plate].items = {}
			end
		end
	else
		Gloveboxes[plate].items[slot]= nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
end

-- Drop items
function AddToDrop(dropId, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = Framework.Shared.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo["name"],
			amount = amount,
			info = info ~= nil and info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = slot,
			id = dropId,
		}
	end
end

function RemoveFromDrop(dropId, slot, itemName, amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
			if next(Drops[dropId].items) == nil then
				Drops[dropId].items = {}
			end
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

function CreateDropId()
	if Drops ~= nil then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] ~= nil do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

function CreateNewDrop(source, fromSlot, toSlot, itemAmount)
	local Player = Framework.Functions.GetPlayer(source)
	local itemData = Player.Functions.GetItemBySlot(fromSlot)
	if Player.Functions.RemoveItem(itemData.name, itemAmount, itemData.slot) then
		TriggerClientEvent("pepe-inventory:client:CheckWeapon", source, itemData.name)
		local itemInfo = Framework.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo["name"],
			amount = itemAmount,
			info = itemData.info ~= nil and itemData.info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = toSlot,
			id = dropId,
		}
		TriggerEvent("pepe-logs:server:SendLog", "drop", "New Item Drop", "red", "**".. GetPlayerName(source) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..source.."*) New dropped item; name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**")
		TriggerClientEvent("pepe-inventory:client:DropItemAnim", source)
		TriggerClientEvent("pepe-inventory:client:AddDropItem", -1, dropId, source)
		if itemData.name:lower() == "radio" then
		TriggerClientEvent('pepe-radio:drop:radio', source)
		end
	else
		TriggerClientEvent("Framework:Notify", src, "You dont have this item.", "error")
		return
	end
end

Framework.Commands.Add("resetinv", "Reset inventory (in case for -None)", {{name="type", help="stash/trunk/glovebox"},{name="id/plate", help="ID of stash or licenseplate"}}, true, function(source, args)
	local invType = args[1]:lower()
	table.remove(args, 1)
	local invId = table.concat(args, " ")
	if invType ~= nil and invId ~= nil then 
		if invType == "trunk" then
			if Trunks[invId] ~= nil then 
				Trunks[invId].isOpen = false
			end
		elseif invType == "glovebox" then
			if Gloveboxes[invId] ~= nil then 
				Gloveboxes[invId].isOpen = false
			end
		elseif invType == "stash" then
			if Stashes[invId] ~= nil then 
				Stashes[invId].isOpen = false
			end
		else
			TriggerClientEvent('Framework:Notify', source,  "No valid type.", "error")
		end
	else
		TriggerClientEvent('Framework:Notify', source,  "Please fill in all arguments.", "error")
	end
end, "admin")

Framework.Commands.Add("giveitem", "Give item to player.", {{name="id", help="CID"},{name="item", help="name of item (not label)"}, {name="Amount", help="Amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[3])
	local itemData = Framework.Shared.Items[tostring(args[2]):lower()]
	if Player ~= nil then
		if amount > 0 then
			if itemData ~= nil then
				local info = {}
				if itemData["name"] == "id-card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				elseif itemData["type"] == "weapon" then
					amount = 1
					info.quality = 100.0
					info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
				elseif itemData["name"] == 'markedbills' then
					info.worth = math.random(3000,5000)
				elseif itemData['name'] == 'burger-box' then
					info.boxid = math.random(11111,99999)
				elseif itemData['name'] == 'duffel-bag' then
					info.bagid = math.random(11111,99999)
				end
				if Player.Functions.AddItem(itemData["name"], amount, false, info) then
					TriggerClientEvent('pepe-inventory:client:ItemBox', tonumber(args[1]), Framework.Shared.Items[itemData["name"]], 'add')
					TriggerClientEvent('Framework:Notify', source, "You gave " ..GetPlayerName(tonumber(args[1])).." to " .. itemData["name"] .. " ("..amount.. ")", "success")
				else
					TriggerClientEvent('Framework:Notify', source,  "Can not give this item, inventory full?", "error")
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Item does not exist")
			end
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Amount must be higher then 0.")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Citizen not available.")
	end
end, "admin")

Framework.Functions.CreateUseableItem("id-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("pepe-inventory:client:ShowId", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)

Framework.Functions.CreateUseableItem("drive-card", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("pepe-inventory:client:ShowDriverLicense", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)